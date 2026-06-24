using ColorMate.Core.Models;
using ColorMate.EF.Repositories.Base;
using ColorMate.EF.Repositories.User;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.EF.UnitOfWork
{
    public interface IUnitOfWork : IDisposable
    {
        IUserRepository Users { get; }
        IBaseRepository<TestQuestion> TestQuestions { get; }
        IBaseRepository<TestResult> TestResults { get; }
        IBaseRepository<UserAnswer> UserAnswers { get; }
        IBaseRepository<ObjDetectionWithImage> ObjDetectionWithImages { get; }
        IBaseRepository<OutfitRatingWithImage> OutfitRatingWithImages { get; }
        IBaseRepository<FruitClassificationWithImage> FruitClassificationWithImages { get; }

        int Complete();
    }
}
