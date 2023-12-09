using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Capstone.DAO;
using Capstone.Models;
using Capstone.Security;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("department/{departmentId}/list")]
    [Authorize]
    public class ShoppingListController : ControllerBase
    {
        private readonly IShoppingListDao shoppingListDao;

        public ShoppingListController(IShoppingListDao shoppingListDao)
        {
            this.shoppingListDao = shoppingListDao;
        }

        [HttpGet]
        public ActionResult<List<ShoppingList>> GetShoppingListsByDepartmentID(int departmentId)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetActiveShoppingListsByDepartmentID(departmentId);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

        [HttpPost("{listId}/user/{userId}")]
        public ActionResult<int> AddUserToList(UserList userListToAdd)
        {
            int output;
            try
            {
                output = shoppingListDao.AddUserToList(userListToAdd);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }

        [HttpGet("/user/{userId}/list")]
        public ActionResult<List<ShoppingList>> GetInvitedShoppingListsByUserID(int userId)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetActiveInvitedShoppingListsByUserID(userId);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }
            return output;
        }
    }
}
