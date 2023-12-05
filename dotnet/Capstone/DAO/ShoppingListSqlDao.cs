using Capstone.Exceptions;
using Capstone.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Capstone.DAO
{
    public class ShoppingListSqlDao : IShoppingListDao
    {
        private static string connectionString;
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
            string sql = "SELECT *" +
                "FROM ShoppingList" +
                "WHERE department_id = @departmentId";
            List<ShoppingList> output = null;
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


        public ShoppingList MapRowToShoppingList(SqlDataReader reader)
        {
            ShoppingList ShoppingList = new ShoppingList();
            ShoppingList.Id = Convert.ToInt32(reader["id"]);
            ShoppingList.OwnerId = Convert.ToInt32(reader["ownerId"]);
            ShoppingList.Name = Convert.ToString(reader["name"]);
            ShoppingList.ClaimantId = Convert.ToInt32(reader["claimant_id"]);
            ShoppingList.DueDate = Convert.ToDateTime(reader["due_date"]);
            ShoppingList.Status = Convert.ToInt32(reader["status"]);
            ShoppingList.IsActive = Convert.ToBoolean(reader["is_Active"]);
            ShoppingList.CreatedDate = Convert.ToDateTime(reader["created_date"]);
            ShoppingList.LastModified = Convert.ToDateTime(reader["last_modified"]);

            return ShoppingList;


        }


    }
}
