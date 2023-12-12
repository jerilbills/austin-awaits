using Capstone.DAO;
using Capstone.Models;
using Capstone.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace Capstone.Controllers
{
    [ApiController]
    [Route("potentialimage")]
    [Authorize]
    public class PotentialImageController : ControllerBase
    {
        private IImageService imageService;
        public PotentialImageController(IImageService imageService)
        {
            this.imageService = imageService;
        }

        [HttpPost]
        public ActionResult<PotentialImage> GetPotentialImages(PotentialImage imageRequest)
        {
            // Use comments to tobble between using Bing for results and our static data for results (to save on API calls)
            return ReturnBingImages(imageRequest);

            // return ReturnStaticImages(imageRequest);
        }

        private ActionResult<PotentialImage> ReturnBingImages(PotentialImage imageRequest)
        {
            ActionResult output = NoContent();
            PotentialImage images = new PotentialImage();
            string searchString = imageRequest.ItemName;
            if (!string.IsNullOrEmpty(searchString))
            {
                searchString = searchString.ToLower();

                try
                {
                    images = imageService.GetImageResults(searchString);
                    images.ItemName = imageRequest.ItemName;
                    output = Ok(images);
                }
                catch (Exception)
                {
                    output = StatusCode(500);
                }
            }

            return output;
        }

        private ActionResult<PotentialImage> ReturnStaticImages(PotentialImage imageRequest) { 

                PotentialImage output = new PotentialImage();

            if (imageRequest != null && !String.IsNullOrEmpty(imageRequest.ItemName))
            {
                output = imageRequest;

                output.Images.Add("https://i.etsystatic.com/7471492/r/il/9bdf50/1642831225/il_570xN.1642831225_f8n6.jpg");
                output.Images.Add("https://i.pinimg.com/originals/6d/36/02/6d3602ebb6c05276ab3e66af9df68bdd.jpg");
                output.Images.Add("https://merchanshirt.com/wp-content/uploads/2020/12/keep-austin-weird-tee-shirts-2.jpg");
                output.Images.Add("https://i.pinimg.com/originals/13/47/cf/1347cf6c28afe3e646c5d359a8d5692c.jpg");
                output.Images.Add("https://cdn-wholeearth.celerantwebservices.com/prodimages/24034-DEFAULT-l.jpg");
                output.Images.Add("https://i.pinimg.com/originals/7c/b6/06/7cb606b10afefc7ec2f5e3a3dd74edd9.jpg");
                output.Images.Add("https://store.bullockmuseum.org/mas_assets/cache/image/1/a/6/9/6761.Jpg");
                output.Images.Add("https://cdn.shopify.com/s/files/1/0914/0120/products/tshirt-keep-austin-weird_1024x1024@2x.jpg?v=1582852589");
                output.Images.Add("http://1.bp.blogspot.com/_pzKVH4KGXTc/RugbXVs1uRI/AAAAAAAAABs/b49hvi2Vk4o/s1600/Keep+Austin+Weird+T-shirt,+");
                output.Images.Add("https://m.media-amazon.com/images/I/A13usaonutL._CLa%7C2140%2C2000%7C81CcXSMMSkL.png%7C0%2C0%2C2140%2C2000%2B0.0%2C0.0%2C2140.0%2C2000.0_AC_UL1500_.png");
                output.Images.Add("https://m.media-amazon.com/images/I/71kH-wEQ1PL._AC_UL960_QL65_.jpg");
                output.Images.Add("https://ih1.redbubble.net/image.754590871.6617/ssrco,classic_tee,womens,fafafa:ca443f4786,front,square_product,x600-bg,f8f8f8.1u2.jpg");
            }

            return output;
        }
    }
}
