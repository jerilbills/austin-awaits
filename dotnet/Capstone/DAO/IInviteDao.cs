using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IInviteDao
    {
        public int AddUserToList(Invite userList);
        public List<Invite> GetListOfInvitedActiveUsers(int listId);

    }
}
