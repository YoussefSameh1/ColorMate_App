using ColorMate.BL.EmailService;
using ColorMate.BL.FacebookService;
using ColorMate.BL.FruitsService;
using ColorMate.BL.ObjDetectionService;
using ColorMate.BL.OutfitRatingService;
using ColorMate.BL.ProfileService;
using ColorMate.BL.TestService;
using ColorMate.BL.UserService;
using ColorMate.Core.Models;
using ColorMate.EF;
using ColorMate.EF.Repositories.Base;
using ColorMate.EF.Repositories.User;
using ColorMate.EF.UnitOfWork;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi;
using System.Text;

namespace ColorMate.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            builder.Services.AddDbContext<ApplicationDbContext>(options =>
            {
                options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
            });

            builder.Services.Configure<BL.Settings.JWT>(builder.Configuration.GetSection("JWT"));


            builder.Services.AddTransient(typeof(IBaseRepository<>), typeof(BaseRepository<>));
            builder.Services.AddTransient<IUnitOfWork, UnitOfWork>();
            builder.Services.AddTransient<IUserRepository, UserRepository>();
            builder.Services.AddTransient<IUserService, UserService>();
            builder.Services.AddTransient<IEmailSender, EmailSender>();
            builder.Services.AddScoped<IFacebookAuthService, FacebookAuthService>();
            builder.Services.AddTransient<ITestService, TestService>();
            builder.Services.AddScoped<IProfileService, ProfileService>();
            builder.Services.AddSingleton<IWebHostEnvironment>(builder.Environment);

            builder.Services.AddHttpClient();


            //-----------------------Authentication----------------------------

            builder.Services.AddIdentity<ApplicationUser, IdentityRole>(
                options =>
                {
                    options.SignIn.RequireConfirmedEmail = true;
                }
                ).AddEntityFrameworkStores<ApplicationDbContext>().AddDefaultTokenProviders();


            builder.Services.AddAuthentication(options =>
            {
                //check jwt token in header
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme; //unauthorize response
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddGoogle(options =>
            {
                var ClientId = builder.Configuration["Authentication_Google_ClientId"];
                var ClientSecret = builder.Configuration["Authentication_Google_ClientSecret"];
                options.ClientId = ClientId;
                options.ClientSecret = ClientSecret;

            })
            .AddFacebook(facebookOptions =>
            {
                var AppId = builder.Configuration["Authentication_Facebook_AppId"];
                var AppSecret = builder.Configuration["Authentication_Facebook_AppSecret"];
                facebookOptions.AppId = AppId;
                facebookOptions.AppSecret = AppSecret;

            })
            .AddJwtBearer(o =>
            {
                o.MapInboundClaims = false;
                o.RequireHttpsMetadata = false;
                o.SaveToken = false;
                o.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidIssuer = builder.Configuration["JWT:Issuer"],
                    ValidAudience = builder.Configuration["JWT:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JWT:Key"])),
                    ClockSkew = TimeSpan.Zero
                };
            });


            //-----------------------Cors Policy------------------------

            builder.Services.AddCors(options =>
            {

                options.AddDefaultPolicy(policy =>
                {
                    policy.WithOrigins(builder.Configuration.GetSection("Domains").Get<string[]>() ?? [])
                    .AllowAnyMethod()
                    .AllowAnyHeader();
                });

            });

            builder.Services.AddHttpClient<IFruitsService, FruitsService>(client =>
            {
                var baseUrl = builder.Configuration["FruitsClassification:BaseUrl"];
                if (string.IsNullOrEmpty(baseUrl))
                {
                    throw new Exception("FruitsClassification:BaseUrl is missing in appsettings.json");
                }
                client.BaseAddress = new Uri(baseUrl);
            });


            builder.Services.AddHttpClient<IObjDetectionService, ObjDetectionService>(client =>
            {
                var baseUrl = builder.Configuration["ObjDetection:BaseUrl"];
                if (string.IsNullOrEmpty(baseUrl))
                {
                    throw new Exception("ObjDetection:BaseUrl is missing in appsettings.json");
                }
                client.BaseAddress = new Uri(baseUrl);
            });

            builder.Services.AddHttpClient<IOutfitRatingService, OutfitRatingService>(client =>
            {
                var baseUrl = builder.Configuration["OutfitRating:BaseUrl"];
                if (string.IsNullOrEmpty(baseUrl))
                {
                    throw new Exception("OutfitRating:BaseUrl is missing in appsettings.json");
                }
                client.BaseAddress = new Uri(baseUrl);
            });



            //builder.Services.AddCors(options =>
            //{
            //    options.AddPolicy("AllowFrontend", policy =>
            //    {
            //        policy
            //            .WithOrigins(
            //                "http://127.0.0.1:5500",
            //                "http://localhost:5500"
            //            )
            //            .AllowAnyMethod()
            //            .AllowAnyHeader();
            //    });
            //});

            //var Google = builder.Configuration.GetSection("Authentication:Google");
            //builder.Services.AddAuthentication().AddGoogle(options =>
            //{
            //    options.ClientId = Google["ClientId"]!;
            //    options.ClientSecret = Google["ClientSecret"]!;
            //    options.CallbackPath = "/signin-google";
            //});

            // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
            //builder.Services.AddOpenApi();


            //------------------- Swagger -------------------

            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            #region Swagger Region


            //builder.Services.AddSwaggerGen(swagger =>
            //{
            //    //This is to generate the Default UI of Swagger Documentation    
            //    swagger.SwaggerDoc("v1", new OpenApiInfo
            //    {
            //        Version = "v1",
            //        Title = "ASP.NET 10 Web API",
            //        Description = "ColorMate Project"
            //    });
            //    // To Enable authorization using Swagger (JWT)    
            //    swagger.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
            //    {
            //        Name = "Authorization",
            //        Type = SecuritySchemeType.ApiKey,
            //        Scheme = "Bearer",
            //        BearerFormat = "JWT",
            //        In = ParameterLocation.Header,
            //        Description = "Enter 'Bearer' [space] and then your valid token in the text input below.\r\n\r\nExample: \"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\"",
            //    });
            //    swagger.AddSecurityRequirement(new OpenApiSecurityRequirement
            //    {
            //        {
            //        new OpenApiSecurityScheme
            //        {
            //        Reference = new OpenApiReference
            //        {
            //        Type = ReferenceType.SecurityScheme,
            //        Id = "Bearer"
            //        }
            //        },
            //        new string[] {}
            //        }
            //        });
            //});
            #endregion




            var app = builder.Build();

            // app.UseDeveloperExceptionPage();
            //app.UseStaticFiles();
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(
                Path.Combine(builder.Environment.ContentRootPath, "wwwroot")),
                RequestPath = ""
            });

            // Configure the HTTP request pipeline.
            //if (app.Environment.IsDevelopment())
            //{
            //    //app.MapOpenApi();
            //    app.UseSwagger();
            //    app.UseSwaggerUI();
            //}

            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }
            else
            {
                app.UseSwagger();
                app.UseSwaggerUI(options =>
                {

                    options.SwaggerEndpoint("/swagger/v1/swagger.json", "v1");
                    options.RoutePrefix = string.Empty;
                    app.UseDeveloperExceptionPage();
                });

            }
            // app.UseHttpsRedirection();
            app.UseCors();

            app.UseAuthentication();
            app.UseAuthorization();


            app.MapControllers();
            app.Run();
        }
    }
}