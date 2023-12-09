using System;
using System.Collections.Generic;

namespace Capstone.Models
{
    public class ShoppingList
    {
        public int ListId { get; set; }
        public int OwnerId { get; set; }
        public string Name { get; set; }
        public int DepartmentId { get; set; }
        public string DepartmentName {  get; set; }
        public int NumberOfItems { get; set; }
        public DateTime DueDate { get; set; }
        public int Status { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModified { get; set; }
       
    }
}
