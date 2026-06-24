using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.DTOs.FruitDto
{
    public class FruitsRequestDto
    {
        public IFormFile UploadedImage { get; set; }
    }
}
