using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs
{
    public class TestResultDto
    {
        public DateTime TestTime { get; set; }
        public string Diagnosis { get; set; } // Normal, Protan, Deutan, etc.
        public int CorrectAnswerCount { get; set; }
        public int ProtanAnswerCount { get; set; }
        public int DeutanAnswerCount { get; set; }
    }
}
