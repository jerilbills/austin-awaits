using System.Collections.Generic;
using Capstone.Models;

namespace Capstone.DAO
{
    public interface IUserDao
    {
        List<User> GetActiveUsers();
        List<User> GetActiveUsersByDepartmentId(int departmentId);
        User GetActiveUserById(int id);
        User GetActiveUserByUsername(string username);
        User CreateUser(RegisterUser potentialUser);
        User UpdateName(User userToUpdate);
        User UpdateAvatar(User userToUpdate);
        List<User> GetActiveUsersByDepartmentId(int departmentId);
        int AddUserToList(UserList userList);
    }
}
