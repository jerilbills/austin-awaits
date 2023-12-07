namespace Capstone.Models
{
    public class Invite
    {
        public int Id { get; set; }
        public User UserFrom { get; set; }
        public User UserTo { get; set; }
    }
}
