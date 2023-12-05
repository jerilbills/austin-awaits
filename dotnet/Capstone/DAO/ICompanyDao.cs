using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface ICompanyDao
    {
        public List<Item> AddItem(Item itemToAdd);
        public int RemoveItem(Item itemToRemove);
        public List<Item> GetInventory();
        public List<Item> GetCatalog();
        public int GetInventoryItemQuantity(Item itemToCheck);
    }
}
