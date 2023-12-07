using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IDepartmentDao
    {
        public List<Department> GetDepartments();

    }
}