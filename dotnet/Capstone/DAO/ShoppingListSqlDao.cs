using Capstone.Exceptions;
using Capstone.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Capstone.DAO
{
    public class ShoppingListSqlDao : IShoppingListDao
    {
        private readonly string connectionString;

        public ShoppingListSqlDao(string dbConnectionString)
        {
            connectionString = dbConnectionString;
        }
        public ShoppingList AddItem(Item itemToAdd)
        {
            throw new System.NotImplementedException();
        }

        public ShoppingList CreateShoppingList()
        {
            throw new System.NotImplementedException();
        }

        public int DeleteItem(Item itemToDelete)
        {
            throw new System.NotImplementedException();
        }

        public int DeleteShoppingList(ShoppingList listToDelete)
        {
            throw new System.NotImplementedException();
        }

        public ShoppingList GetShoppingListById(int id)
        {
            throw new System.NotImplementedException();
        }

        public List<ShoppingList> GetShoppingLists()
        {
            throw new System.NotImplementedException();
        }

        public ShoppingList PurchaseItem(Item itemToPurchase)
        {
            throw new System.NotImplementedException();
        }

        public ShoppingList UpdateShoppingList(ShoppingList listToUpdate)
        {
            throw new System.NotImplementedException();
        }

        public List<ShoppingList> GetActiveShoppingListsByDepartmentID(int departmentId, int status)
        {
            string sql = @"SELECT L.list_id, L.list_name, L.department_id, D.department_name,
                        COUNT(LI.item_id) AS number_of_items,
                        L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                        L.created_date_utc, L.last_modified_date_utc, L.is_active
                        FROM lists AS L
                        JOIN departments AS D ON D.department_id = L.department_id
                        LEFT JOIN list_items AS LI ON LI.list_id = L.list_id
                        WHERE L.department_id = @departmentId AND L.is_active = 1 AND LI.is_active = 1 " +

                        ((status != 0) ? " AND L.list_status_id = @status " : "")

                        + @"GROUP BY L.list_id, L.list_name, L.department_id, D.department_name,
                        L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                        L.created_date_utc, L.last_modified_date_utc, L.is_active;";

            
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@departmentId", departmentId);
                    cmd.Parameters.AddWithValue ("@status", status);
                    
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        output.Add(MapRowToShoppingList(reader));
                    }
                }

            }
            catch (Exception)
            {
                throw new DaoException();
            }
            return output;

        }

        public List<ShoppingList> GetActiveInvitedShoppingListsByUserID(int userId, int status)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            string sql = @"SELECT L.list_id, L.list_name, L.department_id, D.department_name,
                        COUNT(LI.item_id) AS number_of_items,
                        L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                        L.created_date_utc, L.last_modified_date_utc, L.is_active
                        FROM users_lists AS UL 
                        JOIN lists AS L ON L.list_id = UL.list_id
                        JOIN departments AS D ON D.department_id = L.department_id
                        LEFT JOIN list_items AS LI ON LI.list_id = L.list_id
                        WHERE user_id = @userId AND L.is_active = 1 AND LI.is_active = 1 " +

                        ((status != 0) ? " AND L.list_status_id = @status " : "")

                        + @"GROUP BY L.list_id, L.list_name, L.department_id, D.department_name,
                        L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                        L.created_date_utc, L.last_modified_date_utc, L.is_active;";

            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@userId", userId);
                    cmd.Parameters.AddWithValue("@status", status);

                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        ShoppingList shoppingList = MapRowToShoppingList(reader);
                        output.Add(shoppingList);
                    }
                }
            }
            catch (Exception)
            {

                throw new DaoException();
            }

            return output;

        }

        public int AddUserToList(UserList userListToAdd)
        {
            int rowsAffected = 0;
            string sql = "INSERT INTO users_lists (user_id, list_id) VALUES (@user_id, @list_id);";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user_id", userListToAdd.UserId);
                    cmd.Parameters.AddWithValue("@list_id", userListToAdd.ListId);

                    rowsAffected = cmd.ExecuteNonQuery();

                }
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }
            catch (Exception)
            {

            }

            return rowsAffected;
        }

        public ShoppingList MapRowToShoppingList(SqlDataReader reader)
        {
            ShoppingList ShoppingList = new ShoppingList();

            ShoppingList.ListId = Convert.ToInt32(reader["list_id"]);
            ShoppingList.OwnerId = Convert.ToInt32(reader["list_owner_user_id"]);
            ShoppingList.Name = Convert.ToString(reader["list_name"]);
            ShoppingList.DueDate = Convert.ToDateTime(reader["due_date_utc"]);
            ShoppingList.Status = Convert.ToInt32(reader["list_status_id"]);
            ShoppingList.IsActive = Convert.ToBoolean(reader["is_active"]);
            ShoppingList.CreatedDate = Convert.ToDateTime(reader["created_date_utc"]);
            ShoppingList.LastModified = Convert.ToDateTime(reader["last_modified_date_utc"]);
            ShoppingList.DepartmentId = Convert.ToInt32(reader["department_id"]);
            ShoppingList.DepartmentName = Convert.ToString(reader["department_name"]);
            ShoppingList.NumberOfItems = Convert.ToInt32(reader["number_of_items"]);

            return ShoppingList;
        }
    }
}
