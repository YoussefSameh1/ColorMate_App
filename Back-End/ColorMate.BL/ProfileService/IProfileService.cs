using ColorMate.Core.DTOs.ProfileDto;
using Microsoft.AspNetCore.Http;

namespace ColorMate.BL.ProfileService
{
    public interface IProfileService
    {
        Task<ProfileDto?> GetProfileAsync(string userId);
        Task<bool> UpdateProfileAsync(string userId, UpdateProfileDto dto);
        Task<string?> UploadProfilePictureAsync(string userId, IFormFile file);
        Task<bool> DeleteProfilePictureAsync(string userId); 
    }
}