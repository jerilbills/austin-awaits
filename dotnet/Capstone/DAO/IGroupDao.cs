using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IGroupDao
    {
        public Group CreateGroup();
        public Group UpdateGroup(int id);
        public int DeleteGroup(int id);
        public Group AddUser(User userToAdd);
        public int DeleteUser(User userToDelete);
        public Group AddShoppingList(ShoppingList shoppingListToAdd);
        public int DeleteShoppingList(ShoppingList shoppingListToDelete);
        public Group ClaimShoppingList(ShoppingList shoppingListToClaim, User claimant);
        public Group GetGroupById(int id);
        public List<Group> GetGroups();
    }
}
