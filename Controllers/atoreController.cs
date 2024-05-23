using Microsoft.AspNetCore.Mvc;

namespace MvcMovie.Controllers
{
    [Route("Home/Store")]
    public class StoreController : Controller
    {
        // 
         // GET: /Home/Store/
        [HttpGet("")]
        public IActionResult Index()
        {
            return View("~/Views/Home/Store/Index.cshtml");
        }


        // 
        // GET: /Home/Store/Welcome
        [HttpGet("Welcome")]
        public string Welcome()
        {
            return "This is the Welcome action method...";
        }

        // 
        // GET: /Home/Store/Privacy
        [HttpGet("Privacy")]
        public IActionResult Privacy()
        {
            return View();
        }
    }
}
