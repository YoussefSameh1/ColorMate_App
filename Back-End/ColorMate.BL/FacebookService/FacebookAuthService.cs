using ColorMate.Core.DTOs.FacebookDto;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.BL.FacebookService
{
    public class FacebookAuthService : IFacebookAuthService
    {

       private const string TokenValidationUrl = "https://graph.facebook.com/debug_token?input_token={0}&access_token={1}|{2}";
       private const string UserInfoUrl = "https://graph.facebook.com/me?fields=id,name,email,first_name,last_name,picture&access_token={0}";

        private readonly IHttpClientFactory _httpClientFactory;
        public readonly string AppId;
        public readonly string AppSecret;

        public FacebookAuthService(IHttpClientFactory httpClientFactory, IConfiguration configuration)
        {
            _httpClientFactory = httpClientFactory;
            AppId = configuration["Authentication_Facebook_AppId"];
            AppSecret = configuration["Authentication_Facebook_AppSecret"];
        }



        public async Task<FacebookUserInfoResult> GetUserInfoAsync(string accessToken)
        {
            var FormattedUrl = string.Format(UserInfoUrl, accessToken);
            var result = await _httpClientFactory.CreateClient().GetAsync(FormattedUrl);
            result.EnsureSuccessStatusCode();
            var content = await result.Content.ReadAsStringAsync();
            return JsonConvert.DeserializeObject<FacebookUserInfoResult>(content);
        }

        public async Task<FacebookTokenValidationResult> ValidateAccessTokenAsync(string accessToken)
        {
            var FormattedUrl = string.Format(TokenValidationUrl, accessToken, AppId, AppSecret);
            var result = await _httpClientFactory.CreateClient().GetAsync(FormattedUrl);
            result.EnsureSuccessStatusCode();
            var content = await result.Content.ReadAsStringAsync();
            return JsonConvert.DeserializeObject<FacebookTokenValidationResult>(content);
        }
    }
}
