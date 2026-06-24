using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.Models
{
    public class ObjFromDetection
    {
        public int Id { get; set; }

        public string ClassName { get; set; }

        public double Confidence { get; set; }

        public List<int> Bbox { get; set; }

        public int ObjDetectionWithImageId { get; set; }
        public ObjDetectionWithImage ObjDetectionWithImage { get; set; }
    }
}
