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


        public ListItem UpdateListItem(int listId, int itemId, ListItem itemToUpdate)
        {

            //edit sql to change the userID as well
            string sql = "UPDATE list_items SET list_item_status_id = @status, list_item_claimed_by_user_id = @userId WHERE list_id = @ListId AND item_id = @ItemId;";

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
                    SqlParameter claimedByParam = cmd.Parameters.AddWithValue("@userId", itemToUpdate.ClaimedBy);
                    if (itemToUpdate.ClaimedBy == null)
                    {
                        claimedByParam.Value = DBNull.Value;
                    }
                    //add userID parameter


                    rowsAffected = cmd.ExecuteNonQuery();

                }
                if (rowsAffected == 0)
                {
                    return output;
                }
                else
                {
                    output = GetListItemById(itemId, listId);
                    

                }
            }
            catch (Exception)
            {
                throw new DaoException();
            }
            return output;
        }

        public ListItem GetListItemById(int itemId, int listId)
        {
            string sql = @"SELECT list_id, list_items.item_id, quantity, 
                list_item_claimed_by_user_id, list_item_status_id, 
                list_items.created_date_utc, list_items.last_modified_by_user_id, item_name, item_description, item_image_url, 
                list_items.last_modified_date_utc, list_items.is_active  FROM list_items JOIN items on list_items.item_id = items.item_id
				WHERE list_id = @ListId AND list_items.item_id = @ItemId;";
            ListItem output = null;
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ListId", listId);
                    cmd.Parameters.AddWithValue("@ItemId", itemId);
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

        public List<ListItem> GetListItemsByListId(int listID)
        {
            //use listID parameter in sql string
            string sql = "SELECT list_id, list_items.item_id, quantity, list_item_claimed_by_user_id, list_item_status_id, list_items.created_date_utc, list_items.last_modified_by_user_id, item_name, item_description, item_image_url, list_items.last_modified_date_utc, list_items.is_active" +
                " FROM list_items JOIN items on list_items.item_id = items.item_id WHERE list_id = @listID";
            List<ListItem> output = new List<ListItem>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@listID", listID);

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

        private ListItem MapRowToListItem(SqlDataReader reader)
        {

            ListItem listItem = new ListItem();

            


            listItem.ListID = Convert.ToInt32(reader["list_id"]);
            listItem.ItemID = Convert.ToInt32(reader["item_id"]);
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
