using ColorMate.Core.DTOs.FacebookDto;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.BL.FacebookService
{
    public interface IFacebookAuthService
    {
        Task<FacebookTokenValidationResult> ValidateAccessTokenAsync(string accessToken);
        Task<FacebookUserInfoResult> GetUserInfoAsync(string accessToken);
    }
}
