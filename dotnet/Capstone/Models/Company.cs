using System.Collections.Generic;

namespace Capstone.Models
{
    public class Company
    {
        public List<Item> Catalog { get; set; }
        public List<Item> Inventory { get; set; }
    }
}
