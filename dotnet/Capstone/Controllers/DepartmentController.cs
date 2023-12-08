using Capstone.DAO;
using Capstone.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("department")]
    public class DepartmentController : ControllerBase
    {
        private readonly IDepartmentDao departmentDao;
        private readonly IUserDao userDao;

        public DepartmentController(IDepartmentDao departmentDao, IUserDao userDao)
        {
            this.departmentDao = departmentDao;
            this.userDao = userDao;
        }

        [HttpGet]

        public ActionResult<List<Department>> GetItemsByListId(int list_id)
        {
            List<Department> output = new List<Department>();
            try
            {
                output = departmentDao.GetDepartments();
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }
            return output;
        }

        [HttpGet("{id}/user")]

        public ActionResult<List<User>> GetUsersByDepartmentId(int id)
        {
            List<User> output = new List<User>();
            try
            {
                output = userDao.GetActiveUsersByDepartmentId(id);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

    }
}
