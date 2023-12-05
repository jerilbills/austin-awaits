using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IItemDao
    {
        public Item CreateItem();
        public Item UpdateItem(Item itemToUpdate);
        public Item GetItemById(int id);
        public List<Item> GetItems();
    }
}
