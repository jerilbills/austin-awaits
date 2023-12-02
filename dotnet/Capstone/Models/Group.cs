using System.Collections.Generic;
using System.Data.Common;

namespace Capstone.Models
{
    public class Group
    {
        public int Id { get; set; }
        public int OwnerId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Avatar { get; set; }
        public List<User> Users { get; set; }
    }
}
