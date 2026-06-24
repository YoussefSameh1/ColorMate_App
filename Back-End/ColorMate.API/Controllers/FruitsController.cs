using ColorMate.BL.FruitsService;
using ColorMate.Core.DTOs.FruitDto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ColorMate.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class FruitsController : ControllerBase
    {
        private readonly IFruitsService _fruitsService;

        public FruitsController(IFruitsService fruitsService)
        {
            _fruitsService = fruitsService;
        }

        [HttpPost("upload-image")]
        public async Task<IActionResult> ClassifyFruit(FruitsRequestDto requestDto)
        {
            if (requestDto == null || requestDto.UploadedImage == null || requestDto.UploadedImage.Length <= 0)
            {
                return BadRequest("Image is required");
            }

            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userId == null)
            {
                return BadRequest("userId is null");
            }

            var result = await _fruitsService.ClassifyFruitAsync(requestDto, userId);

            if (result == null)
            {
                return StatusCode(500, "fruit classification service failed");
            }

            return Ok(result);
        }

        [HttpGet("user-fruits-history")]
        public IActionResult GetUserFruitsHistory()
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized("User not authenticated");
                }

                var result = _fruitsService.GetUserFruitsHistory(userId);

                if (result == null || !result.Any())
                {
                    return NotFound("No fruit classifications found for this user");
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while retrieving fruit classifications: {ex.Message}");
            }
        }
    }
}
