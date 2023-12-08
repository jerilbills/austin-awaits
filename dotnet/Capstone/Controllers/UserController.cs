using Capstone.DAO;
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

        [HttpGet("{user_id}/list")]

        public ActionResult<List<ShoppingList>> GetShoppingListsByUserID(int userId)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetShoppingListsByUserID(userId);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }
            return output;
        }

    }
}
