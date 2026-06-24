using ColorMate.Core.DTOs.ObjDetectionDto;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.BL.ObjDetectionService
{
    public interface IObjDetectionService
    {
        Task<ObjDetectionResponseDto?> GetObjectsAsync(ObjDetectionRequestDto requestDto, string userId);
        List<DetectionHistoryResponseDto> GetUserDetectionsHistory(string userId);
    }
}
