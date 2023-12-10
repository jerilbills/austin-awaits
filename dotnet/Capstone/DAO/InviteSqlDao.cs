using Capstone.Exceptions;
using Capstone.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net.NetworkInformation;

namespace Capstone.DAO
{
    public class InviteSqlDao : IInviteDao
    {
        private readonly string connectionString;

        public InviteSqlDao(string dbConnectionString)
        {
            connectionString = dbConnectionString;
        }
        public int AddUserToList(Invite userListToAdd)
        {
            int rowsAffected = 0;
            string sql = "INSERT INTO users_lists (user_id, list_id) VALUES (@user_id, @list_id);";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user_id", userListToAdd.InvitedUser.UserId);
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
