using ColorMate.Core.DTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.BL.TestService
{
    public interface ITestService
    {
        TestResultDto CalculateTestResult(string userId, List<TestAnswersDto> testAnswersDto);
    }
}
