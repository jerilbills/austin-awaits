using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IShoppingListDao
    {
        public ShoppingList CreateShoppingList();
        public ShoppingList UpdateShoppingList(ShoppingList listToUpdate);
        public int DeleteShoppingList(ShoppingList listToDelete);
        public ShoppingList AddItem(Item itemToAdd);
        public int DeleteItem(Item itemToDelete);
        public ShoppingList PurchaseItem(Item itemToPurchase);
        public ShoppingList GetShoppingListById(int id);
        public List<ShoppingList> GetShoppingLists();
        public List<ShoppingList> GetActiveShoppingListsByDepartmentID(int departmentId);
        public List<ShoppingList> GetActiveInvitedShoppingListsByUserID(int userId);
        public int AddUserToList(UserList userList);

    }
}
