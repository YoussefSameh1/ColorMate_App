using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.Core.Models
{
    public class UserAnswer
    {
        public int Id { get; set; }
        public string? Answer { get; set; }
        public bool IsCorrect { get; set; }
        public int TestQuestionId { get; set; }
        public TestQuestion TestQuestion { get; set; }
        public int TestResultId { get; set; }
        public TestResult TestResult { get; set; }

    }
}
