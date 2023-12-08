using Capstone.DAO;
using Capstone.Exceptions;
using Capstone.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
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

        public ListItemController(IListItemDao listItemDao)
        {
            this.listItemDao = listItemDao;
        }



        [HttpPut("{itemId}")]

        public ActionResult<ListItem> UpdateListItem(int itemId, int listId, ListItem itemToUpdate)
        {
            try
            {
                ListItem updatingListItem = listItemDao.GetListItemById(itemId, listId);

                if (updatingListItem == null)
                {
                    return NotFound();
                }

                ListItem updatedListItem = listItemDao.UpdateListItem(listId, itemId, itemToUpdate);

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
                output = listItemDao.GetListItemsByListId(listId);
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
                output = listItemDao.GetListItemById(itemId, listId);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }
    }
}
