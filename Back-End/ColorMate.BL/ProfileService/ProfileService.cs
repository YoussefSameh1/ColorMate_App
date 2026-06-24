using ColorMate.Core.DTOs.ProfileDto;
using ColorMate.Core.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;

namespace ColorMate.BL.ProfileService
{
    public class ProfileService : IProfileService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IWebHostEnvironment _env;

        public ProfileService(UserManager<ApplicationUser> userManager, IWebHostEnvironment env)
        {
            _userManager = userManager;
            _env = env;
        }

        public async Task<ProfileDto?> GetProfileAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null) return null;

            return new ProfileDto
            {
                Id = user.Id,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                ProfilePictureUrl = user.ProfilePictureUrl,
            };
        }

        public async Task<bool> UpdateProfileAsync(string userId, UpdateProfileDto dto)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null) return false;

            if (!string.IsNullOrWhiteSpace(dto.FirstName))
                user.FirstName = dto.FirstName;

            if (!string.IsNullOrWhiteSpace(dto.LastName))
                user.LastName = dto.LastName;

            //if (!string.IsNullOrWhiteSpace(dto.PhoneNumber))
            //    user.PhoneNumber = dto.PhoneNumber;

            var result = await _userManager.UpdateAsync(user);
            return result.Succeeded;
        }


        public async Task<string?> UploadProfilePictureAsync(string userId, IFormFile file)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null || file == null || file.Length == 0)
                return null;

            var webRoot = Path.Combine(_env.ContentRootPath, "wwwroot");
            var folder = Path.Combine(webRoot, "profile-images");

            Directory.CreateDirectory(folder);

            var extension = Path.GetExtension(file.FileName);
            var fileName = $"{Guid.NewGuid()}{extension}";
            var fullPath = Path.Combine(folder, fileName);

            var logPath = Path.Combine(_env.ContentRootPath, "upload-log.txt");

            File.AppendAllText(logPath,
                $"Time: {DateTime.Now}\n" +
                $"WebRoot: {webRoot}\n" +
                $"Folder: {folder}\n" +
                $"FullPath: {fullPath}\n" +
                "--------------------------\n"
            );

            await using (var stream = new FileStream(fullPath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            user.ProfilePictureUrl = $"/profile-images/{fileName}";
            await _userManager.UpdateAsync(user);

            return user.ProfilePictureUrl;
        }
        #region old uploadprofile    
        //public async Task<string?> UploadProfilePictureAsync(string userId, IFormFile file)
        //{
        //    var user = await _userManager.FindByIdAsync(userId);
        //    if (user == null) return null;

        //    var webRoot = _env.WebRootPath
        //        ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");

        //    var folder = Path.Combine(webRoot, "profile-images");
        //    Directory.CreateDirectory(folder);

        //    // Delete old image first
        //    DeleteImageFile(user.ProfilePictureUrl, webRoot);

        //    var extension = Path.GetExtension(file.FileName).ToLowerInvariant();
        //    var fileName = $"{userId}_{Guid.NewGuid()}{extension}";
        //    var fullPath = Path.Combine(folder, fileName);

        //    await using var stream = new FileStream(fullPath, FileMode.Create);
        //    await file.CopyToAsync(stream);

        //    user.ProfilePictureUrl = $"/profile-images/{fileName}";
        //    await _userManager.UpdateAsync(user);

        //    return user.ProfilePictureUrl;
        //} 
        #endregion

        public async Task<bool> DeleteProfilePictureAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null || string.IsNullOrEmpty(user.ProfilePictureUrl))
                return false;

            var webRoot = _env.WebRootPath
                ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");

            DeleteImageFile(user.ProfilePictureUrl, webRoot);

            user.ProfilePictureUrl = null;
            var result = await _userManager.UpdateAsync(user);
            return result.Succeeded;
        }

        // ── private helper ──────────────────────────────────────────
        private static void DeleteImageFile(string? relativeUrl, string webRoot)
        {
            if (string.IsNullOrEmpty(relativeUrl)) return;

            // Only delete local files, not social-login picture URLs (http/https)
            if (relativeUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase)) return;

            var fullPath = Path.Combine(webRoot, relativeUrl.TrimStart('/'));
            if (File.Exists(fullPath))
                File.Delete(fullPath);
        }
    }
}