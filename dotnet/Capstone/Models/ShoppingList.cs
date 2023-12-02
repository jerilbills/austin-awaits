using System;

namespace Capstone.Models
{
    public class ShoppingList
    {
        public int Id { get; set; }
        public int OwnerId { get; set; }
        public string Name { get; set; }
        public int ClaimantId { get; set; }
        public DateTime DueDate { get; set; }
        public string Status { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModified { get; set; }
    }
}
