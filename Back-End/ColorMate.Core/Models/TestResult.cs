using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.Models
{
    public class TestResult
    {
        public int Id { get; set; }
        public DateTime TestTime { get; set; } = DateTime.Now;
        public string Diagnosis { get; set; } // Normal, Protan, Deutan, etc.

        public string ApplicationUserId { get; set; }
        public ApplicationUser ApplicationUser { get; set; }

        public ICollection<UserAnswer> Answers { get; set; } = new HashSet<UserAnswer>();

        //public int ColorBlindTypeId { get; set; }
        //public ColorBlindType ColorBlindType { get; set; }
    }
}
