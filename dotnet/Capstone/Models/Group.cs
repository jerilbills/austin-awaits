using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Diagnostics.Eventing.Reader;

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
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public List<ShoppingList> ShoppingLists { get; set; }

        public Group(string name)
        {
            Name = name;
        }

    }
}
