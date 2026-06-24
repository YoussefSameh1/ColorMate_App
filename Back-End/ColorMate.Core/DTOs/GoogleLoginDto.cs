using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace ColorMate.Core.DTOs
{
    public class GoogleLoginDto
    {
        [Required]
        public string IdToken { get; set; }
    }
}
