using Capstone.Exceptions;
using Capstone.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Capstone.DAO
{
    public class ItemSqlDao : IItemDao
    {
        private readonly string connectionString;

        public ItemSqlDao(string dbConnectionString)
        {
            connectionString = dbConnectionString;
        }

        public Item CreateItem(Item newItem)
        {
            string sql = "INSERT INTO items (item_name, item_description, " +
                "item_image_url, is_tracked_inventory, created_by_user_id, " +
                "created_date_utc, last_modified_by_user_id, " +
                "last_modified_date_utc, is_active) OUTPUT inserted.item_id " +
                "VALUES(@item_name, @item_description, @item_image_url, " +
                "@is_tracked, @created_by, @created_date, @last_modified_by, " +
                "@last_modified_date, @is_active);";

            Item output = null;
            int newItemId;

            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@item_name", newItem.Name);
                    cmd.Parameters.AddWithValue("@item_description", newItem.Description);
                    cmd.Parameters.AddWithValue("@item_image_url", newItem.ImgUrl);
                    cmd.Parameters.AddWithValue("@is_tracked", newItem.IsTrackedInventory);
                    cmd.Parameters.AddWithValue("@created_by", newItem.CreatedBy);
                    cmd.Parameters.AddWithValue("@created_date", newItem.CreatedDate);
                    cmd.Parameters.AddWithValue("@last_modified_by", newItem.LastModifiedBy);
                    cmd.Parameters.AddWithValue("@last_modified_date", newItem.LastModifiedDate);
                    cmd.Parameters.AddWithValue("@is_active", newItem.IsActive);

                    newItemId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                if (newItemId != 0)
                {
                    output = GetItemByItemId(newItemId);
                }

            }
            catch (Exception)
            {

                throw new DaoException();
            }

            return output;
        }

        public List<Item> GetAllActiveItems()
        {
            string sql = "SELECT item_id, item_name, item_description, " +
                "item_image_url, is_tracked_inventory, created_by_user_id, " +
                "created_date_utc, last_modified_by_user_id, " +
                "last_modified_date_utc, is_active FROM items;";

            
            List<Item> output = new List<Item>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
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

        public Item GetItemByItemId(int itemId)
        {
            string sql = "SELECT item_id, item_name, item_description, " +
                "item_image_url, is_tracked_inventory, created_by_user_id, " +
                "created_date_utc, last_modified_by_user_id, " +
                "last_modified_date_utc, is_active FROM items " +
                "WHERE item_id = @item_id;";

            Item output = null;

            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@item_id", itemId);
                    SqlDataReader reader = cmd.ExecuteReader();
                    
                    if (reader.Read())
                    {
                        output = MapRowToItem(reader);
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
            string sql = "UPDATE items SET item_name = @item_name, " +
                "item_description = @item_description, item_image_url = @item_image_url, " +
                "is_tracked_inventory = @is_tracked, " +
                "created_by_user_id = @created_by, " +
                "created_date_utc = @created_date, " +
                "last_modified_by_user_id = @last_modified_by, " +
                "last_modified_date_utc = @last_modified_date, is_active = @is_active " +
                "WHERE item_id = @item_id;";

            Item output = null;

            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);

                    cmd.Parameters.AddWithValue("@item_id", itemToUpdate.ItemId);
                    cmd.Parameters.AddWithValue("@item_name", itemToUpdate.Name);
                    cmd.Parameters.AddWithValue("@item_description", itemToUpdate.Description);
                    cmd.Parameters.AddWithValue("@item_image_url", itemToUpdate.ImgUrl);
                    cmd.Parameters.AddWithValue("@is_tracked", itemToUpdate.IsTrackedInventory);
                    cmd.Parameters.AddWithValue("@created_by", itemToUpdate.CreatedBy);
                    cmd.Parameters.AddWithValue("@created_date", itemToUpdate.CreatedDate);
                    cmd.Parameters.AddWithValue("@last_modified_by", itemToUpdate.LastModifiedBy);
                    cmd.Parameters.AddWithValue("@last_modified_date", itemToUpdate.LastModifiedDate);
                    cmd.Parameters.AddWithValue("@is_active", itemToUpdate.IsActive);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        output = MapRowToItem(reader);
                    }

                }
            }
            catch (Exception)
            {
                throw new DaoException();
            }

            return output;
        }


        public Item MapRowToItem(SqlDataReader reader)
        {
            Item item = new Item();
            item.ItemId = Convert.ToInt32(reader["item_id"]);
            item.CreatedBy = Convert.ToInt32(reader["created_by_user_id"]);
            item.CreatedDate = Convert.ToDateTime(reader["created_date_utc"]);
            item.Description = Convert.ToString(reader["item_description"]);
            item.ImgUrl = Convert.ToString(reader["item_image_url"]);
            item.IsActive = Convert.ToBoolean(reader["is_active"]);
            item.IsTrackedInventory = Convert.ToBoolean(reader["is_tracked_inventory"]);
            item.LastModifiedBy = Convert.ToInt32(reader["last_modified_by_user_id"]);
            item.LastModifiedDate = Convert.ToDateTime(reader["last_modified_date_utc"]);
            item.Name = Convert.ToString(reader["item_name"]);
            return item;


        }

    }
}
