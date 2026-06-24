using ColorMate.BL.TestService;
using ColorMate.Core.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ColorMate.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class IshiharaController : ControllerBase
    {

        private readonly ITestService _testService;
        public IshiharaController(ITestService testService)
        {
            _testService = testService;
        }

        [HttpPost("submit-answers")]
        public IActionResult SubmitAnswers([FromBody] List<TestAnswersDto> testAnswersDto)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
            {
                return BadRequest("userId is null");
            }

            var response = _testService.CalculateTestResult(userId!, testAnswersDto);

            return Ok(response);
        }

    }
}
