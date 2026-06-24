using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.Models
{
    public class TestQuestion
    {
        public int Id { get; set; }
        public int ImageId { get; set; }
        public string? NormalAnswer { get; set; }

        //  ------------- for last three questions -----------
        public string? ProtanAnswer { get; set; }
        public string? DeutanAnswer { get; set; }

        // -------------------------------------------------
        public bool UsedForDiagnosis { get; set; } // have color blind or not for first 11 plate
        public ICollection<UserAnswer> Answers { get; set; } = new HashSet<UserAnswer>();

    }
}
