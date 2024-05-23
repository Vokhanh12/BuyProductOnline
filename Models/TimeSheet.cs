using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc;
namespace MvcMovie.Models
{
    [Table("Timesheet")]
    public class Timesheet
    {
        [Column("id")]
        public int Id { get; set; }

        [DataType(DataType.Date)]
        public DateTime startTime { get; set; }

        [DataType(DataType.Date)]
        public DateTime endTime { get; set; }

        [Column("total_minutes")]
        public int totalMinutes {get; set; }

    }
}