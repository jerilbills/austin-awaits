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
    [Route("department/{department_id}/list/{list_id}/listitem")]
    [Authorize]
    public class ListItemController : ControllerBase
    {
        private readonly IListItemDao listItemDao;

        public ListItemController(IListItemDao listItemDao)
        {
            this.listItemDao = listItemDao;
        }



        [HttpPut("{itemID}")]

        public ActionResult<ListItem> UpdateListItem(int itemID, int list_id, ListItem itemToUpdate)
        {
            try
            {
                ListItem updatingListItem = listItemDao.GetListItemById(itemID, list_id);

                if (updatingListItem == null)
                {
                    return NotFound();
                }

                ListItem updatedListItem = listItemDao.UpdateListItem(list_id, itemID, itemToUpdate);

                return updatedListItem;

            }
            catch (SystemException)
            {
                return StatusCode(500);
            }

        }


        [HttpGet]

        public ActionResult<List<ListItem>> GetListItemsByListId(int list_id)
        {
            List<ListItem> output = new List<ListItem>();
            try
            {
                output = listItemDao.GetListItemsByListId(list_id);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }

        [HttpGet("{itemID}")]

        public ActionResult<ListItem> GetListItemById(int itemID, int list_id)
        {
            ListItem output;
            try
            {
                output = listItemDao.GetListItemById(itemID, list_id);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }


    }
}
