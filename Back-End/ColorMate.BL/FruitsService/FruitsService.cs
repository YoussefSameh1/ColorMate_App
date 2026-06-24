using ColorMate.Core.DTOs.FruitDto;
using ColorMate.Core.Models;
using ColorMate.EF.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;

namespace ColorMate.BL.FruitsService
{
    public class FruitsService : IFruitsService
    {
        private readonly HttpClient _httpClient;
        private readonly IUnitOfWork _unitOfWork;

        public FruitsService(HttpClient httpClient, IUnitOfWork unitOfWork)
        {
            _httpClient = httpClient;
            _unitOfWork = unitOfWork;
        }

        public async Task<FruitsResponseDto?> ClassifyFruitAsync(FruitsRequestDto requestDto, string userId)
        {
            try
            {
                using var content = new MultipartFormDataContent();

                using var stream = requestDto.UploadedImage.OpenReadStream();
                using var streamContent = new StreamContent(stream);

                streamContent.Headers.ContentType = new MediaTypeHeaderValue(requestDto.UploadedImage.ContentType);

                content.Add(streamContent, "file", requestDto.UploadedImage.FileName);

                _httpClient.DefaultRequestHeaders.Add("ngrok-skip-browser-warning", "true");

                var response = await _httpClient.PostAsync("predict", content);

                if (!response.IsSuccessStatusCode)
                {
                    return new FruitsResponseDto
                    {
                        Success = false,
                        Prediction = new()
                    };
                }

                var classificationResult = await response.Content.ReadFromJsonAsync<FruitsResponseDto>();

                if (classificationResult != null && classificationResult.Success)
                {
                    byte[] imageBytes;

                    using (var memoryStream = new MemoryStream())
                    {
                        await requestDto.UploadedImage.CopyToAsync(memoryStream);
                        imageBytes = memoryStream.ToArray();
                    }

                    var fruitDetection = new FruitClassificationWithImage
                    {
                        OriginalImage = imageBytes,
                        ApplicationUserId = userId,
                        PredictedClass = classificationResult.Prediction.Predicted_Class,
                        Confidence = classificationResult.Prediction.Confidence
                    };

                    _unitOfWork.FruitClassificationWithImages.Add(fruitDetection);
                    _unitOfWork.Complete();
                }

                return classificationResult;
            }
            catch (Exception ex)
            {
                // Temporary: Log the error to the console to see what's wrong
                Console.WriteLine($"Error: {ex.Message}");
                if (ex.InnerException != null) Console.WriteLine($"Inner: {ex.InnerException.Message}");

                return new FruitsResponseDto
                {
                    Success = false,
                    Prediction = new()
                };
            }
        }

        public List<FruitsHistoryResponseDto> GetUserFruitsHistory(string userId)
        {
            var history = _unitOfWork.FruitClassificationWithImages
                .GetAllQueryable()
                .Where(x => x.ApplicationUserId == userId)
                .OrderByDescending(x => x.Id)
                .ToList();

            if (!history.Any())
                return new List<FruitsHistoryResponseDto>();

            var result = new List<FruitsHistoryResponseDto>();

            foreach (var item in history)
            {
                string imageBase64 = null;

                if (item.OriginalImage != null && item.OriginalImage.Length > 0)
                {
                    imageBase64 = Convert.ToBase64String(item.OriginalImage);
                }

                result.Add(new FruitsHistoryResponseDto
                {
                    ImageBase64 = imageBase64,
                    PredictedClass = item.PredictedClass,
                    Confidence = item.Confidence
                });
            }

            return result;
        }

    }
}