using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Capstone.DAO;
using Capstone.Models;
using Capstone.Security;
using System.Collections.Generic;
using System.Net.NetworkInformation;
using System;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("department/{departmentId}/list/{listId}/invite")]
    [Authorize]
    public class InviteController : ControllerBase
    {
        private readonly IInviteDao invitetDao;

        public InviteController(IInviteDao invitetDao)
        {
            this.invitetDao = invitetDao;
        }

        
        [HttpPost]
        public ActionResult<int> AddUserToList(Invite userListToAdd)
        {
            int output;
            try
            {
                output = invitetDao.AddUserToList(userListToAdd);
            }
            catch (System.Exception)
            {

                return StatusCode(500);
            }

            return output;
        }
    }
}
