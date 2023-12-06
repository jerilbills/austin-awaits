using System.Collections.Generic;
using Capstone.Models;

namespace Capstone.DAO
{
    public interface IUserDao
    {
        IList<User> GetActiveUsers();
        User GetActiveUserById(int id);
        User GetActiveUserByUsername(string username);
        User CreateUser(RegisterUser newUser);
        User UpdateName(User potentialUser);
        User UpdateAvatar(User userToUpdate);
    }
}
