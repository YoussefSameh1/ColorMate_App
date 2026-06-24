using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs
{
    public class ChangePasswordDto
    {
        public string CurrentPassword { get; set; }
        public string NewPassword { get; set; }
    }
}
