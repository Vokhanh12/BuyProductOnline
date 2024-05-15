using Microsoft.AspNetCore.Mvc;
using System.Text.Encodings.Web;

namespace MvcMovie.Controllers;

public class HomeController : Controller
{

    // GET: /Home/Privacy
    public IActionResult Privacy()
    {
        return View();
    }


    // Get: /Home/Store
    public IActionResult Store(){
        return View();
    }

}