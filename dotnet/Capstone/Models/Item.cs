using System;

namespace Capstone.Models
{
    public class Item
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Status { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public User CreatedBy { get; set; }
        public User LastModifiedBy { get; set; }
        public bool IsUsed { get; set; }
    }
}
