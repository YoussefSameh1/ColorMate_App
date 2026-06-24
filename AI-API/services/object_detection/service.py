from fastapi import APIRouter, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
import cv2
import numpy as np
from ultralytics import YOLO
import io
from PIL import Image
from typing import List
from . import config

router = APIRouter()

# Load model once
model = YOLO(config.MODEL_PATH)

# ✅ Force CPU (since GPU not working)
model.to("cpu")


def load_image_from_upload(file: UploadFile) -> np.ndarray:
    try:
        contents = file.file.read()
        image = Image.open(io.BytesIO(contents))
        image = image.convert('RGB')
        image_np = np.array(image)
        image_bgr = cv2.cvtColor(image_np, cv2.COLOR_RGB2BGR)
        return image_bgr
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid image file: {str(e)}")


@router.get("/")
async def root():
    return {"message": "Object Detection API is running"}


@router.get("/health")
async def health_check():
    return {"status": "healthy", "model": "YOLOv8m (CPU)"}


@router.post("/detect")
async def detect_objects(file: UploadFile = File(...)):
    try:
        image = load_image_from_upload(file)

        results = model(
            image,
            conf=config.CONFIDENCE_THRESHOLD,
            classes=[c for c in range(len(model.names)) if c not in config.CLASSES_TO_EXCLUDE]
        )

        detected_objects = []

        for result in results:
            boxes = result.boxes

            if boxes is None:
                continue

            for idx, box in enumerate(boxes):
                x1, y1, x2, y2 = box.xyxy[0].cpu().numpy()

                class_id = int(box.cls[0])
                class_name = model.names[class_id]
                confidence = float(box.conf[0])

                detected_objects.append({
                    "object_id": idx,
                    "class_name": class_name,
                    "confidence": round(confidence, 2),
                    "bbox": [int(x1), int(y1), int(x2), int(y2)]
                })

        return JSONResponse({
            "success": True,
            "objects": detected_objects,
            "total_objects": len(detected_objects)
        })

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"success": False, "error": str(e)}
        )


@router.post("/detect-batch")
async def detect_batch(files: List[UploadFile] = File(...)):
    results = []

    for file in files:
        try:
            result = await detect_objects(file)
            results.append({
                "filename": file.filename,
                "result": result.body.decode()
            })
        except Exception as e:
            results.append({
                "filename": file.filename,
                "error": str(e)
            })

    return {"results": results}