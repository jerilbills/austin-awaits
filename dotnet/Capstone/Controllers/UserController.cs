using Capstone.DAO;
using Capstone.Exceptions;
using Capstone.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [Route("user")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserDao userDao;
        private readonly IShoppingListDao shoppingListDao;

        public UserController(IUserDao userDao, IShoppingListDao shoppingListDao)
        {
            this.userDao = userDao;
            this.shoppingListDao = shoppingListDao;
        }

        [HttpGet]
        public ActionResult<List<User>> GetAllActiveUsers()
        {
            ActionResult result = NoContent();
            List<User> users = new List<User>();

            try
            {
                users = userDao.GetActiveUsers();
            }
            catch (DaoException)
            {
                return StatusCode(500);
            }

            if (users != null && users.Count > 0)
            {
                result = Ok(users);
            }

            return result;
        }

        [HttpGet("/department/{departmentId}/user")]
        public ActionResult<List<User>> GetActiveUsersByDepartmentId(int departmentId)
        {
            ActionResult result = NoContent();
            List<User> users = new List<User>();

            try
            {
                users = userDao.GetActiveUsersByDepartmentId(departmentId);
            }
            catch (DaoException)
            {
                return StatusCode(500);
            }

            if (users != null && users.Count > 0)
            {
                result = Ok(users);
            }

            return result;
        }

        [HttpGet("{userId}")]
        public ActionResult<User> GetActiveUserById(int userId)
        {
            ActionResult result = NoContent();
            User user = null;

            try
            {
                user = userDao.GetActiveUserById(userId);
            }
            catch (DaoException)
            {
                return StatusCode(500);
            }

            if (user != null)
            {
                result = Ok(user);
            }

            return result;
        }
    }
}