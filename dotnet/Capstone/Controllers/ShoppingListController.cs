using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Capstone.DAO;
using Capstone.Models;
using Capstone.Security;
using System.Collections.Generic;
using System.Net.NetworkInformation;
using System;
using System.Globalization;
using Capstone.Exceptions;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("department/{departmentId}/list")]
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
        public ActionResult<List<ShoppingList>> GetShoppingListsByDepartmentID(int departmentId, int status = 0)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetActiveShoppingListsByDepartmentID(departmentId, status);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

        [HttpPut("{listId}/")]
        public ActionResult UpdateList(int departmentId, int listId, ShoppingList inboundShoppingList)
        {
            ActionResult output = NotFound();

            User loggedInUser = userDao.GetActiveUserByUsername(User.Identity.Name);

            if (loggedInUser != null && inboundShoppingList != null && inboundShoppingList.ListId == listId && inboundShoppingList.DepartmentId == departmentId)
            {
                // Users are only able to update the status by having moved all items to purchased
                if (loggedInUser.Role == "user")
                {
                    try
                    {
                        ShoppingList listToChange = shoppingListDao.GetActiveShoppingListById(listId);

                        if (listToChange != null)
                        {
                            listToChange.Status = inboundShoppingList.Status;
                            listToChange.LastModified = DateTime.UtcNow;
                            ShoppingList changedList = shoppingListDao.UpdateShoppingList(listToChange);
                            if (changedList != null) { output = NoContent(); }
                        }
                    }
                    catch (Exception)
                    {
                        return StatusCode(500);
                    }
                }

                // Admins can update the entire object
                else if (loggedInUser.Role == "admin")
                {
                    try
                    {
                        inboundShoppingList.LastModified = DateTime.UtcNow;
                        ShoppingList changedList = shoppingListDao.UpdateShoppingList(inboundShoppingList);
                        if (changedList != null) { output = NoContent(); }
                    }
                    catch (Exception)
                    {
                        return StatusCode(500);
                    }
                }
            }
            else
            {
                return BadRequest();
            }

            return output;
        }

        [HttpGet("/user/{userId}/list")]
        public ActionResult<List<ShoppingList>> GetInvitedShoppingListsByUserID(int userId, int status = 0)
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetActiveInvitedShoppingListsByUserID(userId, status);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }
            return output;
        }

        [HttpGet("/list/active")]

        public ActionResult<List<ShoppingList>> GetAllActiveShoppingLists()
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetAllActiveShoppingLists();
            }
            catch (Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

        [HttpGet("/list/completed")]

        public ActionResult<List<ShoppingList>> GetAllCompletedShoppingLists()
        {
            List<ShoppingList> output = new List<ShoppingList>();
            try
            {
                output = shoppingListDao.GetAllCompletedLists();
            }
            catch (Exception)
            {
                return StatusCode(500);
            }

            return output;
        }
    }
}
