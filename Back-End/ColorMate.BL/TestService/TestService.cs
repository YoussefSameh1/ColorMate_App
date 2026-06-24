using ColorMate.Core.DTOs;
using ColorMate.Core.Models;
using ColorMate.EF.UnitOfWork;

namespace ColorMate.BL.TestService
{
    public class TestService : ITestService
    {
        private readonly IUnitOfWork _unitOfWork;

        public TestService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public TestResultDto CalculateTestResult(string userId, List<TestAnswersDto> testAnswersDto)
        {
            var result = new TestResult
            {
                ApplicationUserId = userId,
                TestTime = DateTime.Now,
                Answers = new List<UserAnswer>()
            };

            var platesDB = _unitOfWork.TestQuestions.GetAll().ToDictionary(q => q.ImageId);

            int diagnosisNormalCount = 0;
            int protanCount = 0;
            int deutanCount = 0;

            foreach (var answer in testAnswersDto)
            {
                if (!platesDB.TryGetValue(answer.ImageId, out var questionDB)) continue;

                var userAnswer = new UserAnswer
                {
                    TestQuestionId = questionDB.Id,
                    Answer = answer.Value,
                    TestResultId = result.Id,
                    IsCorrect = false
                };

                
                if (string.Equals(answer.Value, questionDB.NormalAnswer, StringComparison.OrdinalIgnoreCase))
                {
                    userAnswer.IsCorrect = true;

                    if (questionDB.UsedForDiagnosis)
                    {
                        diagnosisNormalCount++;
                    }
                }
                else
                {
                    
                    if (!questionDB.UsedForDiagnosis)
                    {
                        if (string.Equals(answer.Value, questionDB.ProtanAnswer, StringComparison.OrdinalIgnoreCase))
                            protanCount++;
                        else if (string.Equals(answer.Value, questionDB.DeutanAnswer, StringComparison.OrdinalIgnoreCase))
                            deutanCount++;
                    }
                }

                result.Answers.Add(userAnswer);
            }

            

            if (diagnosisNormalCount >= 10)
            {
                result.Diagnosis = "Normal";
            }
            else if (diagnosisNormalCount == 8 || diagnosisNormalCount == 9)
            {
                result.Diagnosis = "Borderline";
            }
            else if (diagnosisNormalCount <= 7)
            {
                if (protanCount > deutanCount)
                    result.Diagnosis = "Protan";
                else if (deutanCount > protanCount)
                    result.Diagnosis = "Deutan";
                else
                    result.Diagnosis = "Uncertainty";
            }
            else
            {
                result.Diagnosis = "Uncertainty";
            }

            _unitOfWork.TestResults.Add(result);
            _unitOfWork.Complete();

            return new TestResultDto
            {
                TestTime = result.TestTime,
                Diagnosis = result.Diagnosis,
                CorrectAnswerCount = result.Answers.Count(a => a.IsCorrect),
                ProtanAnswerCount = protanCount,
                DeutanAnswerCount = deutanCount
            };
        }
    }
}