using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace ColorMate.Core.DTOs.ObjDetectionDto
{
    public class ObjDetectionResponseDto
    {
        [JsonPropertyName("success")]
        public bool Success { get; set; }

        [JsonPropertyName("objects")]
        public List<DetectedObjectDto> Objects { get; set; } = new();

        [JsonPropertyName("total_objects")]
        public int TotalObjects { get; set; }
    }
}
