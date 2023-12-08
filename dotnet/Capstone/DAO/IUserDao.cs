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
    }
}
