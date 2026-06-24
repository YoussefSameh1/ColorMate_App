using ColorMate.BL.OutfitRatingService;
using ColorMate.Core.DTOs.OutfitRatingDto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace ColorMate.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class OutfitRatingController : ControllerBase
    {
        private readonly IOutfitRatingService _outfitRatingService;

        public OutfitRatingController(IOutfitRatingService outfitRatingService)
        {
            _outfitRatingService = outfitRatingService;
        }

        [HttpPost("upload-image")]
        public async Task<IActionResult> SendImageAndGetObjects([FromForm] OutfitRatingRequestDto requestDto)
        {
            if (requestDto == null || requestDto.uploadedImage == null || requestDto.uploadedImage.Length <= 0)
            {
                return BadRequest("Image file is required.");
            }

            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("User ID is missing or invalid.");
            }

            var result = await _outfitRatingService.GetOutfitRatingAsync(requestDto, userId);

            if (result == null || result.Score == -1)
            {
                return StatusCode(500, "Outfit rating service failed to analyze the image.");
            }

            return Ok(result);
        }

        [HttpGet("user-outfit-ratings-history")]
        public IActionResult GetUserOutfitRatingsHistory()
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized("User not authenticated.");
                }

                var result = _outfitRatingService.GetUserOutfitRatingsHistory(userId);

                if (result == null || !result.Any())
                {
                    return NotFound("No outfit ratings found for this user.");
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while retrieving outfit ratings: {ex.Message}");
            }
        }
    }
}