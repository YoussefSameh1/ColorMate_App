using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace ColorMate.Core.DTOs.Forgot_ResetPasswordDto
{
    public class VerifyOtpDto
    {
        [Required, EmailAddress]
        public string Email { get; set; }

        [Required]
        public string OtpCode { get; set; }
    }
}
