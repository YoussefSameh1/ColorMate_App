<div align="center">

# ⚙️ ColorMate — Back-End

**ASP.NET Core Web API — authentication, business logic, and orchestration for ColorMate**

</div>

This is the central API that the Flutter mobile app talks to. It handles user accounts (including Google/Facebook login), the Ishihara color-blindness test, and proxies image-analysis requests to the Python `AI-API` service, persisting results for each user along the way.

---

## 📂 Solution Structure

The backend is a **layered (N-tier) .NET solution** with four projects, defined in [`ColorMate.slnx`](./ColorMate.slnx):

```
Back-End/
├── ColorMate.API/            # Presentation layer — controllers, Program.cs, app config
│   ├── Controllers/
│   │   ├── UsersController.cs           # Register, login, OAuth, password reset, tokens
│   │   ├── VerificationController.cs     # Email OTP verification
│   │   ├── ProfileController.cs          # Get/update profile, profile picture
│   │   ├── IshiharaController.cs         # Submit color-blindness test answers
│   │   ├── FruitsController.cs           # Fruit freshness analysis + history
│   │   ├── ObjDetectionController.cs     # Object & color detection + history
│   │   └── OutfitRatingController.cs     # Outfit color harmony analysis + history
│   ├── Program.cs            # App startup: auth, EF Core, CORS, HTTP clients, Swagger
│   ├── appsettings.json      # Connection strings, JWT settings, AI service URLs
│   └── appsettings.Development.json
├── ColorMate.BL/             # Business logic layer — one service per feature
│   ├── UserService/          # Auth, JWT issuing/refresh, OAuth, password reset
│   ├── FacebookService/      # Facebook token verification
│   ├── EmailService/         # SMTP email sending (OTP codes, etc.)
│   ├── TestService/          # Ishihara test scoring logic
│   ├── FruitsService/        # Calls AI-API's fruit endpoint, persists results
│   ├── ObjDetectionService/  # Calls AI-API's object-detection endpoint, persists results
│   ├── OutfitRatingService/  # Calls AI-API's harmony endpoint, persists results
│   ├── ProfileService/       # Profile CRUD + picture upload
│   └── Settings/             # Strongly-typed config (e.g. JWT settings)
├── ColorMate.Core/           # Shared layer — domain models & DTOs
│   ├── Models/                # ApplicationUser, TestResult, TestQuestion, UserAnswer,
│   │                           # RefreshToken, FruitClassificationWithImage,
│   │                           # ObjDetectionWithImage, OutfitRatingWithImage, OutfitSuggestion
│   └── DTOs/                  # Request/response contracts, grouped by feature
└── ColorMate.EF/             # Data access layer — EF Core
    ├── ApplicationDbContext.cs
    ├── Configuration/         # Entity configuration (Fluent API)
    ├── Repositories/          # Generic + user-specific repositories
    ├── UnitOfWork/            # Unit-of-work pattern wrapping repositories
    └── Migrations/            # EF Core migrations (SQL Server)
```

**Dependency flow:** `ColorMate.API` → `ColorMate.BL` → `ColorMate.EF` → all referencing `ColorMate.Core` for shared models/DTOs.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | **ASP.NET Core (.NET 10)** |
| ORM | **Entity Framework Core 10** (SQL Server provider) |
| Auth | **ASP.NET Identity** + **JWT Bearer** + **Google OAuth** + **Facebook OAuth** |
| Email | **MailKit** (SMTP) |
| API Docs | **Swashbuckle / Swagger** |
| Database | **Microsoft SQL Server** |

Full package list is in [`ColorMate.API.csproj`](./ColorMate.API/ColorMate.API.csproj).

---

## 🚀 Getting Started

