using ColorMate.BL.ObjDetectionService;
using ColorMate.Core.DTOs.ObjDetectionDto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ColorMate.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ObjDetectionController : ControllerBase
    {
        private readonly IObjDetectionService _objDetectionService;

        public ObjDetectionController(IObjDetectionService objDetectionService)
        {
            _objDetectionService = objDetectionService;
        }

        [HttpPost("upload-image")]
        public async Task<IActionResult> SendImageAndGetObjects (ObjDetectionRequestDto requestDto)
        {
            if (requestDto == null || requestDto.uploadedImage.Length <= 0)
            {
                return BadRequest("ImageBase64 is required");
            }

            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userId == null)
            {
                return BadRequest("userId is null");
            }

            var result = await _objDetectionService.GetObjectsAsync(requestDto, userId);

            if (result == null)
            {
                return StatusCode(500, "Object detection service failed");
            }

            return Ok(result);
        }

        [HttpGet("user-detections-history")]
        public IActionResult GetUserDetections()
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized("User not authenticated");
                }

                var result = _objDetectionService.GetUserDetectionsHistory(userId);

                if (result == null || !result.Any())
                {
                    return NotFound("No detections found for this user");
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while retrieving detections: {ex.Message}");
            }
        }
    }
}
