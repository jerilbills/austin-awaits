using System.Collections.Generic;
using Capstone.Models;

namespace Capstone.DAO
{
    public interface IUserDao
    {
        IList<User> GetActiveUsers();
        User GetActiveUserById(int id);
        User GetActiveUserByUsername(string username);
        User CreateUser(RegisterUser potentialUser);
        User UpdateName(User userToUpdate);
        User UpdateAvatar(User userToUpdate);
    }
}
