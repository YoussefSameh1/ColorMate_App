using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs.OutfitRatingDto
{
    public class OutfitRatingRequestDto
    {
        public IFormFile uploadedImage { get; set; }
    }
}
