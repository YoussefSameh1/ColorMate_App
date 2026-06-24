using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace ColorMate.Core.DTOs.FacebookDto
{
    public class FacebookLoginDto
    {
        [Required]
        public string AccessToken { get; set; }
    }
}
