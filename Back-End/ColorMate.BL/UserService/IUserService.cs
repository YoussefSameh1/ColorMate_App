using ColorMate.Core.DTOs;
using ColorMate.Core.DTOs.Forgot_ResetPasswordDto;
using ColorMate.Core.Models;
using JWT.DTOs;
using Microsoft.AspNetCore.Identity;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ColorMate.BL.UserService
{
    public interface IUserService
    {

        Task<(IdentityResult Result, ApplicationUser User, string? Otp)> RegisterUserAsync(RegisterDto registerDto);


        //---------------------- Mina ----------------------

        //Task<AuthDto> RegisterAsync(RegisterDto registerDto);

        Task<AuthDto> GetTokenAsync(LoginDto loginDto);

        Task<JwtSecurityToken> CreateJwtToken(ApplicationUser user);

        Task<AuthDto> RefreshTokenAsync(string token);

        Task<bool> RevokeTokenAsync(string token);

        RefreshToken GenerateRefreshToken();

        Task<AuthDto> GenerateAuthResultAsync(ApplicationUser user);

        Task<AuthDto> ChangePasswordAsync(string userId, ChangePasswordDto dto);

        Task<bool> DeleteAccountAsync(string userId);


        // --- Forgot & Reset Password Workflow ---
        Task<(bool Succeeded, string Message, string? Otp)> ForgotPasswordAsync(string email);
        Task<(bool Succeeded, string Message, string? ResetToken)> VerifyPasswordOtpAsync(string email, string code);
        Task<(IdentityResult Result, string Message)> ResetPasswordAsync(ResetPasswordDto dto);
        Task<(bool Succeeded, string Message, string? Otp)> ResendPasswordOtpAsync(string email);


        //---------------------------------------------------


        Task<ApplicationUser> LoginWithGoogleAsync(GoogleUserDto googleUser);

        Task<ApplicationUser> LoginWithFacebookAsync(string accessToken);

    }
}
