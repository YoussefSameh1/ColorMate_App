from fastapi import APIRouter, UploadFile, File
import shutil
import os
from .service import ColorMateAPI

router = APIRouter()
engine = ColorMateAPI()

UPLOAD_DIR = "temp"
os.makedirs(UPLOAD_DIR, exist_ok=True)


@router.post("/analyze")
async def analyze_outfit(file: UploadFile = File(...)):
    file_path = os.path.join(UPLOAD_DIR, file.filename)

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    result = engine.analyze(file_path)

    return result


@router.get("/health")
def health():
    return engine.health_check()