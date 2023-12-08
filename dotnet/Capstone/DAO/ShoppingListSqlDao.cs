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

        public List<ShoppingList> GetShoppingListsByDepartmentID(int departmentId)
        {
            string sql = "SELECT list_id, list_name, department_id, " +
                "list_status_id, list_owner_user_id, due_date_utc, " +
                "created_date_utc, last_modified_date_utc, is_active " +
                "FROM lists WHERE department_id = @department_id;";
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@department_id", departmentId);
                    
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

        public List<ShoppingList> GetShoppingListsByUserID(int userId)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            string sql = "SELECT lists.list_id, list_name, department_id, " +
                "list_status_id, list_owner_user_id, due_date_utc, " +
                "last_modified_date_utc, is_active FROM users_lists " +
                "JOIN lists ON lists.list_id = users_lists.list_id " +
                "WHERE user_id = @user_id;";

            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user_id", userId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read()){
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


        public ShoppingList MapRowToShoppingList(SqlDataReader reader)
        {
            ShoppingList ShoppingList = new ShoppingList();
            ShoppingList.Id = Convert.ToInt32(reader["list_id"]);
            ShoppingList.OwnerId = Convert.ToInt32(reader["list_owner_user_id"]);
            ShoppingList.Name = Convert.ToString(reader["list_name"]);
            ShoppingList.DueDate = Convert.ToDateTime(reader["due_date_utc"]);
            ShoppingList.Status = Convert.ToInt32(reader["list_status_id"]);
            ShoppingList.IsActive = Convert.ToBoolean(reader["is_active"]);
            ShoppingList.CreatedDate = Convert.ToDateTime(reader["created_date_utc"]);
            ShoppingList.LastModified = Convert.ToDateTime(reader["last_modified_date_utc"]);
            ShoppingList.DeparmentId = Convert.ToInt32(reader["department_id"]);

            return ShoppingList;


        }

    }
}
