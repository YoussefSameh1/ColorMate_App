using ColorMate.Core.DTOs.OutfitRatingDto;
using ColorMate.Core.Models;
using ColorMate.EF.UnitOfWork;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Threading.Tasks;

namespace ColorMate.BL.OutfitRatingService
{
    public class OutfitRatingService : IOutfitRatingService
    {
        private readonly HttpClient _httpClient;
        private readonly IUnitOfWork _unitOfWork;

        public OutfitRatingService(HttpClient httpClient, IUnitOfWork unitOfWork)
        {
            _httpClient = httpClient;
            _unitOfWork = unitOfWork;
        }

        public async Task<OutfitRatingResponseDto?> GetOutfitRatingAsync(OutfitRatingRequestDto requestDto, string userId)
        {
            try
            {
                using var content = new MultipartFormDataContent();
                using var stream = requestDto.uploadedImage.OpenReadStream();
                using var streamContent = new StreamContent(stream);
                streamContent.Headers.ContentType = new MediaTypeHeaderValue(requestDto.uploadedImage.ContentType);

                content.Add(streamContent, "file", requestDto.uploadedImage.FileName);
                _httpClient.DefaultRequestHeaders.Add("ngrok-skip-browser-warning", "true");

                var response = await _httpClient.PostAsync("analyze", content);

                if (!response.IsSuccessStatusCode)
                {
                    return new OutfitRatingResponseDto { Score = -1, Suggestions = new List<string>() };
                }

                var rawJson = await response.Content.ReadAsStringAsync();

                
                using var document = JsonDocument.Parse(rawJson);
                var root = document.RootElement;

                double score = root.TryGetProperty("score", out var scoreElement) ? scoreElement.GetDouble() : -1;

                var suggestionsEntities = new List<OutfitSuggestion>();
                var textSuggestions = new List<string>();

                if (root.TryGetProperty("suggestions", out var suggestionsElement) && suggestionsElement.ValueKind == JsonValueKind.Array)
                {
                    foreach (var item in suggestionsElement.EnumerateArray())
                    {
                        int rank = item.TryGetProperty("rank", out var rankEl) ? rankEl.GetInt32() : 0;
                        string text = item.TryGetProperty("text", out var textEl) ? textEl.GetString() ?? "" : "";
                        string urgency = item.TryGetProperty("urgency", out var urgEl) ? urgEl.GetString() ?? "" : "";
                        string reason = item.TryGetProperty("reason", out var reasonEl) ? reasonEl.GetString() ?? "" : "";

                        
                        suggestionsEntities.Add(new OutfitSuggestion
                        {
                            Rank = rank,
                            Text = text,
                            Urgency = urgency,
                            Reason = reason
                        });

                        
                        textSuggestions.Add(text);
                    }
                }

                byte[] imageBytes;
                using (var memoryStream = new MemoryStream())
                {
                    using var imageStream = requestDto.uploadedImage.OpenReadStream();
                    await imageStream.CopyToAsync(memoryStream);
                    imageBytes = memoryStream.ToArray();
                }

                var outfitWithImage = new OutfitRatingWithImage
                {
                    OriginalImage = imageBytes,
                    ApplicationUserId = userId,
                    Score = (int)score,
                    Suggestions = suggestionsEntities
                };

                _unitOfWork.OutfitRatingWithImages.Add(outfitWithImage);
                _unitOfWork.Complete();

                return new OutfitRatingResponseDto
                {
                    Score = score,
                    Suggestions = textSuggestions
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"CATCH ERROR MESSAGE: {ex.Message}");
                return new OutfitRatingResponseDto { Score = -1, Suggestions = new List<string>() };
            }
        }

        public List<OutfitRatingHistoryResponseDto> GetUserOutfitRatingsHistory(string userId)
        {
            var userHistory = _unitOfWork.OutfitRatingWithImages.GetAllQueryable()
                .Include(o => o.Suggestions)
                .Where(od => od.ApplicationUserId == userId)
                .OrderByDescending(o => o.Id)
                .ToList();

            if (!userHistory.Any())
                return new List<OutfitRatingHistoryResponseDto>();

            var outfitHistoryList = new List<OutfitRatingHistoryResponseDto>();

            foreach (var outfit in userHistory)
            {
                string imageBase64 = null;
                if (outfit.OriginalImage != null && outfit.OriginalImage.Length > 0)
                {
                    imageBase64 = Convert.ToBase64String(outfit.OriginalImage);
                }

                var textSuggestions = outfit.Suggestions.Select(s => s.Text).ToList();

                outfitHistoryList.Add(new OutfitRatingHistoryResponseDto
                {
                    ImageBase64 = imageBase64,
                    Score = outfit.Score,
                    Suggestions = textSuggestions
                });
            }

            return outfitHistoryList;
        }
    }
}