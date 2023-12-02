using Capstone.Models;

namespace Capstone.DAO
{
    public interface IInviteDao
    {
        public Inventory AddItem(Item itemToAdd);
        public Inventory RemoveItem(Item itemToRemove);
        public Inventory GetInventory();
        public int GetInventoryItemQuantity(Item itemToCheck);
    }
}