### Prerequisites
- [.NET 10 SDK](https://dotnet.microsoft.com/download)
- Microsoft SQL Server (local or remote instance)
- The `AI-API` service running and reachable (locally or via a tunnel like ngrok)

### 1. Configure `appsettings.json`

Update [`ColorMate.API/appsettings.json`](./ColorMate.API/appsettings.json) with your own values before running:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.;Database=ColorMate;TrustServerCertificate=True;Trusted_Connection=True"
  },
  "JWT": {
    "Key": "<your-own-secret-key>",
    "Issuer": "SecureApi",
    "Audience": "SecureApiUser",
    "DurationInMinutes": 60
  },
  "ObjDetection": {
    "BaseUrl": "http://localhost:8000/object-detection/"
  },
  "FruitsClassification": {
    "BaseUrl": "http://localhost:8000/fruit-vegetable-disease/"
  },
  "OutfitRating": {
    "BaseUrl": "http://localhost:8000/clothing-color-harmony/"
  },
  "Email": {
    "SmtpHost": "smtp.gmail.com",
    "SmtpPort": "587",
    "FromEmail": "<your-email>"
  }
}
```

> ⚠️ **Security note:** the committed `appsettings.json` currently contains a real JWT signing key and a personal Gmail address. Before pushing further or deploying, move secrets like the JWT key, SMTP credentials, and OAuth client secrets into **user secrets** (`dotnet user-secrets`), environment variables, or a secrets manager — and rotate the exposed key.

You'll also need to set Google/Facebook OAuth credentials (referenced in `Program.cs`):
```bash
dotnet user-secrets set "Authentication_Google_ClientId" "<your-client-id>"
dotnet user-secrets set "Authentication_Google_ClientSecret" "<your-client-secret>"
dotnet user-secrets set "Authentication_Facebook_AppId" "<your-app-id>"
dotnet user-secrets set "Authentication_Facebook_AppSecret" "<your-app-secret>"
```

### 2. Apply EF Core migrations

```bash
cd Back-End/ColorMate.API
dotnet tool restore   # installs the EF Core CLI tool pinned in dotnet-tools.json
dotnet ef database update --project ../ColorMate.EF --startup-project .
```

### 3. Run the API

```bash
dotnet restore
dotnet run --project ColorMate.API
```

By default, Swagger UI is available at the app's root URL in this project (configured via `options.RoutePrefix = string.Empty` for non-development environments, and at `/swagger` in development).

---

## 🔐 Authentication

- **JWT Bearer tokens** are required on all `[Authorize]`-protected endpoints (sent via the `Authorization: Bearer <token>` header).
- **Refresh tokens** are supported (`/api/Users/refreshToken`, `/api/Users/revokeToken`).
- **Email verification (OTP)** is required after registration — `RequireConfirmedEmail = true` is enforced via ASP.NET Identity.
- **Social login** is supported for both **Google** and **Facebook**, returning the same JWT auth payload as standard login.

---

## 🔌 API Reference

All controllers are routed as `api/[controller]` (ASP.NET Core convention) unless noted.

### `UsersController` — `/api/Users`

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `Register` | `POST` | — | Registers a new user, sends an email OTP |
| `Login` | `POST` | — | Authenticates with email/password, returns JWT |
| `refreshToken` | `POST` | — | Issues a new access token from a refresh token |
| `revokeToken` | `POST` | — | Revokes a refresh token |
| `change-password` | `POST` | ✅ | Changes the authenticated user's password |
| `delete-account` | `DELETE` | ✅ | Deletes the authenticated user's account |
| `ForgotPassword` | `POST` | — | Sends a password-reset OTP via email |
| `VerifyPasswordOtp` | `POST` | — | Verifies the reset OTP, returns a reset token |
| `ResetPassword` | `POST` | — | Resets the password using a valid reset token |
| `ResendPasswordOtp` | `POST` | — | Resends a new password-reset OTP |
| `LoginWithGoogle` | `POST` | — | Logs in/registers via a Google ID token |
| `LoginWithFacebook` | `POST` | — | Logs in/registers via a Facebook access token |

### `VerificationController` — `/api/Verification`

| Endpoint | Method | Description |
|---|---|---|
| `VerifyEmailOtp` | `POST` | Confirms a user's email using the OTP sent at registration |
| `ResendOtp` | `POST` | Sends a new email-verification OTP |

### `ProfileController` — `/api/Profile`

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/` | `GET` | ✅ | Gets the authenticated user's profile |
| `/` | `PUT` | ✅ | Updates profile fields |
| `/picture` | `PUT` | ✅ | Uploads/updates the profile picture (JPEG/PNG/WebP, max 5MB) |
| `/picture` | `DELETE` | ✅ | Removes the profile picture |

### `IshiharaController` — `/api/Ishihara`

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `submit-answers` | `POST` | ✅ | Submits Ishihara plate answers and returns the calculated CVD result |

### `FruitsController` — `/api/Fruits`

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `upload-image` | `POST` | ✅ | Sends an image to AI-API for freshness classification, saves the result |
| `user-fruits-history` | `GET` | ✅ | Returns the authenticated user's past fruit scans |

### `ObjDetectionController` — `/api/ObjDetection`

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `upload-image` | `POST` | ✅ | Sends an image to AI-API for object/color detection, saves the result |
| `user-detections-history` | `GET` | ✅ | Returns the authenticated user's past detections |

### `OutfitRatingController` — `/api/OutfitRating`

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `upload-image` | `POST` (multipart) | ✅ | Sends an outfit image to AI-API for harmony scoring, saves the result |
| `user-outfit-ratings-history` | `GET` | ✅ | Returns the authenticated user's past outfit ratings |

> All AI-related controllers (`FruitsController`, `ObjDetectionController`, `OutfitRatingController`) act as a thin orchestration layer: they forward the uploaded image to the corresponding `AI-API` endpoint via `HttpClient`, then persist the structured result against the authenticated user before returning it.

---

## 🗄️ Data Model (Key Entities)

Defined in `ColorMate.Core/Models/`:

- **`ApplicationUser`** — extends ASP.NET Identity's `IdentityUser`; holds profile info and navigation properties to all of a user's history (outfit ratings, fruit scans, detections, test results, refresh tokens)
- **`TestResult`** / **`TestQuestion`** / **`UserAnswer`** — Ishihara test data and scoring history
- **`FruitClassificationWithImage`** — saved fruit freshness results
- **`ObjDetectionWithImage`** / **`ObjFromDetection`** — saved object/color detection results
- **`OutfitRatingWithImage`** / **`OutfitSuggestion`** — saved outfit harmony results
- **`RefreshToken`** — JWT refresh token records

---

## 🧪 Testing

API testing during development was done with **Postman**. Once running locally, you can also exercise endpoints via Swagger UI or `curl`:

```bash
curl -X POST http://localhost:5000/api/Users/Login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"YourPassword123!"}'
```

---

## ⚠️ Notes & Gotchas

- **Secrets in `appsettings.json`**: see the security note above — rotate the committed JWT key before any public/production use.
- **AI service URLs**: `ObjDetection`, `FruitsClassification`, and `OutfitRating` base URLs in `appsettings.json` currently point to an ngrok tunnel used during development. Update these to your local `AI-API` URL (e.g. `http://localhost:8000/...`) or your deployed AI service URL.
- **CORS** origins are read from the `Domains` config array, which is currently empty — add your Flutter app's allowed origins as needed for web/testing scenarios.

---

## 📝 License

Part of the ColorMate graduation project, Faculty of Computers and Artificial Intelligence, Fayoum University (2026).
