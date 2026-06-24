using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace ColorMate.Core.DTOs.ProfileDto
{
    public class UploadProfilePictureDto
    {
        [Required]
        public IFormFile Picture { get; set; }
    }
}
