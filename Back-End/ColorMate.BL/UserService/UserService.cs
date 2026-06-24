using ColorMate.BL.FacebookService;
using ColorMate.BL.Settings;
using ColorMate.Core.DTOs;
using ColorMate.Core.DTOs.Forgot_ResetPasswordDto;
using ColorMate.Core.Models;
using ColorMate.EF.Repositories.User;
using ColorMate.EF.UnitOfWork;
using JWT.DTOs;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Client;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace ColorMate.BL.UserService
{
    public class UserService : IUserService
    {
        private readonly IUnitOfWork _unitOfWork;

        private readonly UserManager<ApplicationUser> _userManager; // add user
        private readonly SignInManager<ApplicationUser> _signInManager; // sign in
        private readonly IConfiguration config;
        private readonly Settings.JWT _jwt;
        private readonly IFacebookAuthService _facebookAuthService;
        private readonly IEmailSender _emailSender;



        public UserService(IUnitOfWork unitOfWork,
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            IOptions<Settings.JWT> jwt,
            IConfiguration config, IFacebookAuthService facebookAuthService, IEmailSender emailSender)
        {
            _unitOfWork = unitOfWork;
            _userManager = userManager;
            _signInManager = signInManager;
            _jwt = jwt.Value;
            this.config = config;
            _facebookAuthService = facebookAuthService;
            _emailSender = emailSender;
        }



        public async Task<(IdentityResult Result, ApplicationUser User, string? Otp)> RegisterUserAsync(RegisterDto registerDto)
        {
            var user = new ApplicationUser
            {
                FirstName = registerDto.FirstName,
                LastName = registerDto.LastName,
                UserName = registerDto.UserName,
                Email = registerDto.Email,
                LoginProvider= "Local",
                EmailConfirmed = false
            };

            var result = await _userManager.CreateAsync(user, registerDto.Password);

            if (result.Succeeded)
            {
                var otp = new Random().Next(100000, 999999).ToString();
                user.EmailVerificationCode = otp;
                user.EmailCodeExpiration = DateTime.UtcNow.AddMinutes(5);
                await _userManager.UpdateAsync(user);

                return (result, user, otp);
            }

            return (result, user, null);
        }


        //------------------------ Mina ----------------------------

        /*

        //public async Task<AuthDto> RegisterAsync(RegisterDto registerDto)
        //{
        //    if (await _userManager.FindByEmailAsync(registerDto.Email) is not null)
        //        return new AuthDto { Message = "Email is already registered!" };

        //    if (await _userManager.FindByNameAsync(registerDto.UserName) is not null)
        //        return new AuthDto { Message = "Username is already registered!" };

        //    var user = new ApplicationUser
        //    {
        //        UserName = registerDto.UserName,
        //        Email = registerDto.Email,
        //        FirstName = registerDto.FirstName,
        //        LastName = registerDto.LastName,
        //        LoginProvider = "Local"
        //    };

        //    var result = await _userManager.CreateAsync(user, registerDto.Password);

        //    if (!result.Succeeded)
        //    {
        //        var errors = string.Join(",", result.Errors.Select(e => e.Description));
        //        return new AuthDto { Message = errors };
        //    }

        //    // IMPORTANT: Reload user so EF tracks the entity properly
        //    user = await _userManager.FindByIdAsync(user.Id);

        //    var jwtSecurityToken = await CreateJwtToken(user);

        //    var refreshToken = GenerateRefreshToken();
        //    user.RefreshTokens.Add(refreshToken);
        //    await _userManager.UpdateAsync(user);

        //    return new AuthDto
        //    {
        //        Email = user.Email,
        //        ExpiresOn = jwtSecurityToken.ValidTo,
        //        IsAuthenticated = true,
        //        Token = new JwtSecurityTokenHandler().WriteToken(jwtSecurityToken),
        //        Username = user.UserName,
        //        RefreshToken = refreshToken.Token,
        //        RefreshTokenExpiration = refreshToken.ExpiresOn
        //    };
        //}
        */

        public async Task<AuthDto> GetTokenAsync(LoginDto loginDto)//login
        {

            var user = loginDto.UserNameOrEmail.Contains('@')
                ? await _userManager.FindByEmailAsync(loginDto.UserNameOrEmail)
                : await _userManager.FindByNameAsync(loginDto.UserNameOrEmail);

            if (user is null || !await _userManager.CheckPasswordAsync(user, loginDto.Password))
            {
                return new AuthDto { Message = "Email or Password is incorrect!" };
            }

            if (!user.EmailConfirmed)
            {
                return new AuthDto { Message = "Please verify your email before logging in." };
            }

            var authDto = await GenerateAuthResultAsync(user);

            return authDto;
        }

        public async Task<JwtSecurityToken> CreateJwtToken(ApplicationUser user)
        {
            var userClaims = await _userManager.GetClaimsAsync(user);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.UserName),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim("Provider", user.LoginProvider ?? "Local")
            }
            .Union(userClaims);

            var symmetricSecurityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwt.Key));
            var signingCredentials = new SigningCredentials(symmetricSecurityKey, SecurityAlgorithms.HmacSha256);

            var jwtSecurityToken = new JwtSecurityToken(
                issuer: _jwt.Issuer,
                audience: _jwt.Audience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(_jwt.DurationInMinutes),
                signingCredentials: signingCredentials);

            return jwtSecurityToken;
        }

        public async Task<AuthDto> RefreshTokenAsync(string token)
        {
            var authDto = new AuthDto();

            var user = await _userManager.Users.SingleOrDefaultAsync(u => u.RefreshTokens.Any(t => t.Token == token));

            if (user == null)
            {
                authDto.Message = "Invalid token";
                return authDto;
            }

            var refreshToken = user.RefreshTokens.Single(t => t.Token == token);

            if (!refreshToken.IsActive)
            {
                authDto.Message = "Inactive token";
                return authDto;
            }

            refreshToken.RevokedOn = DateTime.UtcNow;

            var newRefreshToken = GenerateRefreshToken();
            user.RefreshTokens.Add(newRefreshToken);
            await _userManager.UpdateAsync(user);

            var jwtToken = await CreateJwtToken(user);
            authDto.IsAuthenticated = true;
            authDto.Token = new JwtSecurityTokenHandler().WriteToken(jwtToken);
            authDto.Email = user.Email;
            authDto.Username = user.UserName;
            var roles = await _userManager.GetRolesAsync(user);
            //authDto.Roles = roles.ToList();
            authDto.RefreshToken = newRefreshToken.Token;
            authDto.RefreshTokenExpiration = newRefreshToken.ExpiresOn;

            return authDto;
        }

        public async Task<bool> RevokeTokenAsync(string token)
        {
            var user = await _userManager.Users.SingleOrDefaultAsync(u => u.RefreshTokens.Any(t => t.Token == token));

            if (user == null)
                return false;

            var refreshToken = user.RefreshTokens.Single(t => t.Token == token);

            if (!refreshToken.IsActive)
                return false;

            refreshToken.RevokedOn = DateTime.UtcNow;

            await _userManager.UpdateAsync(user);

            return true;
        }

        public RefreshToken GenerateRefreshToken()
        {
            var bytes = new byte[32];

            var generator = RandomNumberGenerator.Create();

            generator.GetBytes(bytes);

            return new RefreshToken
            {
                Token = Convert.ToBase64String(bytes),
                ExpiresOn = DateTime.UtcNow.AddDays(10),
                CreatedOn = DateTime.UtcNow
            };
        }

        public async Task<AuthDto> GenerateAuthResultAsync(ApplicationUser user)
        {

            var authDto = new AuthDto();

            var jwtSecurityToken = await CreateJwtToken(user);


            authDto.IsAuthenticated = true;
            authDto.Token = new JwtSecurityTokenHandler().WriteToken(jwtSecurityToken);
            authDto.Email = user.Email;
            authDto.Username = user.UserName;
            authDto.ExpiresOn = jwtSecurityToken.ValidTo;


            if (user.RefreshTokens.Any(t => t.IsActive))
            {
                var activeRefreshToken = user.RefreshTokens.FirstOrDefault(t => t.IsActive);
                authDto.RefreshToken = activeRefreshToken.Token;
                authDto.RefreshTokenExpiration = activeRefreshToken.ExpiresOn;
            }
            else
            {
                var refreshToken = GenerateRefreshToken();
                authDto.RefreshToken = refreshToken.Token;
                authDto.RefreshTokenExpiration = refreshToken.ExpiresOn;
                user.RefreshTokens.Add(refreshToken);
                await _userManager.UpdateAsync(user);
            }

            return authDto;
        }

        public async Task<AuthDto> ChangePasswordAsync(string userId, ChangePasswordDto dto)
        {
            var authDto = new AuthDto();

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                authDto.Message = $"user not found";
                return authDto;
            }

            // 🔒 verify old password
            var passwordCheck = await _userManager.CheckPasswordAsync(user, dto.CurrentPassword);
            if (!passwordCheck)
            {
                authDto.Message = "Current password is incorrect";
                return authDto;
            }

            // 🔄 change password
            var result = await _userManager.ChangePasswordAsync(
                user,
                dto.CurrentPassword,
                dto.NewPassword
            );

            if (!result.Succeeded)
            {
                authDto.Message = string.Join(", ", result.Errors.Select(e => e.Description));
                return authDto;
            }

            // 🔐 revoke old refresh tokens (important!)
            foreach (var token in user.RefreshTokens)
            {
                token.RevokedOn = DateTime.UtcNow;
            }

            await _userManager.UpdateAsync(user);

            // 🔑 issue new tokens
            return await GenerateAuthResultAsync(user);
        }

        public async Task<bool> DeleteAccountAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return false;
            }

            var result = await _userManager.DeleteAsync(user);

            return result.Succeeded;
        }


        //------------------------ Reset Password Workflow ----------------------------

        public async Task<(bool Succeeded, string Message, string? Otp)> ForgotPasswordAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
                return (false, "User not found.", null);

            var otp = new Random().Next(100000, 999999).ToString();

            user.EmailVerificationCode = otp;
            user.EmailCodeExpiration = DateTime.UtcNow.AddMinutes(10);

            var result = await _userManager.UpdateAsync(user);
            if (!result.Succeeded)
                return (false, "Error updating user data.", null);

            return (true, "OTP generated successfully.", otp);
        }

        public async Task<(bool Succeeded, string Message, string? ResetToken)> VerifyPasswordOtpAsync(string email, string code)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
                return (false, "User not found.", null);

            if (user.EmailVerificationCode?.Trim() != code.Trim())
                return (false, "Invalid OTP code.", null);

            if (user.EmailCodeExpiration < DateTime.UtcNow)
                return (false, "OTP code expired.", null);

            user.EmailVerificationCode = null;
            user.EmailCodeExpiration = null;
            await _userManager.UpdateAsync(user);

            var resetToken = await _userManager.GeneratePasswordResetTokenAsync(user);

            return (true, "OTP verified successfully.", resetToken);
        }

        public async Task<(IdentityResult Result, string Message)> ResetPasswordAsync(ResetPasswordDto dto)
        {
            var user = await _userManager.FindByEmailAsync(dto.Email);
            if (user == null)
                return (IdentityResult.Failed(new IdentityError { Description = "User not found." }), "User not found.");

            var result = await _userManager.ResetPasswordAsync(user, dto.ResetToken, dto.NewPassword);
            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                return (result, errors);
            }

            foreach (var token in user.RefreshTokens)
            {
                token.RevokedOn = DateTime.UtcNow;
            }
            await _userManager.UpdateAsync(user);

            return (result, "Password has been reset successfully.");
        }

        public async Task<(bool Succeeded, string Message, string? Otp)> ResendPasswordOtpAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
                return (false, "User not found.", null);

            var newOtp = new Random().Next(100000, 999999).ToString();

            user.EmailVerificationCode = newOtp;
            user.EmailCodeExpiration = DateTime.UtcNow.AddMinutes(10);

            var result = await _userManager.UpdateAsync(user);
            if (!result.Succeeded)
                return (false, "Failed to update security code.", null);

            return (true, "New OTP generated successfully.", newOtp);
        }


        //-----------------------------------------------------------



        // Corrected Service Method
        public async Task<ApplicationUser> LoginWithGoogleAsync(GoogleUserDto googleUser)
        {
            var user = await _userManager.FindByEmailAsync(googleUser.Email);

            if (user == null)
            {
                user = new ApplicationUser
                {
                    UserName = googleUser.Email,
                    Email = googleUser.Email,
                    FirstName = googleUser.FirstName,
                    LastName = googleUser.LastName,
                   LoginProvider= "Google",
                    ProfilePictureUrl = googleUser.PictureUrl,
                    EmailConfirmed = true
                };

                var createResult = await _userManager.CreateAsync(user);
                if (!createResult.Succeeded)
                    return null;
                
                await _userManager.AddLoginAsync(user, new UserLoginInfo(
                    "Google",
                    googleUser.Subject, 
                    "Google"
                ));
            }

            return user;
        }



        public async Task<ApplicationUser> LoginWithFacebookAsync(string accessToken)
        {
            var validateTokenResult = await _facebookAuthService.ValidateAccessTokenAsync(accessToken);
            if (!validateTokenResult.Data.IsValid)
            {
                return null;
            }
            //var userInfo = await _facebookAuthService.GetUserInfoAsync(accessToken);

            //var user = await _userManager.FindByLoginAsync("Facebook", validateTokenResult.Data.UserId);
            //if (user == null)
            //{
            //    user = new ApplicationUser
            //    {
            //        Email = userInfo.Email,
            //        FirstName = userInfo.FirstName,
            //        LastName = userInfo.LastName,
            //        UserName = userInfo.Email,
            //        LoginProvider = "Facebook",
            //        ProfilePictureUrl = userInfo.FacebookPicture.Data.Url.ToString(),
            //        EmailConfirmed = true
            //    };

            var userInfo = await _facebookAuthService.GetUserInfoAsync(accessToken);
            if (userInfo == null) return null;

            string facebookUserId = validateTokenResult.Data.UserId;

            var user = await _userManager.FindByLoginAsync("Facebook", facebookUserId);

            if (user == null)
            {
                string safeEmail = string.IsNullOrEmpty(userInfo.Email)
                    ? $"{facebookUserId}@facebook.com"
                    : userInfo.Email;

                user = new ApplicationUser
                {
                    UserName = safeEmail,
                    Email = safeEmail,
                    FirstName = userInfo.FirstName ?? "Facebook",
                    LastName = userInfo.LastName ?? "User",
                    LoginProvider = "Facebook",
                    ProfilePictureUrl = userInfo.FacebookPicture?.Data?.Url?.ToString() ?? "",
                    EmailConfirmed = true
                };

                var createdResult = await _userManager.CreateAsync(user);
                if (!createdResult.Succeeded)
                {
                    return null;
                }
                await _userManager.AddLoginAsync(user, new UserLoginInfo("Facebook",
                    validateTokenResult.Data.UserId, "Facebook"));
            }
            return user;
        }

    }
}
