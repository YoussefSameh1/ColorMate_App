using ColorMate.Core.DTOs.ObjDetectionDto;
using ColorMate.Core.Models;
using ColorMate.EF.UnitOfWork;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;

namespace ColorMate.BL.ObjDetectionService
{
    public class ObjDetectionService : IObjDetectionService
    {
        private readonly HttpClient _httpClient;
        private readonly IUnitOfWork _unitOfWork;


        public ObjDetectionService(HttpClient httpClient, IUnitOfWork unitOfWork)
        {
            _httpClient = httpClient;
            _unitOfWork = unitOfWork;
        }

        public async Task<ObjDetectionResponseDto?> GetObjectsAsync(ObjDetectionRequestDto requestDto, string userId)
        {
            try
            {
                using var content = new MultipartFormDataContent();
                using var stream = requestDto.uploadedImage.OpenReadStream();
                using var streamContent = new StreamContent(stream);
                streamContent.Headers.ContentType = new MediaTypeHeaderValue(requestDto.uploadedImage.ContentType);

                content.Add(streamContent, "file", requestDto.uploadedImage.FileName);

                _httpClient.DefaultRequestHeaders.Add("ngrok-skip-browser-warning", "true");

                var response = await _httpClient.PostAsync("detect", content);

                if (!response.IsSuccessStatusCode)
                {
                    return new ObjDetectionResponseDto
                    {
                        Success = false,
                        Objects = new List<DetectedObjectDto>(),
                        TotalObjects = 0
                    };
                }

                var detectionResult = await response.Content.ReadFromJsonAsync<ObjDetectionResponseDto>();

                if (detectionResult != null && detectionResult.Success)
                {
                    // Save the image and detected objects to database
                    await SaveDetectionResult(requestDto, detectionResult, userId);
                }

                return detectionResult;
            }
            catch
            {
                return new ObjDetectionResponseDto
                {
                    Success = false,
                    Objects = new List<DetectedObjectDto>(),
                    TotalObjects = 0
                };
            }
        }

        public List<DetectionHistoryResponseDto> GetUserDetectionsHistory(string userId)
        {
            var userHistory = _unitOfWork.ObjDetectionWithImages.GetAllQueryable().Where(od => od.ApplicationUserId == userId)
            .Include(od => od.Objects)
            .OrderByDescending(od => od.Id)
            .ToList();

            if (!userHistory.Any())
            {
                return new List<DetectionHistoryResponseDto>();
            }

            var detectionsHistoryList = new List<DetectionHistoryResponseDto>();

            foreach (var detection in userHistory)
            {
                // Convert byte array to Base64

                string imageBase64 = null;
                if (detection.OriginalImage != null && detection.OriginalImage.Length > 0)
                {
                    imageBase64 = Convert.ToBase64String(detection.OriginalImage);
                }

                var detectionDto = new DetectionHistoryResponseDto
                {
                    ImageBase64 = imageBase64,
                    TotalObjects = detection.Objects?.Count ?? 0,

                    Objects = detection.Objects?.Select(obj => new DetectedObjectDto
                    {
                        ObjectId = obj.Id,
                        ClassName = obj.ClassName,
                        Confidence = obj.Confidence,
                        Bbox = obj.Bbox ?? new List<int>()
                    }).ToList() ?? new List<DetectedObjectDto>()
                };

                detectionsHistoryList.Add(detectionDto);
            }

            return detectionsHistoryList;
        }

        private async Task SaveDetectionResult(ObjDetectionRequestDto requestDto, ObjDetectionResponseDto result, string userId)
        {
            byte[] imageBytes;

            // Convert IFormFile to byte array for database storage
            using (var memoryStream = new MemoryStream())
            {
                await requestDto.uploadedImage.CopyToAsync(memoryStream);
                imageBytes = memoryStream.ToArray();
            }

            var detectionWithImage = new ObjDetectionWithImage
            {
                OriginalImage = imageBytes,
                ApplicationUserId = userId,
                Objects = new HashSet<ObjFromDetection>()
            };

            foreach (var obj in result.Objects)
            {
                detectionWithImage.Objects.Add(new ObjFromDetection
                {
                    ClassName = obj.ClassName,
                    Confidence = obj.Confidence,
                    Bbox = obj.Bbox ?? new List<int>()
                });
            }

            _unitOfWork.ObjDetectionWithImages.Add(detectionWithImage);
            _unitOfWork.Complete();

        }

    }
}