namespace ColorMate.Core.Models
{
    public class OutfitSuggestion
    {
        public int Id { get; set; }
        public int Rank { get; set; }
        public string Text { get; set; }
        public string Urgency { get; set; }
        public string Reason { get; set; }

        // Foreign Key
        public int OutfitRatingWithImageId { get; set; }
        public OutfitRatingWithImage OutfitRatingWithImage { get; set; }
    }
}