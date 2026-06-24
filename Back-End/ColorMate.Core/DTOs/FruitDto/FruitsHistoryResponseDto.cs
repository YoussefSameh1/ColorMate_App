using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs.FruitDto
{
    public class FruitsHistoryResponseDto
    {
        public string ImageBase64 { get; set; }
        public string PredictedClass { get; set; }
        public double Confidence { get; set; }
    }
}
