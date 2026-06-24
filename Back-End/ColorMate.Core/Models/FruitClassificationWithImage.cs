using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace ColorMate.Core.Models
{
    public class FruitClassificationWithImage
    {
        public int Id { get; set; }

        public byte[] OriginalImage { get; set; }

        public string ApplicationUserId { get; set; }

        public ApplicationUser ApplicationUser { get; set; }

        public string PredictedClass { get; set; }

        public double Confidence { get; set; }
    }
}
