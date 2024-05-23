using Microsoft.AspNetCore.Mvc;
using System.Text.Encodings.Web;

namespace MvcMovie.Controllers;

public class LoginController : Controller
{
    // 
    // GET: /Login/
    public IActionResult Index()
    {
        return View();
    }
    // 
    // GET: /Login/Welcome/ 
    public string Welcome()
    {
        return "This is the Welcome action method...";
    }


    // GET: /HelloWorld/Home
    public IActionResult Privacy()
    {
        return View();
    }

}