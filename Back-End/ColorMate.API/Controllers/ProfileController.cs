using ColorMate.BL.ProfileService;
using ColorMate.Core.DTOs.ProfileDto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ColorMate.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ProfileController : ControllerBase
    {
        private readonly IProfileService _profileService;

        public ProfileController(IProfileService profileService)
        {
            _profileService = profileService;
        }

        // GET /api/Profile
        [HttpGet]
        [ProducesResponseType(typeof(ProfileDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetProfile()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return Unauthorized(new { message = "User not authenticated" });

            var profile = await _profileService.GetProfileAsync(userId);
            if (profile == null)
                return NotFound(new { message = "User not found" });

            return Ok(profile);
        }

        // PUT /api/Profile
        [HttpPut]
        [Consumes("application/json")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> UpdateProfile([FromBody] UpdateProfileDto dto)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return Unauthorized(new { message = "User not authenticated" });

            var result = await _profileService.UpdateProfileAsync(userId, dto);
            if (!result)
                return BadRequest(new { message = "Failed to update profile" });

            return Ok(new { message = "Profile updated successfully" });
        }

        // PUT /api/Profile/picture
        [HttpPut("picture")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UpdateProfilePicture([FromForm] UploadProfilePictureDto dto)
        {
            if (dto == null || dto.Picture == null || dto.Picture.Length == 0)
                return BadRequest(new { message = "Image is required" });

            var allowedTypes = new[] { "image/jpeg", "image/png", "image/webp" };
            if (!allowedTypes.Contains(dto.Picture.ContentType.ToLower()))
                return BadRequest(new { message = "Only JPEG, PNG, WebP allowed" });

            if (dto.Picture.Length > 5 * 1024 * 1024)
                return BadRequest(new { message = "Max size is 5MB" });

            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return Unauthorized(new { message = "User not authenticated" });

            var imageUrl = await _profileService.UploadProfilePictureAsync(userId, dto.Picture);
            if (string.IsNullOrEmpty(imageUrl))
                return BadRequest(new { message = "Upload failed" });

            return Ok(new { profilePictureUrl = imageUrl });
        }

        // DELETE /api/Profile/picture
        [HttpDelete("picture")]
        public async Task<IActionResult> DeleteProfilePicture()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return Unauthorized(new { message = "User not authenticated" });

            var result = await _profileService.DeleteProfilePictureAsync(userId);
            if (!result)
                return BadRequest(new { message = "No profile picture to remove" });

            return Ok(new { message = "Profile picture removed successfully" });
        }
    }
}