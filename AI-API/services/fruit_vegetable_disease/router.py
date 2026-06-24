from fastapi import APIRouter, UploadFile, File
from PIL import Image
import io

from .model import predict

router = APIRouter()


@router.post("/predict")
async def classify_fruit(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")

    result = predict(image)

    return result