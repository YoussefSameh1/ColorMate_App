using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace ColorMate.Core.DTOs.ObjDetectionDto
{
    public class DetectedObjectDto
    {
        [JsonPropertyName("object_id")]
        public int ObjectId { get; set; }

        [JsonPropertyName("class_name")]
        public string ClassName { get; set; }

        [JsonPropertyName("confidence")]
        public double Confidence { get; set; }

        [JsonPropertyName("bbox")]
        public List<int> Bbox { get; set; }
    }
}
