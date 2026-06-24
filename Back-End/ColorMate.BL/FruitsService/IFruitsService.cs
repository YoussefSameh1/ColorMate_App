using ColorMate.Core.DTOs.FruitDto;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.BL.FruitsService
{
    public interface IFruitsService
    {
        Task<FruitsResponseDto?> ClassifyFruitAsync(FruitsRequestDto requestDto, string userId);
        List<FruitsHistoryResponseDto> GetUserFruitsHistory(string userId);
    }
}
