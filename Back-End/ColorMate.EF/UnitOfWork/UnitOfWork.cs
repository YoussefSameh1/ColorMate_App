using ColorMate.Core.Models;
using ColorMate.EF.Repositories.Base;
using ColorMate.EF.Repositories.User;
using System;
using System.Collections.Generic;
using System.Text;
using static System.Reflection.Metadata.BlobBuilder;

namespace ColorMate.EF.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly ApplicationDbContext _context;
        public IUserRepository Users { get; private set; }
        public IBaseRepository<TestQuestion> TestQuestions { get; private set; }
        public IBaseRepository<TestResult> TestResults { get; private set; }
        public IBaseRepository<UserAnswer> UserAnswers { get; private set; }
        public IBaseRepository<ObjDetectionWithImage> ObjDetectionWithImages { get; private set; }
        public IBaseRepository<OutfitRatingWithImage> OutfitRatingWithImages { get; private set; }
        public IBaseRepository<FruitClassificationWithImage> FruitClassificationWithImages { get; private set; }


        public UnitOfWork(
            ApplicationDbContext context,
            IUserRepository users,
            IBaseRepository<TestQuestion> testQuestions,
            IBaseRepository<TestResult> testResults,
            IBaseRepository<UserAnswer> userAnswers,
            IBaseRepository<ObjDetectionWithImage> objDetectionWithImages,
            IBaseRepository<OutfitRatingWithImage> outfitRatingWithImages,
            IBaseRepository<FruitClassificationWithImage> fruitClassificationWithImages)
        {
            _context = context;
            Users = users;
            TestQuestions = testQuestions;
            TestResults = testResults;
            UserAnswers = userAnswers;
            ObjDetectionWithImages = objDetectionWithImages;
            OutfitRatingWithImages = outfitRatingWithImages;
            FruitClassificationWithImages = fruitClassificationWithImages;
        }


        public int Complete()
        {
            return _context.SaveChanges();
        }

        public void Dispose()
        {
            _context.Dispose();
        }

    }
}