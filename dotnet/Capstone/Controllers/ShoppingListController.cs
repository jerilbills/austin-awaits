using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Capstone.DAO;
using Capstone.Models;
using Capstone.Security;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("[controller]")]
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
                output = shoppingListDao.GetShoppingListsByDepartmentID(departmentId);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

    }
}
