﻿using Capstone.Models;
using System;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IShoppingListDao
    {
        public ShoppingList CreateShoppingList(ShoppingList newShoppingList);
        public ShoppingList UpdateShoppingList(ShoppingList listToUpdate);
        public int DeleteShoppingListByShoppingListId(int shoppingListId);
        public ShoppingList AddItem(Item itemToAdd);
        public ShoppingList PurchaseItem(Item itemToPurchase);
        public ShoppingList GetActiveShoppingListById(int listId);
        public List<ShoppingList> GetAllActiveShoppingLists();
        public List<ShoppingList> GetAllCompletedLists();
        public List<ShoppingList> GetAllDraftLists();
        public List<ShoppingList> GetActiveShoppingListsByDepartmentID(int departmentId, int status);
        public List<ShoppingList> GetActiveInvitedShoppingListsByUserID(int userId, int status);

    }
}
