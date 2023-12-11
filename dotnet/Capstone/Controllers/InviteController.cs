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

        [HttpGet]
        public ActionResult<List<Invite>> GetListOfInvitedUsers(int listId)
        {
            List<Invite> invites = new List<Invite>();
            ActionResult result = NoContent();

            try
            {
                invites = invitetDao.GetListOfInvitedActiveUsers(listId);
                if (invites.Count > 0)
                {
                    result = Ok(invites);
                }
            }
            catch (Exception)
            {
                result = StatusCode(500);
            }
            return result;
        }
        
        [HttpPost]
        public ActionResult<int> AddUserToList(Invite inviteToMake)
        {
            int result;
            try
            {
                result = invitetDao.AddUserToList(inviteToMake);
            }
            catch (Exception)
            {

                return StatusCode(500);
            }

            return result;
        }
    }
}
