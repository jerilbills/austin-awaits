using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public class CompanySqlDao : ICompanyDao
    {
        public List<Item> AddItem(Item itemToAdd)
        {
            throw new System.NotImplementedException();
        }

        public List<Item> GetCatalog()
        {
            throw new System.NotImplementedException();
        }

        public List<Item> GetInventory()
        {
            throw new System.NotImplementedException();
        }

        public int GetInventoryItemQuantity(Item itemToCheck)
        {
            throw new System.NotImplementedException();
        }

        public int RemoveItem(Item itemToRemove)
        {
            throw new System.NotImplementedException();
        }
    }
}
