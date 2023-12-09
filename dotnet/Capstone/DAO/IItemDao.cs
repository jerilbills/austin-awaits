using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IItemDao
    {
        public Item CreateItem(Item newItem);
        public Item UpdateItem(Item itemToUpdate);

        public List<Item> GetAllActiveItems();
        public Item GetItemByItemId(int itemId);

        



    }
}
