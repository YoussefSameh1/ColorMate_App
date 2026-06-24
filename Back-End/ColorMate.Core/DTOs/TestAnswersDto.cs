using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs
{
    public class TestAnswersDto
    {
        public int ImageId { get; set; }
        public string Value { get; set; }
        public bool UsedForDiagnosis { get; set; } // have color blind or not for first 11 plate

    }
}
