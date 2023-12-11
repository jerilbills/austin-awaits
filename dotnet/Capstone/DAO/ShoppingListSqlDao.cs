using Capstone.Exceptions;
using Capstone.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net.NetworkInformation;
using System.Text.RegularExpressions;

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

        public ShoppingList CreateShoppingList(ShoppingList newShoppingList)
        {
            string sql = "INSERT INTO lists (list_name, department_id, " +
                "list_status_id, list_owner_user_id, due_date_utc, " +
                "created_date_utc, last_modified_date_utc, is_active) " +
                "VALUES (@list_name, @department_id, @list_status_id, " +
                "@list_owner_user_id, @due_date, @created_date, " +
                "@last_modified_date, @is_active)";

            ShoppingList output = null;
            int newListId = 0;

            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@list_name", newShoppingList.Name);
                    cmd.Parameters.AddWithValue("@department_id", newShoppingList.DepartmentId);
                    cmd.Parameters.AddWithValue("@list_status_id", newShoppingList.Status);
                    cmd.Parameters.AddWithValue("@list_owner_user_id", newShoppingList.OwnerId);
                    cmd.Parameters.AddWithValue("@due_date", newShoppingList.DueDate);
                    cmd.Parameters.AddWithValue("@created_date", DateTime.UtcNow);
                    cmd.Parameters.AddWithValue("@last_modified_date", DateTime.UtcNow);
                    cmd.Parameters.AddWithValue("@is_active", true);

                    newListId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                if (newListId != 0)
                {
                    output = GetActiveShoppingListById(newListId);
                }
            }
            catch (Exception)
            {
                throw new DaoException();
            }

            return output;
        }

        public int DeleteItem(Item itemToDelete)
        {
            throw new System.NotImplementedException();
        }

        public int DeleteShoppingList(ShoppingList listToDelete)
        {
            throw new System.NotImplementedException();
        }

        public List<ShoppingList> GetAllActiveShoppingLists()
        {
            string sql = "SELECT lists.list_id, list_name, " +
                "departments.department_id, list_status_id, " +
                "list_owner_user_id, due_date_utc, lists.created_date_utc, " +
                "lists.last_modified_date_utc, lists.is_active, username, " +
                "user_role, first_name, last_name, avatar_url, " +
                "lists.department_id, department_name, " +
                "COUNT(list_items.item_id) AS number_of_items " +
                "FROM lists LEFT JOIN users " +
                "ON lists.list_owner_user_id = users.user_id " +
                "LEFT JOIN departments " +
                "ON lists.department_id = departments.department_id " +
                "LEFT JOIN list_items " +
                "ON lists.list_id = list_items.list_id " +
                "WHERE list_status_id = 1 " +
                "GROUP BY lists.list_id, lists.list_name, lists.department_id, " +
                "departments.department_id, departments.department_name, " +
                "lists.list_status_id, lists.list_owner_user_id, " +
                "lists.due_date_utc, lists.created_date_utc, " +
                "lists.last_modified_date_utc, lists.is_active, users.username, " +
                "users.user_role, users.first_name, users.last_name, " +
                "users.avatar_url; ";

            List<ShoppingList> output = new List<ShoppingList>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);

                    SqlDataReader reader = cmd.ExecuteReader();

                    while(reader.Read())
                    {
                        ShoppingList shoppingList = MapRowToShoppingList(reader);
                        output.Add(shoppingList);
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }

            return output;
        }

        public ShoppingList PurchaseItem(Item itemToPurchase)
        {
            throw new System.NotImplementedException();
        }

        public ShoppingList GetActiveShoppingListById(int listId)
        {
            string sql = @"SELECT L.list_id, L.list_name, L.department_id, D.department_name,
                        COUNT(LI.item_id) AS number_of_items,
                        L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                        L.created_date_utc, L.last_modified_date_utc, L.is_active, 
                         users.username, users.user_role, users.first_name, 
                         users.last_name, users.avatar_url, users.department_id 
                        FROM lists AS L
                        JOIN departments AS D ON D.department_id = L.department_id
                        JOIN users ON L.list_owner_user_id = users.user_id
                        LEFT JOIN list_items AS LI ON LI.list_id = L.list_id
                        WHERE L.list_id = @listId AND L.is_active = 1 AND LI.is_active = 1 
                        GROUP BY L.list_id, L.list_name, L.department_id, D.department_name,
                        L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                        L.created_date_utc, L.last_modified_date_utc, L.is_active, 
                         users.username, users.user_role, users.first_name, 
                         users.last_name, users.avatar_url, users.department_id ;";

            ShoppingList output = null;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@listId", listId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        output = new ShoppingList();
                        output = MapRowToShoppingList(reader);
                    }
                }
            }
            catch (Exception)
            {
                throw new DaoException();
            }
            return output;
        }

        public ShoppingList UpdateShoppingList(ShoppingList listToUpdate)
        {
            string sql = @"UPDATE lists
                        SET list_name = @listName, department_id = @departmentId, list_status_id = @listStatusId,
                        list_owner_user_id = @listOwnerId, due_date_utc = @dueDate, 
                        last_modified_date_utc = @lastModifiedDate
                        WHERE list_id = @list_id";

            ShoppingList output = null;

            int rowsAffected = 0;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@list_id", listToUpdate.ListId);
                    cmd.Parameters.AddWithValue("@listName", listToUpdate.Name);
                    cmd.Parameters.AddWithValue("@departmentId", listToUpdate.DepartmentId);
                    cmd.Parameters.AddWithValue("@listStatusId", listToUpdate.Status);
                    cmd.Parameters.AddWithValue("@listOwnerId", listToUpdate.OwnerId);
                    cmd.Parameters.AddWithValue("@dueDate", listToUpdate.DueDate);
                    cmd.Parameters.AddWithValue("@lastModifiedDate", listToUpdate.LastModified);

                    rowsAffected = cmd.ExecuteNonQuery();
                }
                if (rowsAffected == 0)
                {
                    return output;
                }
                else
                {
                    output = GetActiveShoppingListById(listToUpdate.ListId);
                }
            }
            catch (Exception)
            {
                throw new DaoException();
            }
            return output;
        }

        public List<ShoppingList> GetActiveShoppingListsByDepartmentID(int departmentId, int status)
        {
            string sql = @"SELECT L.list_id, L.list_name, L.department_id, D.department_name,
                         COUNT(LI.item_id) AS number_of_items,
                         L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                         L.created_date_utc, L.last_modified_date_utc, L.is_active, 
                         users.username, users.user_role, users.first_name, 
                         users.last_name, users.avatar_url, users.department_id
                         FROM lists AS L
                         JOIN departments AS D ON D.department_id = L.department_id
                         JOIN users ON L.list_owner_user_id = users.user_id
                         LEFT JOIN list_items AS LI ON LI.list_id = L.list_id
                         WHERE L.department_id = @departmentId AND L.is_active = 1 AND LI.is_active = 1 " +

                        ((status != 0) ? " AND L.list_status_id = @status " : "")

                        + @"GROUP BY L.list_id, L.list_name, L.department_id, D.department_name,
                        L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                        L.created_date_utc, L.last_modified_date_utc, L.is_active, 
                        users.username, users.user_role, users.first_name, 
                        users.last_name, users.avatar_url, users.department_id;";


            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@departmentId", departmentId);
                    cmd.Parameters.AddWithValue("@status", status);

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
                         L.created_date_utc, L.last_modified_date_utc, L.is_active, 
                         users.username, users.user_role, users.first_name, 
                         users.last_name, users.avatar_url, users.department_id
                         FROM users_lists AS UL 
                         JOIN lists AS L ON L.list_id = UL.list_id
                         JOIN departments AS D ON D.department_id = L.department_id
                         LEFT JOIN list_items AS LI ON LI.list_id = L.list_id
                                      JOIN users ON L.list_owner_user_id = users.user_id
                         WHERE UL.user_id = @userId AND L.is_active = 1 AND LI.is_active = 1 " +

                          ((status != 0) ? " AND L.list_status_id = @status " : "")

                           + @"GROUP BY L.list_id, L.list_name, L.department_id, D.department_name,
                           L.list_status_id, L.list_owner_user_id, L.due_date_utc,
                           L.created_date_utc, L.last_modified_date_utc, L.is_active, 
                            users.username, users.user_role, users.first_name, 
                            users.last_name, users.avatar_url, users.department_id;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
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

        public ShoppingList MapRowToShoppingList(SqlDataReader reader)
        {
            ShoppingList shoppingList = new ShoppingList();

            shoppingList.ListId = Convert.ToInt32(reader["list_id"]);
            shoppingList.OwnerId = Convert.ToInt32(reader["list_owner_user_id"]);

            // map ListOwner id to ListOwner object
            shoppingList.ListOwner = new User();
            shoppingList.ListOwner.UserId = shoppingList.OwnerId;
            shoppingList.ListOwner.Username = Convert.ToString(reader["username"]);
            shoppingList.ListOwner.Role = Convert.ToString(reader["user_role"]);
            shoppingList.ListOwner.FirstName = Convert.ToString(reader["first_name"]);
            shoppingList.ListOwner.LastName = Convert.ToString(reader["last_name"]);
            shoppingList.ListOwner.AvatarUrl = Convert.ToString(reader["avatar_url"]);
            shoppingList.ListOwner.DepartmentId = Convert.ToInt32(reader["department_id"]);
            
            // resume normal mapping to ShoppingList
            shoppingList.Name = Convert.ToString(reader["list_name"]);
            shoppingList.DueDate = Convert.ToDateTime(reader["due_date_utc"]);
            shoppingList.Status = Convert.ToInt32(reader["list_status_id"]);
            shoppingList.IsActive = Convert.ToBoolean(reader["is_active"]);
            shoppingList.CreatedDate = Convert.ToDateTime(reader["created_date_utc"]);
            shoppingList.LastModified = Convert.ToDateTime(reader["last_modified_date_utc"]);
            shoppingList.DepartmentId = Convert.ToInt32(reader["department_id"]);
            shoppingList.DepartmentName = Convert.ToString(reader["department_name"]);
            shoppingList.NumberOfItems = Convert.ToInt32(reader["number_of_items"]);

            return shoppingList;
        }
    }
}
