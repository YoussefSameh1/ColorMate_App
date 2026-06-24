using System.Collections.Generic;

namespace ColorMate.Core.DTOs.OutfitRatingDto
{
    public class OutfitRatingHistoryResponseDto
    {
        public string ImageBase64 { get; set; }
        public int Score { get; set; }
        public List<string> Suggestions { get; set; } = new List<string>();
    }
}