# config.py 

# Model configuration
MODEL_PATH = 'models/yolo26m.pt'   # ✅ switched to detection medium model
CLASSES_TO_EXCLUDE = [0]  
CONFIDENCE_THRESHOLD = 0.3
IOU_THRESHOLD = 0.45

# API configuration
API_HOST = "0.0.0.0"
API_PORT = 8000
MAX_IMAGE_SIZE = 10 * 1024 * 1024  # 10MB

# Performance settings
USE_GPU = False  # ✅ force CPU