using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.Models
{
    public class ObjDetectionWithImage
    {
        public int Id { get; set; }
        public byte[]? OriginalImage { get; set; }
        public string ApplicationUserId { get; set; }
        public ApplicationUser ApplicationUser { get; set; }
        public ICollection<ObjFromDetection> Objects { get; set; } = new HashSet<ObjFromDetection>();

    }
}
