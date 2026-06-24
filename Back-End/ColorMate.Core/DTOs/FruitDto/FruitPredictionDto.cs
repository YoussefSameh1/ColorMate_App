using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs.FruitDto
{
    public class FruitPredictionDto
    {
        public string Predicted_Class { get; set; }
        public double Confidence { get; set; }
        public Dictionary<string, double> Probabilities { get; set; }
    }
}
