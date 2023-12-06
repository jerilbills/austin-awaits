using Capstone.Exceptions;
using Capstone.Models;
using System.Data.SqlClient;
using System.Security.Cryptography.Xml;
using System;

namespace Capstone.DAO
{
    public class ListItemSqlDao : IListItemDao
    {
        private static string connectionString;

        public ListItem UpdateListItem(int listId, int itemId, int status)
        {

            string sql = "UPDATE list_items SET list_item_status_id = @status WHERE list_id = @ListId AND item_id = @ItemId;";

            ListItem output = null;

            int rowsAffected = 0;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@status", status);
                    cmd.Parameters.AddWithValue("@ListId", listId);
                    cmd.Parameters.AddWithValue("@ItemId", itemId);


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
            string sql = @"SELECT list_id, item_id, quantity, 
                list_item_claimed_by_user_id, list_item_status_id, 
                created_date_utc, last_modified_by_user_id, 
                last_modified_date_utc, is_active 
                FROM list_items WHERE list_id = @ListId AND item_id = @ItemId;";
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


        private ListItem MapRowToListItem(SqlDataReader reader)
        {
            ListItem listItem = new ListItem();
            listItem.ListID = Convert.ToInt32(reader["list_id"]);
            listItem.ItemID = Convert.ToInt32(reader["item_id"]);
            listItem.IsActive = Convert.ToBoolean(reader["is_active"]);
            listItem.LastModifiedBy = Convert.ToInt32(reader["last_modified_by_user_id"]);
            listItem.CreatedBy = Convert.ToInt32(reader["createdBy"]);
            listItem.Quantity = Convert.ToInt32(reader["quantity"]);
            listItem.CreatedDate = Convert.ToDateTime(reader["created_date_utc"]);
            listItem.ClaimedBy = Convert.ToInt32(reader["list_item_claimed_by_user_id"]);
            listItem.ListItemStatusId = Convert.ToInt32(reader["list_item_status_id"]);
            listItem.LastModifiedDate = Convert.ToDateTime(reader["last_modified_date_utc"]);
            return listItem;
        }

    }


}
