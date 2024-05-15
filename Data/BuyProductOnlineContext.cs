using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MvcMovie.Models;

namespace BuyProductOnline.Data
{
    public class BuyProductOnlineContext : DbContext
    {
        public BuyProductOnlineContext (DbContextOptions<BuyProductOnlineContext> options)
            : base(options)
        {
        }

        public DbSet<MvcMovie.Models.User> User { get; set; }
    }
}
