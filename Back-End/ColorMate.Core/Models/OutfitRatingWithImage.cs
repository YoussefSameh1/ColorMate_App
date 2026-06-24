using System.Collections.Generic;

namespace ColorMate.Core.Models
{
    public class OutfitRatingWithImage
    {
        public int Id { get; set; }
        public byte[]? OriginalImage { get; set; }
        public int Score { get; set; }

        public string ApplicationUserId { get; set; }
        public ApplicationUser ApplicationUser { get; set; }

        // Navigation Property
        public ICollection<OutfitSuggestion> Suggestions { get; set; } = new List<OutfitSuggestion>();
    }
}