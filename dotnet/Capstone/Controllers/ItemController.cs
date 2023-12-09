using Capstone.DAO;
using Capstone.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("item")]
    [Authorize]
    public class ItemController : ControllerBase
    {
        private readonly IItemDao itemDao;

        public ItemController(IItemDao itemDao)
        {
            this.itemDao = itemDao;
        }

        [HttpGet]

        public ActionResult<List<Item>> GetAllActiveItems()
        {
            List<Item> output = new List<Item>();
            try
            {
                output = itemDao.GetAllActiveItems();
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }

        [HttpPost]

        public ActionResult<Item> CreateItem(Item itemToAdd)
        {
            Item output;
            try
            {
                output = itemDao.CreateItem(itemToAdd);
                return Created($"/item/{itemToAdd.ItemId}", itemToAdd);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

        [HttpGet("{itemId}")]

        public ActionResult<Item> GetItemByItemId(int itemId)
        {
            Item output;
            try
            {
                output = itemDao.GetItemByItemId(itemId);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }

            return output;
        }

        [HttpPut("{itemId}")]

        public ActionResult<Item> UpdateItem(int itemId, Item itemToUpdate)
        {
            Item output;
            if (itemId != itemToUpdate.ItemId || itemToUpdate.ItemId <= 0)
            {
                return BadRequest();
            }
            try
            {
                output = itemDao.UpdateItem(itemToUpdate);
                return Ok(output);
            }
            catch (System.Exception)
            {
                return StatusCode(500);
            }
        }
    }
}
