using Capstone.Models;
using System;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Threading.Tasks;
using System.Linq;
using System.Collections.Generic;
using Newtonsoft.Json;
using static System.Net.Mime.MediaTypeNames;

namespace Capstone.Services
{
    public class BingImageService: IImageService
    {
        private static string SUBSCRIPTION_KEY;
        private static string SEARCH_URL = "https://api.bing.microsoft.com/v7.0/images/search";

        // Each of the query parameters you may specify.

        private const string QUERY_PARAMETER = "?q=austin+shopping+";  // Required
        private const string MKT_PARAMETER = "&mkt=en-us";  // Strongly suggested
        private const string COUNT_PARAMETER = "&count=100";
        private const string SAFE_SEARCH_PARAMETER = "&safeSearch=Strict";
        //private const string IMAGE_TYPE_PARAMETER = "&imageType=Photo";
        private const string MIN_HEIGHT_PARAMETER = "&minHeight=250";
        private const string MIN_WIDTH_PARAMETER = "&minWidth=250";

        // Bing uses the X-MSEdge-ClientID header to provide users with consistent
        // behavior across Bing API calls. See the reference documentation
        // for usage.
        private static string _clientIdHeader = null;

        public static List<string> ReturnImages { get; set; } = new List<string>();
        
        public BingImageService(string subscriptionKey, string searchUrl)
        {
            SUBSCRIPTION_KEY = subscriptionKey;
            SEARCH_URL = searchUrl;
        }

        public PotentialImage GetImageResults(string searchString)
        {
            ReturnImages = new List<string>();

            RunImageFetchAsync(searchString).Wait();

            PotentialImage output = new PotentialImage();
            output.Images = ReturnImages;

            return output;
        }

        static async Task RunImageFetchAsync(string searchString)
        {
            var queryString = QUERY_PARAMETER + Uri.EscapeDataString(searchString);
            queryString += MKT_PARAMETER + COUNT_PARAMETER + SAFE_SEARCH_PARAMETER + MIN_HEIGHT_PARAMETER + MIN_WIDTH_PARAMETER;

            HttpResponseMessage response = await MakeRequestAsync(queryString);

            _clientIdHeader = response.Headers.GetValues("X-MSEdge-ClientID").FirstOrDefault();

            var contentString = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode)
            {
                Dictionary<string, object> searchResponse = JsonConvert.DeserializeObject<Dictionary<string, object>>(contentString);
                GetImages(searchResponse);
            }
            else
            {
                throw new Exception("Something went wrong retrieving the response from the Bing endpoint");
            }
        }

        // Makes the request to the Image Search endpoint.
        static async Task<HttpResponseMessage> MakeRequestAsync(string queryString)
        {
            var client = new HttpClient();

            client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", SUBSCRIPTION_KEY);

            return (await client.GetAsync(SEARCH_URL + queryString));
        }

        // Adds the images to the list of Urls to return
        static void GetImages(Dictionary<string, object> response)
        {
            if (response.ContainsKey("images"))
            {
                Dictionary<string, object> imageSubSet = JsonConvert.DeserializeObject<Dictionary<string, object>>(response["images"].ToString());

                var images = imageSubSet["value"] as Newtonsoft.Json.Linq.JToken;

                foreach (Newtonsoft.Json.Linq.JToken image in images)
                {
                    string url = image["contentUrl"].ToString();
                    ReturnImages.Add(url);
                }
            }
            else
            {
                throw new Exception("Response from Bing endpoint did not contain the data format expected.");
            }
        }
    }
}
