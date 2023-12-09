using Capstone.DAO;
using Capstone.Exceptions;
using Capstone.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Security.Cryptography.Xml;
using System.Security.Principal;


namespace Capstone.Controllers
{
    [ApiController]
    [Route("department/{departmentId}/list/{listId}/listitem")]
    [Authorize]
    public class ListItemController : ControllerBase
    {
        private readonly IListItemDao listItemDao;
        private readonly IUserDao userDao;

        public ListItemController(IListItemDao listItemDao, IUserDao userDao)
        {
            this.listItemDao = listItemDao;
            this.userDao = userDao;
        }



        [HttpPut("{itemId}")]

        public ActionResult<ListItem> UpdateListItemStatusAndClaimant(int itemId, int listId, ListItem itemToUpdate)
        {
            try
            {
                ListItem updatingListItem = listItemDao.GetActiveListItemById(itemId, listId);
                
                if (updatingListItem == null)
                {
                    return NotFound();
                }

                User loggedInUser = userDao.GetActiveUserByUsername(User.Identity.Name);

                ListItem updatedListItem = listItemDao.UpdateListItemStatusAndClaimant(listId, itemId, loggedInUser.UserId, itemToUpdate);

                return updatedListItem;

            }
            catch (SystemException)
            {
                return StatusCode(500);
            }

        }


        [HttpGet]

        public ActionResult<List<ListItem>> GetListItemsByListId(int listId)
        {
            List<ListItem> output = new List<ListItem>();
            try
            {
                output = listItemDao.GetActiveListItemsByListId(listId);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }

        [HttpGet("{itemId}")]

        public ActionResult<ListItem> GetListItemById(int itemId, int listId)
        {
            ListItem output;
            try
            {
                output = listItemDao.GetActiveListItemById(itemId, listId);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }

        [HttpGet("claimed/{userId}")]
        public ActionResult<List<ListItem>> FilterListByClaimed(int listId, int userId)
        {
            List<ListItem> output = new List<ListItem>();
            try
            {
                output = listItemDao.FilterListByClaimant(listId, userId);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }

        [HttpGet("unassigned")]
        public ActionResult<List<ListItem>> FilterListByUnassigned(int listId)
        {
            List<ListItem> output = new List<ListItem>();
            try
            {
                output = listItemDao.FilterListByUnassigned(listId);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }
    }
}
