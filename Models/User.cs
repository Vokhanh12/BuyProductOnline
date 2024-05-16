using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc;
namespace MvcMovie.Models
{
    [Table("Users")]
    public class User
    {
        [Key]
        [StringLength(5)]
        public string Id { get; set; }

        [Required]
        [StringLength(25)]
        public string Name { get; set; }


        [Column("UserType")] // Đặt tên cột tương ứng trong cơ sở dữ liệu
        public string Type { get; set; }
    }
}