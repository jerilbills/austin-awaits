using Capstone.Models;

namespace Capstone.Services
{
    public interface IImageService
    {
        public PotentialImage GetImageResults(string searchString);
    }
}
