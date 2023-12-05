using Capstone.Exceptions;
using Capstone.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Capstone.DAO
{
    public class ItemSqlDao : IItemDao
    {
        private static string connectionString;
        public Item CreateItem()
        {
            throw new System.NotImplementedException();
        }

        public Item GetItemById(int id)
        {
            throw new System.NotImplementedException();
        }

        public List<Item> GetItems()
        {
            throw new System.NotImplementedException();
        }

        public List<Item> GetItemsByListId(int listID)
        {
            string sql = "SELECT items.item_id, item_name, item_description, item_image_url, is_tracked_inventory, created_by_user_id, items.created_date_utc, items.last_modified_by_user_id, items.last_modified_date_utc, items.is_active, list_id, items.item_id, quantity, list_item_claimed_by_user_id, list_item_status_id, items.created_date_utc, items.last_modified_by_user_id, items.last_modified_date_utc, items.is_active " +
                "FROM items JOIN list_items ON list_items.item_id = items.item_id " +
                "WHERE list_id = @listID;";
            List<Item> output = new List<Item>();
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
                        output.Add(MapRowToItem(reader));
                    }
                }

            }
            catch (Exception)
            {
                throw new DaoException();
            }
            return output;
        }

        public Item UpdateItem(Item itemToUpdate)
        {
            throw new System.NotImplementedException();
        }


        public Item MapRowToItem(SqlDataReader reader)
        {
            Item item = new Item();
            item.Id = Convert.ToInt32(reader["item_id"]);
            item.CreatedBy = Convert.ToInt32(reader["created_by_user_id"]);
            item.CreatedDate = Convert.ToDateTime(reader["created_date_utc"]);
            item.Description = Convert.ToString(reader["item_description"]);
            item.ImgUrl = Convert.ToString(reader["item_image_url"]);
            item.IsActive = Convert.ToBoolean(reader["is_active"]);
            item.isTrackedInventory = Convert.ToBoolean(reader["is_tracked_inventory"]);
            item.LastModifiedBy = Convert.ToInt32(reader["last_modified_by_user_id"]);
            item.LastModifiedDate = Convert.ToDateTime(reader["last_modified_date_utc"]);
            item.Name = Convert.ToString(reader["item_name"]);
            return item;


        }
    }
}
