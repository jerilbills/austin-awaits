using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Capstone.DAO;
using Capstone.Models;
using Capstone.Security;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("department/{id}/list")]
    [Authorize]
    public class ShoppingListController : ControllerBase
    {
        private readonly IShoppingListDao shoppingListDao;
        private readonly IUserDao userDao;

        public ShoppingListController(IShoppingListDao shoppingListDao, IUserDao userDao)
        {
            this.shoppingListDao = shoppingListDao;
            this.userDao = userDao;
        }



        [HttpGet]

        public ActionResult<List<ShoppingList>> GetShoppingListsByDepartmentID(int id)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetShoppingListsByDepartmentID(id);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

        [HttpPost("{list_id}/user/{user_id}")]
        public ActionResult<int> AddUserToList(UserList userListToAdd)
        {
            int output;
            try
            {
                output = userDao.AddUserToList(userListToAdd);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }
    }
}
