using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Build.Tasks;
namespace MvcMovie.Models
{
    [Table("Items")]
    public class Item
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("item_catalog_id")]
        public int ItemCatalogId { get; set; }

        [Column("image_url")]
        public string ImageUrl { get; set; }

        [Column("name")]
        public string Name { get; set; }

        [Column("price")]
        public decimal Price { get; set; }

        [Column("ItemType")]
        public string Type { get; set; }

    }
}