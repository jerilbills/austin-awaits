using Capstone.Models;
using System;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IShoppingListDao
    {
        public ShoppingList CreateShoppingList(ShoppingList newList);
        public ShoppingList UpdateShoppingList(ShoppingList listToUpdate);
        public int DeleteShoppingList(ShoppingList listToDelete);
        public ShoppingList AddItem(Item itemToAdd);
        public int DeleteItem(Item itemToDelete);
        public ShoppingList PurchaseItem(Item itemToPurchase);
        public ShoppingList GetActiveShoppingListById(int listId);
        public List<ShoppingList> GetShoppingLists();
        public List<ShoppingList> GetActiveShoppingListsByDepartmentID(int departmentId, int status);
        public List<ShoppingList> GetActiveInvitedShoppingListsByUserID(int userId, int status);

    }
}
