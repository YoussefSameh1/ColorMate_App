using ColorMate.Core.Models;
using ColorMate.EF.Configuration;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.EF
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public DbSet<TestQuestion> TestQuestions { get; set; }
        public DbSet<UserAnswer> UserAnswers { get; set; }
        public DbSet<TestResult> TestResults { get; set; }
        public DbSet<OutfitRatingWithImage> OutfitRatingsWithImages { get; set; }
        public DbSet<OutfitSuggestion> OutfitSuggestions { get; set; }
        public DbSet<FruitClassificationWithImage> FruitClassificationWithImages { get; set; }
        public DbSet<ObjDetectionWithImage> ObjDetectionsWithImages { get; set; }
        public DbSet<ObjFromDetection> ObjsFromDetection { get; set; }



        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationUserConfig).Assembly);


            modelBuilder.Entity<TestResult>()
                .HasMany(t => t.Answers)
                .WithOne(ua => ua.TestResult)
                .HasForeignKey(ua => ua.TestResultId);

            modelBuilder.Entity<TestQuestion>()
                .HasMany(t => t.Answers)
                .WithOne(ua => ua.TestQuestion)
                .HasForeignKey(ua => ua.TestQuestionId);


            modelBuilder.Entity<ApplicationUser>()
                .HasMany(u => u.TestResults)
                .WithOne(t => t.ApplicationUser)
                .HasForeignKey(t => t.ApplicationUserId);


            modelBuilder.Entity<ApplicationUser>()
                .HasMany(u => u.OutfitRatingWithImage)
                .WithOne(i => i.ApplicationUser)
                .HasForeignKey(i => i.ApplicationUserId);

            modelBuilder.Entity<ApplicationUser>()
                .HasMany(u => u.FruitClassificationWithImage)
                .WithOne(i => i.ApplicationUser)
                .HasForeignKey(i => i.ApplicationUserId);

            modelBuilder.Entity<ApplicationUser>()
                .HasMany(u => u.ObjDetectionWithImage)
                .WithOne(i => i.ApplicationUser)
                .HasForeignKey(i => i.ApplicationUserId);


            modelBuilder.Entity<ObjDetectionWithImage>()
                .HasMany(u => u.Objects)
                .WithOne(i => i.ObjDetectionWithImage)
                .HasForeignKey(i => i.ObjDetectionWithImageId);


            modelBuilder.Entity<OutfitRatingWithImage>()
                .HasMany(o => o.Suggestions)
                .WithOne(s => s.OutfitRatingWithImage)
                .HasForeignKey(s => s.OutfitRatingWithImageId);


            modelBuilder.Entity<TestQuestion>().HasData(
                new TestQuestion { Id = 1, ImageId = 1, NormalAnswer = "12", UsedForDiagnosis = true },
                new TestQuestion { Id = 2, ImageId = 2, NormalAnswer = "8", UsedForDiagnosis = true },
                new TestQuestion { Id = 3, ImageId = 3, NormalAnswer = "5", UsedForDiagnosis = true },
                new TestQuestion { Id = 4, ImageId = 4, NormalAnswer = "29", UsedForDiagnosis = true },
                new TestQuestion { Id = 5, ImageId = 5, NormalAnswer = "74", UsedForDiagnosis = true },
                new TestQuestion { Id = 6, ImageId = 6, NormalAnswer = "7", UsedForDiagnosis = true },
                new TestQuestion { Id = 7, ImageId = 7, NormalAnswer = "45", UsedForDiagnosis = true },
                new TestQuestion { Id = 8, ImageId = 8, NormalAnswer = "2", UsedForDiagnosis = true },
                new TestQuestion { Id = 9, ImageId = 9, NormalAnswer = "x", UsedForDiagnosis = true },
                new TestQuestion { Id = 10, ImageId = 10, NormalAnswer = "16", UsedForDiagnosis = true },
                new TestQuestion { Id = 11, ImageId = 11, NormalAnswer = "97", UsedForDiagnosis = true },

                // Color Blind specific
                new TestQuestion { Id = 12, ImageId = 12, NormalAnswer = "35", ProtanAnswer = "5", DeutanAnswer = "3", UsedForDiagnosis = false },
                new TestQuestion { Id = 13, ImageId = 13, NormalAnswer = "96", ProtanAnswer = "6", DeutanAnswer = "9", UsedForDiagnosis = false },
                new TestQuestion { Id = 14, ImageId = 14, NormalAnswer = "26", ProtanAnswer = "6", DeutanAnswer = "2", UsedForDiagnosis = false }


            );



            base.OnModelCreating(modelBuilder);
        }
    }
}
