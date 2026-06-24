using ColorMate.Core.DTOs.OutfitRatingDto;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.BL.OutfitRatingService
{
    public interface IOutfitRatingService
    {
        Task<OutfitRatingResponseDto?> GetOutfitRatingAsync(OutfitRatingRequestDto requestDto, string userId);
        List<OutfitRatingHistoryResponseDto> GetUserOutfitRatingsHistory(string userId);
    }
}
