# main.py
# uvicorn main:app --reload
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from services.object_detection.service import router as detection_router
from services.fruit_vegetable_disease.router import router as disease_router
from services.clothing_color_harmony_evaluator.router import router as harmony_router

app = FastAPI(title="ColorMate AI API")

# CORS (same as yours)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(
    detection_router,
    prefix="/object-detection",
    tags=["Object Detection"])
app.include_router(
    disease_router, 
    prefix="/fruit-vegetable-disease",
    tags=["Fruit & Vegetable Disease Detection"]) 
app.include_router(
    harmony_router,
    prefix="/clothing-color-harmony",
    tags=["Clothing Color Harmony"]
)     
@app.get("/")
def root():
    return {"message": "ColorMate AI API is running"}