using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Capstone.Models
{
    public class PotentialImage
    {
        [Required]
        public string ItemName { get; set; }
        public List<string> Images { get; set; } = new List<string>();
    }
}
