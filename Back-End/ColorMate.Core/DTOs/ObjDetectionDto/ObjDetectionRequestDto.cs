using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs.ObjDetectionDto
{
    public class ObjDetectionRequestDto
    {
        public IFormFile uploadedImage { get; set; }
    }
}
