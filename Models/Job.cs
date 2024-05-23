using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Build.Tasks;
namespace MvcMovie.Models
{
    [Table("Jobs")]
    public class Job
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("total_hours_worked")]
        public int totalHoursWorked{get; set;}

        [Column("salary")]
        public float salary{get; set;}

        [Column("total_amount")]
        public float totalAmount {get; set; }

    }
}