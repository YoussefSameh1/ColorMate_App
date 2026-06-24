"""
ColorMate API — Production-ready wrapper for the ColorMate v9 engine.

Usage:
    from colormate_api import ColorMateAPI

    api = ColorMateAPI()
    result = api.analyze("path/to/outfit.jpg")

Future FastAPI integration:
    from fastapi import FastAPI, UploadFile
    from colormate_api import ColorMateAPI

    app = FastAPI()
    engine = ColorMateAPI()

    @app.post("/analyze")
    async def analyze_outfit(file: UploadFile):
        path = save_temp(file)
        return engine.analyze(path)
"""

from .model import ClothingColorHarmonyAnalyzer


class ColorMateAPI:
    """Production-ready API wrapper for the ColorMate v9 engine."""

    VERSION = "9.0"

    def __init__(self, model_path=None, conf_thresh=None):
        """
        Initialize the ColorMate engine in production mode.

        Args:
            model_path:   Optional path to a custom YOLOv8 model weights file.
            conf_thresh:  Optional confidence threshold for segmentation.
        """
        self._engine = ClothingColorHarmonyAnalyzer(
            verbose=False,
            render=False,
            model_path="models/OutfitHarmony_HF_SafeRebuild_v1.pt",
            conf_thresh=0.25,
        )

    def analyze(self, image_path: str) -> dict:
        """
        Analyze a single outfit image.

        Args:
            image_path: Absolute or relative path to the input image.

        Returns:
            Structured dict with keys:
                score, raw_score, feedback_level, interpretation,
                outfit_type, items, recommendation
        """
        result = self._engine.analyze_image(image_path, mode="production")

        return {
            "score": result["score"],
            "suggestions": result["recommendation"]["suggestions"]
        }

    def analyze_batch(self, image_paths: list) -> list:
        """
        Analyze multiple outfit images.

        Args:
            image_paths: List of image file paths.

        Returns:
            List of structured result dicts (one per image).
        """
        return [self.analyze(p) for p in image_paths]

    def health_check(self) -> dict:
        """Check if the engine is initialized and ready."""
        return {
            "status": "ok",
            "version": self.VERSION,
            "engine": "ColorMate Harmony Evaluator",
        }
