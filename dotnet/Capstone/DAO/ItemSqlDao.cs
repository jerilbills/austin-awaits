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

      
        public Item UpdateItem(Item itemToUpdate)
        {
            throw new System.NotImplementedException();
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
