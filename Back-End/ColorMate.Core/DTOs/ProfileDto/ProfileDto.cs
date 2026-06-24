using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs.ProfileDto
{

    public class ProfileDto
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string ProfilePictureUrl { get; set; }
    }
    
}
