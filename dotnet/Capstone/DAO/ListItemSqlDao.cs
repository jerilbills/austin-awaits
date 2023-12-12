using Capstone.Exceptions;
using Capstone.Models;
using System.Data.SqlClient;
using System.Security.Cryptography.Xml;
using System;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public class ListItemSqlDao : IListItemDao
    {
        private readonly string connectionString;
        public ListItemSqlDao(string dbConnectionString)
        {
            connectionString = dbConnectionString;
        }


        public ListItem UpdateListItemStatusAndClaimant(int listId, int itemId, int updatingUserId, ListItem itemToUpdate)
        {

            //edit sql to change the userID as well
            string sql = "UPDATE list_items SET list_item_status_id = @status, list_item_claimed_by_user_id = @userId, " +
                "last_modified_date_utc = GETUTCDATE(), last_modified_by_user_id = @updatinguserid WHERE list_id = @ListId AND item_id = @ItemId;";

            ListItem output = null;

            int rowsAffected = 0;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@status", itemToUpdate.ListItemStatusId);
                    cmd.Parameters.AddWithValue("@ListId", listId);
                    cmd.Parameters.AddWithValue("@ItemId", itemId);
                    cmd.Parameters.AddWithValue("@userId", (itemToUpdate.ClaimedBy == null) ? DBNull.Value : itemToUpdate.ClaimedBy);
                    cmd.Parameters.AddWithValue("@updatinguserid", updatingUserId);

                    rowsAffected = cmd.ExecuteNonQuery();

                }
                if (rowsAffected == 0)
                {
                    return output;
                }
                else
                {
                    output = GetActiveListItemById(itemId, listId);
                    

                }
            }
            catch (Exception)
            {
                throw new DaoException();
            }
            return output;
        }

        public ListItem GetActiveListItemById(int itemId, int listId)
        {
            string sql = @"SELECT list_id, LI.item_id, quantity, 
                        list_item_claimed_by_user_id, list_item_status_id, 
                        LI.created_date_utc, LI.last_modified_by_user_id, item_name, item_description, item_image_url, 
                        LI.last_modified_date_utc, LI.is_active, U.username, U.first_name, U.last_name, U.department_id, U.user_role, U.avatar_url
                        FROM list_items as LI
                        JOIN items AS I on LI.item_id = I.item_id
                        LEFT JOIN users AS U ON U.user_id = LI.list_item_claimed_by_user_id
                        WHERE list_id = @listId AND LI.item_id = @itemId AND LI.is_active = 1;";
            ListItem output = null;
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@listId", listId);
                    cmd.Parameters.AddWithValue("@itemId", itemId);
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        output = MapRowToListItem(reader);
                    }
                }
               
            }

            catch (Exception)
            {
                throw new DaoException();
            }
            return output;
        }

        public List<ListItem> GetActiveListItemsByListId(int listId)
        {
            //use listID parameter in sql string
            string sql = @"SELECT list_id, LI.item_id, quantity, 
                    list_item_claimed_by_user_id, list_item_status_id, 
                    LI.created_date_utc, LI.last_modified_by_user_id, item_name, item_description, item_image_url, 
                    LI.last_modified_date_utc, LI.is_active, U.username, U.first_name, U.last_name, U.department_id, U.user_role, U.avatar_url
                    FROM list_items as LI
                    JOIN items AS I on LI.item_id = I.item_id
                    LEFT JOIN users AS U ON U.user_id = LI.list_item_claimed_by_user_id
                    WHERE list_id = @listId AND LI.is_active = 1;";
            List<ListItem> output = new List<ListItem>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@listId", listId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        output.Add(MapRowToListItem(reader));
                    }
                }

            }
            catch (Exception)
            {
                throw new DaoException();
            }
            return output;
        }

        public List<ListItem> FilterListByClaimant(int listId, int userId)
        {
            List<ListItem> output = new List<ListItem>();

            string sql = "SELECT li.list_id, li.item_id, li.is_active, li.last_modified_by_user_id, li.quantity, " +
                "li.created_date_utc, li.list_item_claimed_by_user_id, u.username, u.user_role, u.first_name, " +
                "u.last_name, u.avatar_url, u.department_id, li.list_item_status_id, li.last_modified_date_utc, " +
                "i.item_name, i.item_description, i.item_image_url " +
                "FROM list_items AS li " +
                "JOIN ITEMS AS i ON i.item_id = li.item_id JOIN users AS u ON u.user_id = li.list_item_claimed_by_user_id " +
                "WHERE li.list_item_claimed_by_user_id = @userId AND li.list_id = @listId;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);

                    cmd.Parameters.AddWithValue("@listId", listId);
                    cmd.Parameters.AddWithValue("@userId", userId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        output.Add(MapRowToListItem(reader));
                    }
                }
            }
            catch (Exception)
            {

                throw new DaoException();
            }
            return output;
        }

        public List<ListItem> FilterListByUnassigned(int listId)
        {
            List<ListItem> output = new List<ListItem>();

            string sql = "SELECT li.list_id, li.item_id, li.is_active, li.last_modified_by_user_id, li.quantity, li.created_date_utc, " +
                "li.list_item_claimed_by_user_id, li.list_item_status_id, li.last_modified_date_utc, i.item_name, i.item_description, i.item_image_url " +
                "FROM list_items AS li JOIN ITEMS AS i ON i.item_id = li.item_id " +
                "WHERE li.list_item_claimed_by_user_id IS NULL AND li.list_id = @listId;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);

                    cmd.Parameters.AddWithValue("@listId", listId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        output.Add(MapRowToListItem(reader));
                    }
                }
            }
            catch (Exception)
            {

                throw new DaoException();
            }
            return output;
        }

        public int DeleteItem(int listId, int itemId)
        {
            int numberOfRows = 0;
            string sql = "DELETE FROM list_items WHERE list_id = @list_id AND item_id = @item_id;";
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@list_id", listId);
                    cmd.Parameters.AddWithValue("@item_id", itemId);

                    numberOfRows = cmd.ExecuteNonQuery();
                }
            }
            catch (Exception)
            {
                throw new DaoException();
            }

            return numberOfRows;
        }

        private ListItem MapRowToListItem(SqlDataReader reader)
        {

            ListItem listItem = new ListItem();

            listItem.ListId = Convert.ToInt32(reader["list_id"]);
            listItem.ItemId = Convert.ToInt32(reader["item_id"]);
            listItem.IsActive = Convert.ToBoolean(reader["is_active"]);
            listItem.LastModifiedBy = Convert.ToInt32(reader["last_modified_by_user_id"]);
            listItem.Quantity = Convert.ToInt32(reader["quantity"]);
            listItem.CreatedDate = Convert.ToDateTime(reader["created_date_utc"]);
            if (reader["list_item_claimed_by_user_id"] is DBNull)
            {
                listItem.ClaimedBy = 0;
            }
            else
            {
                listItem.ClaimedBy = Convert.ToInt32(reader["list_item_claimed_by_user_id"]);

                if (listItem.ClaimedBy != null)
                {
                    listItem.ClaimedByUser = new User();
                    listItem.ClaimedByUser.UserId = listItem.ClaimedBy.Value;
                    listItem.ClaimedByUser.Username = Convert.ToString(reader["username"]);
                    listItem.ClaimedByUser.Role = Convert.ToString(reader["user_role"]);
                    listItem.ClaimedByUser.FirstName = Convert.ToString(reader["first_name"]);
                    listItem.ClaimedByUser.LastName = Convert.ToString(reader["last_name"]);
                    listItem.ClaimedByUser.AvatarUrl = Convert.ToString(reader["avatar_url"]);
                    listItem.ClaimedByUser.DepartmentId = Convert.ToInt32(reader["department_id"]);
                }
            }

            listItem.ListItemStatusId = Convert.ToInt32(reader["list_item_status_id"]);
            listItem.LastModifiedDate = Convert.ToDateTime(reader["last_modified_date_utc"]);
            listItem.Name = Convert.ToString(reader["item_name"]);

            if (reader["item_description"] is DBNull)
            {
                listItem.Description = null;
            }
            else
            {
                listItem.Description = Convert.ToString(reader["item_description"]);
            }
            if (reader["item_image_url"] is DBNull)
            {
                listItem.ImgUrl = null;
            }
            else
            {
                listItem.ImgUrl = Convert.ToString(reader["item_image_url"]);

            }
           
            return listItem;
        }

    }


}
