using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using MvcMovie.Data;
var builder = WebApplication.CreateBuilder(args);

if (builder.Environment.IsDevelopment())
{

    builder.Services.AddDbContext<MvcMovieContext>(options =>
        options.UseSqlServer(builder.Configuration.GetConnectionString("ProductionMvcMovieContext")));
}

// Add services to the container.
builder.Services.AddRazorPages();

builder.Services.AddDbContext<MvcMovieContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("MvcMovieContext")));

var app = builder.Build();



// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");


    

app.UseAuthorization();

app.MapRazorPages();

app.Run();
