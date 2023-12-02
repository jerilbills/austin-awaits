using Capstone.Models;

namespace Capstone.DAO
{
    public interface IInviteDao
    {
        public Invite Invite(User userToInvite);
    }
}
