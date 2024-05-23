
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Build.Tasks;
namespace MvcMovie.Models
{
    [Table("Stores")]
    public class Store
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("user_id")]
        public Guid userId { get; set; }

        [Column("name")]
        public string Name { get; set; }


    }
}