<div align="center">

<img src="./assets/colormate_logo.png" alt="ColorMate Logo" width="180"/>

# ColorMate

### An AI-powered assistive mobile app for people with Color Vision Deficiency (CVD)

[![Flutter](https://img.shields.io/badge/Mobile-Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![ASP.NET Core](https://img.shields.io/badge/Backend-ASP.NET%20Core%20.NET%2010-512BD4?logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/apps/aspnet)
[![FastAPI](https://img.shields.io/badge/AI%20Services-FastAPI-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-CC2927?logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![YOLO](https://img.shields.io/badge/Object%20Detection-YOLO-111111)](https://docs.ultralytics.com/models/yolov8/)
[![Gemini](https://img.shields.io/badge/Chatbot-Gemini%20API-8E75B2?logo=googlegemini&logoColor=white)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-Academic%20Project-lightgrey)]()

</div>

---

## 📖 Overview

Color vision deficiency (CVD) affects an estimated **300 million people worldwide**, creating daily challenges such as mismatched clothing, misread signals, and difficulty interpreting visual information. Most existing assistive apps are narrow in scope — they solve one small piece of the problem instead of offering an integrated experience.

**ColorMate** is a smart mobile application that combines **computer vision, deep learning, and AI-driven personalization** into a single, cohesive assistive tool. It helps users:

- 🔍 Identify the **type and severity** of their color vision deficiency
- 🎨 Detect objects and their real-world colors using the camera
- 🖼️ Simulate and **correct** images to improve color distinguishability
- 👕 Get **outfit color-matching** feedback and recommendations
- 🍎 Check the **freshness/quality of fruits and vegetables**
- 🤖 Chat with an AI assistant for guidance and education
- 🎮 Learn through interactive, color-themed mini-games

The system is built on a **three-tier architecture**: a **Flutter** mobile frontend, an **ASP.NET Core (.NET 10) Web API** backend, and a dedicated **Python/FastAPI** AI microservice — backed by **SQL Server**. The backend is live at `http://colormate.runasp.net`.

---

## 🎓 Project Information

This project was developed as a graduation project at the **Faculty of Computers and Artificial Intelligence, Fayoum University** (2026).

**Team Members**
| Name |
|------|
| Germeen George Halim |
| Beshoy Gamal Wahba |
| Youssef Sameh Awad |
| Mariam Naeem Saeed |
| Mina Magdy Neseem |
| Youssef Nasan Sedhom |

**Supervised By**
- Dr. Mary Monir
- Eng. Khaled Ahmed
- Eng. Hossam Ahmed

---

## 📂 Repository Structure

```
ColorMate/
├── AI-API/             # Python/FastAPI AI microservice (YOLO detection, fruit model, color harmony engine)
├── Back-End/           # ASP.NET Core (.NET 10) Web API — layered solution (API/BL/Core/EF)
├── Mobile-App/         # Flutter mobile application (renamed from Front-End)
└── Documentation.pdf   # Full graduation project documentation
```

| Folder | Description | Details |
|---|---|---|
| **[`AI-API/`](./AI-API)** | A **FastAPI** service exposing three routers: object detection (YOLO), fruit/vegetable freshness classification (MobileNetV3Large), and a rule-based clothing color-harmony evaluation engine. | [AI-API README](./AI-API/README.md) |
| **[`Back-End/`](./Back-End)** | A layered **ASP.NET Core** solution (`ColorMate.API` / `ColorMate.BL` / `ColorMate.Core` / `ColorMate.EF`) handling auth (JWT + Google/Facebook OAuth + email OTP), the Ishihara test, and orchestration of calls to `AI-API`, persisted via EF Core to SQL Server. | [Back-End README](./Back-End/README.md) |
| **[`Mobile-App/`](./Mobile-App)** | The Flutter client — feature-first architecture covering auth, the Ishihara test, object/color detection, outfit matching, fruit scanning, image correction, a Gemini-powered chatbot, 5 mini-games, and profile management. | [Mobile-App README](./Mobile-App/README.md) |
| **`Documentation.pdf`** | The complete graduation project report: problem definition, planning, related work, system analysis, architecture, implementation details, model evaluation, and future work. | — |

> 📘 Each subfolder has its own detailed README — click through above for setup instructions, full API references, and architecture notes specific to that layer.

---

## ✨ Core Features

### 1. 🧪 Color Vision Deficiency (Ishihara) Test
A digital adaptation of the **Ishihara Color Test**, using 14 plates to detect whether a user has normal vision, a borderline result, or a deficiency — and classifies it as **Protan (red)**, **Deutan (green)**, or uncertain, based on standard Ishihara diagnostic scoring rules.

### 2. 🟢 Object & Color Detection
Uses a pretrained **YOLO** model (Ultralytics) to detect and localize objects/clothing items in real time, then extracts the dominant color from each detected bounding box and maps it to a human-readable color name.

### 3. 🌈 Color Blindness Simulation & Correction
- **Simulation:** Shows users how an image would look to someone with Protanopia, Deuteranopia, or Tritanopia.
- **Correction (Daltonization):** Applies an error-redistribution algorithm using color shift matrices to push "confusing" color information into channels the user can better perceive — without drastically altering the image's natural appearance.

### 4. 👗 Outfit Color Harmony & Recommendations
The **Perceptual Color Harmony System (PCHS)** is a context-aware scoring framework that evaluates how well the colors of an uploaded outfit work together, then generates a rating and actionable suggestions for improvement.

### 5. 🍌 Fruit & Vegetable Freshness Detection
A fine-tuned **MobileNetV3Large** binary classifier determines whether produce is **Healthy** or **Rotten** based on visual and color characteristics — trained on a dataset of **28,645 images**.

### 6. 🤖 AI Chatbot Assistant
A conversational assistant built directly into the Flutter app using **Google's Gemini API** (`flutter_gemini` package). It answers user questions about color blindness, fashion, outfit recommendations, and how to use the app — no backend round-trip required.

### 7. 🎮 Educational Mini-Games
Interactive color-learning games — **Color Collector**, **Memory Match**, **Color the Picture**, **Sequence**, and **Find the Object** — designed to help children learn and recognize colors in an engaging way.

### 8. 👤 Account & Profile Management
Secure registration/login (JWT-based authentication via ASP.NET Identity), profile editing, and password management.

---

## 🧠 AI Models In Depth

ColorMate's intelligence layer is built around three specialized models:

### 🍎 Fruit Freshness Classification Model — `MobileNetV3Large`
| Detail | Value |
|---|---|
| Dataset | [Fruit and Vegetable Disease (Healthy vs Rotten)](https://www.kaggle.com/datasets/muhammad0subhan/fruit-and-vegetable-disease-healthy-vs-rotten) — 28,645 images |
| Split | 72% train (20,624) / 8% validation (2,292) / 20% test (5,729) |
| Input | 224 × 224 × 3 RGB |
| Strategy | Two-phase transfer learning — Phase 1: frozen base, train custom head (lr = 1e-3); Phase 2: fine-tune all 187 layers end-to-end (lr = 3e-5) |
| Regularization | L2 penalties, Dropout (0.4, 0.3), Label Smoothing (0.05), class weighting for imbalance |

**Final Test Results**

| Metric | Healthy | Rotten | Overall |
|---|---|---|---|
| Precision | 0.9757 | 0.9289 | 0.9523 |
| Recall | 0.9253 | 0.9770 | 0.9512 |
| F1-Score | 0.9498 | 0.9523 | 0.9511 |
| AUC | — | — | 0.9781 |
| **Accuracy** | — | — | **95.12%** |

> Outperforms the reference paper's baseline model by **+0.98%** (94.14% → 95.12%).

### 🎨 Perceptual Color Harmony System (PCHS)
A context-aware scoring pipeline that segments outfit items (via a YOLO segmentation model), extracts dominant colors, and evaluates color compatibility against established color-harmony principles — producing a harmony score and improvement recommendations.

### 📦 Object Detection Model — `YOLO`
A pretrained YOLO model (Ultralytics, COCO-trained base) used for high-speed, real-time detection and localization of objects and clothing items, enabling downstream color analysis. The deployed weights file is `yolo26m.pt`.

---

## 🏗️ System Architecture

ColorMate follows a **three-tier architecture**, with a dedicated AI processing layer:

```
┌──────────────────────────┐        ┌─────────────────────────┐
│     Mobile App (Flutter) │───────▶│  Google Gemini API       │  (Chatbot — direct, no backend hop)
│  Camera, UI, Ishihara UI │        └─────────────────────────┘
└────────────┬─────────────┘
             │ HTTPS / REST (JSON)
┌────────────▼─────────────────┐
│  Back-End API (ASP.NET Core, │ ← Application / Logic Layer
│  .NET 10 · JWT · EF Core)    │
└──────┬──────────────┬────────┘
       │              │
┌──────▼─────┐  ┌─────▼────────────────────┐
│ SQL Server  │  │  AI-API (FastAPI)        │ ← Data Layer / AI Layer
│ (Data Layer)│  │ YOLO · MobileNetV3Large  │
│             │  │ Color Harmony Engine     │
└─────────────┘  └──────────────────────────┘
```

- **Presentation Tier — [`Mobile-App/`](./Mobile-App)**: Flutter app handling UI, camera capture, and result rendering. Calls the chatbot's LLM (Gemini) directly from the device.
- **Logic Tier — [`Back-End/`](./Back-End)**: ASP.NET Core Web API managing auth (JWT + Google/Facebook OAuth + email OTP), business logic, and orchestration of calls to `AI-API`.
- **AI Tier — [`AI-API/`](./AI-API)**: FastAPI service for object/color detection (YOLO), fruit freshness (MobileNetV3Large), and outfit color-harmony scoring.
- **Data Tier**: Microsoft SQL Server (via EF Core) storing user profiles, test results, and saved AI-analysis history.

A live instance of the backend is currently deployed at `http://colormate.runasp.net`.

### Security
- **Authentication:** ASP.NET Identity, with email OTP verification required before sign-in
- **Authorization:** JWT (access + refresh tokens) on every protected endpoint, plus Google & Facebook OAuth login
- **Transport:** Communication over HTTPS in production

### Key API Endpoints (Back-End)

| Endpoint | Method | Description |
|---|---|---|
| `/api/Users/Register` | `POST` | Registers a new user account, sends email OTP |
| `/api/Users/Login` | `POST` | Authenticates a user, returns a JWT |
| `/api/Verification/VerifyEmailOtp` | `POST` | Confirms a user's email via OTP |
| `/api/Ishihara/submit-answers` | `POST` | Submits Ishihara test answers, returns CVD classification |
| `/api/ObjDetection/upload-image` | `POST` | Detects objects/colors in an uploaded image |
| `/api/Fruits/upload-image` | `POST` | Classifies a fruit/vegetable as Healthy or Rotten |
| `/api/OutfitRating/upload-image` | `POST` | Scores outfit color harmony and returns suggestions |
| `/api/Profile` | `GET` / `PUT` | Retrieves or updates the user's profile |

> See the [Back-End README](./Back-End/README.md) for the complete endpoint reference, and the [AI-API README](./AI-API/README.md) for the underlying AI service endpoints it calls into.

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Mobile | **Flutter & Dart** | Cross-platform UI/UX and client-side logic |
| Backend | **ASP.NET Core (.NET 10)** | Layered Web API (API/BL/Core/EF projects) |
| ORM | **Entity Framework Core 10** | Database operations |
| Database | **Microsoft SQL Server** | Relational data storage |
| AI Service | **FastAPI (Python)** | Object detection, fruit classification, color harmony scoring |
| Deep Learning | **MobileNetV3Large, YOLO (Ultralytics)** | Fruit classification & object/clothing detection |
| Image Processing | **OpenCV, NumPy, Pillow** | Image preprocessing for AI inference |
| Chatbot | **Google Gemini API** (via `flutter_gemini`, called directly from the mobile app) | Conversational assistant |
| Auth | **JWT + ASP.NET Identity + Google/Facebook OAuth** | Secure authentication & authorization |
| State Management | **flutter_bloc (Cubit)** | Mobile app state management |
| Routing | **go_router** | Mobile app navigation |
| Testing | **Postman** | API testing during development |
| Version Control | **GitHub** | Source control and collaboration |

---

## 📱 App Highlights

- **Ishihara-based CVD Test** — a guided, plate-by-plate digital assessment
- **Object & Color Detection** — point the camera, get instant color names
- **Outfit Analysis** — upload an outfit, get a compatibility score + tips
- **Fruit Scanner** — instantly check if produce is fresh or rotten
- **Color Correction & Simulation** — see and adjust for Protanopia, Deuteranopia, and Tritanopia
- **AI Chatbot** — ask questions about colors, fashion, or the app itself
- **Mini-Games** — Color Collector, Memory Match, Color the Picture, Sequence, Find the Object
- **Profile Management** — register, log in, edit profile, change password

---

## 🚀 Getting Started

> 💡 The backend is already deployed at `http://colormate.runasp.net`, so if you only want to run the **Mobile-App**, you may not need to stand up `Back-End` or `AI-API` locally at all. The steps below cover running the full stack locally.

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `>=3.7.0`)
- [.NET 10 SDK](https://dotnet.microsoft.com/download)
- [Python 3.10+](https://www.python.org/) with `pip`
- [Microsoft SQL Server](https://www.microsoft.com/sql-server)
- Android Studio / Xcode (for mobile builds & emulation)

### 1. Clone the repository
```bash
git clone https://github.com/YoussefSameh1/ColorMate_App.git
cd ColorMate_App
```

### 2. Run the AI-API (FastAPI)
```bash
cd AI-API
pip install -r requirements.txt
uvicorn main:app --reload
# Runs on http://127.0.0.1:8000 — model weights are already included under models/
```

### 3. Run the Back-End (ASP.NET Core)
```bash
cd Back-End
# Update ColorMate.API/appsettings.json with your SQL Server connection string,
# JWT key, and AI-API URLs (see Back-End/README.md for details)
dotnet restore
dotnet ef database update --project ColorMate.EF --startup-project ColorMate.API
dotnet run --project ColorMate.API
```

### 4. Run the Mobile App
```bash
cd Mobile-App
flutter pub get
# Create a .env file with GEMINI_API_KEY=your_key_here (see Mobile-App/README.md)
flutter run
```

> 📘 For full setup details, environment variables, and the complete API reference for each layer, see: [AI-API README](./AI-API/README.md) · [Back-End README](./Back-End/README.md) · [Mobile-App README](./Mobile-App/README.md)

---

## 🔭 Future Work

- 🌍 **Multilingual support** to reach users across different regions
- 📈 **Improved AI model accuracy** through expanded datasets and advanced training techniques across varied lighting conditions
- 🎥 **Real-time video-based** object and color detection
- 🕶️ **Augmented reality (AR) integration** for live, on-the-go color correction
- 🧒 **Interactive Color Learning Encyclopedia** for children, expanding the educational module
- 🤝 Features that promote awareness, confidence, and social connection for individuals with color blindness

---

## 📚 References & Datasets

- Fruit and Vegetable Disease (Healthy vs Rotten) — [Kaggle Dataset](https://www.kaggle.com/datasets/muhammad0subhan/fruit-and-vegetable-disease-healthy-vs-rotten)
- COCO 2017 Dataset — [Kaggle](https://www.kaggle.com/datasets/awsaf49/coco-2017-dataset)
- DeepFashion Multimodal — [GitHub](https://github.com/yumingj/DeepFashion-MultiModal)
- Ultralytics YOLOv8 — [Docs](https://docs.ultralytics.com/models/yolov8/)
- Flutter — [docs.flutter.dev](https://docs.flutter.dev/)
- ASP.NET Core — [learn.microsoft.com](https://learn.microsoft.com/en-us/aspnet/core/)

Full citation list available in `Documentation.pdf`.

---

## 📄 License

This project was developed as an academic graduation project for the **Faculty of Computers and Artificial Intelligence, Fayoum University**. Please contact the team for usage or licensing inquiries.

---

<div align="center">

Made with ❤️ by the ColorMate Team — helping the world see colors a little more clearly.

</div>
