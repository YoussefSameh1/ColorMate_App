using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs.FruitDto
{
    public class FruitsResponseDto
    {
        public bool Success { get; set; }
        public FruitPredictionDto Prediction { get; set; }
    }
}
