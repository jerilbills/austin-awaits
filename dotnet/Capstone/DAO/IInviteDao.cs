using Capstone.Models;
using System.Collections.Generic;

namespace Capstone.DAO
{
    public interface IInviteDao
    {
        public Invite Invite(User userToInvite);
        public Invite GetInviteById(int id);
        public List<Invite> GetInvites();
    }
}
