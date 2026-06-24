import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input
from PIL import Image

MODEL_PATH = "models/final_model.keras"
model = load_model(MODEL_PATH)

CLASS_NAMES = ["Healthy", "Rotten"]


def preprocess_image(image: Image.Image):
    image = image.resize((224, 224))
    img_array = np.array(image)

    if img_array.shape[-1] == 4:
        img_array = img_array[..., :3]

    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)

    return img_array


def predict(image: Image.Image):
    processed = preprocess_image(image)

    preds = model.predict(processed)
    rotten_prob = float(preds[0][0])
    healthy_prob = 1 - rotten_prob

    if rotten_prob > 0.5:
        predicted_class = "Rotten"
        confidence = rotten_prob
    else:
        predicted_class = "Healthy"
        confidence = healthy_prob

    return {
        "success": True,
        "prediction": {
            "predicted_class": predicted_class,
            "confidence": confidence,
            "probabilities": {
                "Healthy": healthy_prob,
                "Rotten": rotten_prob
            }
        }
    }