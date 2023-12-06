using System;

namespace Capstone.Models
{
    public class ListItem 
    {
       
        public int ListID { get; set; }
        public int ItemID { get; set; }

        public int ListItemStatusId { get; set; } = 0;
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public int LastModifiedBy { get; set; }

        public int Quantity { get; set; }
        public int ClaimedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }

    }
}
