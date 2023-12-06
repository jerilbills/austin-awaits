using Capstone.DAO;
using Capstone.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("department")]
    [Authorize]
    public class DepartmentController : ControllerBase
    {
        private readonly IDepartmentDao departmentDao;

        public DepartmentController(IDepartmentDao departmentDao)
        {
            this.departmentDao = departmentDao;
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
    }
}
