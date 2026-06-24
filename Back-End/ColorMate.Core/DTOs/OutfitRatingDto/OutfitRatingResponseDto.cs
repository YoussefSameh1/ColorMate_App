using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace ColorMate.Core.DTOs.OutfitRatingDto
{
    public class OutfitRatingResponseDto
    {
        [JsonPropertyName("score")]
        public double Score { get; set; }

        [JsonPropertyName("suggestions")]
        public List<string> Suggestions { get; set; } = new List<string>();
    }
}