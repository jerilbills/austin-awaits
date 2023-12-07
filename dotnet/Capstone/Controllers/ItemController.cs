using Capstone.DAO;
using Capstone.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

//namespace Capstone.Controllers
//{
    //[ApiController]
    //[Route("department/{department_id}/list/{list_id}/listitem")]
    //[Authorize]
    //public class ItemController : ControllerBase
    //{
    //    private readonly IItemDao itemDao;

    //    public ItemController(IItemDao itemDao)
    //    {
    //        this.itemDao = itemDao;
    //    }

    //    [HttpGet]

    //    public ActionResult<List<Item>> GetItemsByListId(int list_id)
    //    {
    //        List<Item> output = new List<Item>();
    //        try
    //        {
    //            output = itemDao.GetItemsByListId(list_id);
    //        }
    //        catch (System.Exception)
    //        {

    //            return StatusCode(500);
    //        }

    //        return output;
    //    }
//    }
//}
