using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace ColorMate.Core.Models
{
    public class ApplicationUser : IdentityUser
    {

        public string FirstName { get; set; }
        public string LastName { get; set; }

        public string? EmailVerificationCode { get; set; }
        public DateTime? EmailCodeExpiration { get; set; }

        public string LoginProvider { get; set; }
        public string? ProfilePictureUrl { get; set; }

        public ICollection<OutfitRatingWithImage> OutfitRatingWithImage { get; set; } = new HashSet<OutfitRatingWithImage>();

        public ICollection<FruitClassificationWithImage> FruitClassificationWithImage { get; set; } = new HashSet<FruitClassificationWithImage>();

        public ICollection<ObjDetectionWithImage> ObjDetectionWithImage { get; set; } = new HashSet<ObjDetectionWithImage>();

        public ICollection<TestResult> TestResults { get; set; } = new HashSet<TestResult>();

        public List<RefreshToken>? RefreshTokens { get; set; } = new List<RefreshToken>();



    }
}
