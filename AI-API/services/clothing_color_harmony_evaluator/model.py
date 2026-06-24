# =============================================================================
#  CLOTHING COLOR HARMONY EVALUATOR  — v6.0  "Perceptually-Aligned Stylist"
#  ─────────────────────────────────────────────────────────────────────────────
#  Google Colab Compatible  |  Rule-Based  |  No ML Training Required
#
#  v6.0 CHANGES OVER v5.0  — Perception-first scoring (4 targeted fixes)
#  ─────────────────────────────────────────────────────────────────────────
#
#  ROOT CAUSE ADDRESSED
#  ─────────────────────
#  The v5.0 system was mathematically consistent but perceptually incorrect:
#  high-contrast outfits (pink+black, olive jacket+white shirt) were scored
#  ~10–19 pts below human judgment.
#
#  Diagnosis: _contrast_score() used a Gaussian with a peak at ΔE=50.
#  This PENALISED strong contrast (ΔE>50) — the opposite of human perception.
#    - Pink (L≈55) + Black (L≈5): ΔE≈74 → old score 0.51  (should be ~0.90)
#    - White (L≈97) + Dark pants (L≈20): ΔE≈77 → old score 0.44 (should be ~0.90)
#
#  FIX 1 — _contrast_score(): Gaussian → Monotonic Exponential  (MODULE 5)
#    The Gaussian model assumed "too much contrast is bad" — wrong for fashion.
#    Hue harmony already penalises clashing hues; contrast_harmony should model
#    visual SEPARATION, which is monotonically desirable.
#    New curve: f(ΔE) = max(floor, peak × (1 − e^(−ΔE/σ)))
#    - ΔE=5  → 0.30 (floor; imperceptibly similar)
#    - ΔE=20 → 0.56 (noticeable)
#    - ΔE=40 → 0.78 (clear separation)
#    - ΔE=60 → 0.87 (strong, good)
#    - ΔE=80+ → 0.92 (excellent visual separation)
#    Expected impact: +0.20–0.40 on contrast_score for high-contrast pairs.
#    No impact on low-contrast (monochrome) outfits — still handled upstream.
#
#  FIX 2 — contrast_harmony(): Lightness-spread perception boost  (MODULE 5)
#    When max pairwise ΔL* ≥ 55 (clear dark-vs-light separation), apply a
#    perception boost capped at +0.06. Models the human eye's strong response
#    to luminance contrast — a foundational principle of visual perception.
#    Explicit achromatic anchors: if any item has L* < 12 (near-black) or
#    L* > 92 (near-white), the outfit is guaranteed strong visual anchoring.
#    The boost is additive, bounded by _MAX_RAW, and only fires when ΔL* is
#    genuinely large — never on flat, low-contrast looks.
#
#  FIX 3 — hue_harmony() + contrast_harmony(): Dominance-weighted pairs
#    Previously, all item pairs were weighted by quality only — a small
#    accessory counted equally with the main jacket.  Now pair weights combine
#    quality × area_ratio, so large garments influence scores proportionally.
#    area_ratios is a new optional parameter (default: uniform); no breaking
#    changes to external callers that omit it.
#
#  FIX 4 — lightness_balance(): Max-spread bonus for high-contrast outfits
#    Averaging pairwise ΔL* scores dilutes the signal when one pair has
#    extreme contrast (e.g. white + very dark pants, ΔL*=77) but another pair
#    is moderate.  A small bonus (up to +0.04) is added when the maximum
#    pairwise ΔL* ≥ 60, rewarding outfits that achieve excellent lightness
#    anchoring even if not every pair is maximally contrasted.
#
#  PIPELINE CHANGE
#    analyze() now passes area_ratios to hue_harmony() and contrast_harmony()
#    so dominance weighting is always active.  The signature of both rules
#    gains an optional area_ratios parameter (default None → uniform weights).
#
#  WHAT DID NOT CHANGE
#  ────────────────────
#  All other scoring rule formulas, calibration curves, recommendation engine,
#  context gates, segmentation pipeline, and output contract are unchanged.
#
#  v5.0 CHANGES (context-aware architecture — unchanged in v6.0)
#  ────────────────────────────────────────────────────────────────────────
#
#  PROBLEM STATEMENT
#  ─────────────────
#  After real-world testing with the YOLO segmenter, four systemic failures
#  were identified — not bugs, but architectural blind spots:
#
#    FAIL 1 — Coverage blindness: when YOLO misses a layer (e.g. shirt under
#             a jacket), the system treats the incomplete detection as ground
#             truth and evaluates with full confidence.
#
#    FAIL 2 — Achromatic anchor bias: achromatic_anchor() returns 0.65 for
#             any outfit with zero neutral items — a blanket penalty that
#             treats a well-paired 2-item colourful outfit as "lacking balance"
#             simply because it has no grey/white/black piece.
#
#    FAIL 3 — Single-item inflation: the < 2-item fallback returns 0.85 on
#             every rule, giving a single dress a 79% harmony score despite
#             there being no inter-item relationships to evaluate.
#
#    FAIL 4 — Outfit-type blindness: all outfit structures (1 / 2 / 3+ items,
#             minimal / layered / complex) run through identical scoring weights,
#             so a balanced 2-item look is compared against the same standard
#             as a 4-piece outfit.
#
#  v5.0 FIXES
#  ──────────
#  FIX 1 — SegmentationCoverageAssessor  (new MODULE 1b)
#    Analyses the clothing dict BEFORE scoring begins.  Detects:
#      • Fewer items than expected for the outfit structure (layering gap)
#      • Low total coverage of the person mask (< 40% = partial detection)
#      • Missing expected categories (outwear present, no inner layer)
#    Emits a CoverageReport with:
#      • confidence: float  ("detection confidence" fed into scoring)
#      • flags: [str]       (human-readable warnings for the output dict)
#      • is_partial: bool   (True = scoring results should be treated cautiously)
#    When is_partial=True, the calibrator applies an additional uncertainty
#    penalty (default 4 pts) so the score reflects that the evaluation is
#    incomplete — not that the outfit is bad.
#
#  FIX 2 — OutfitTypeClassifier  (new MODULE 1c)
#    Classifies the detected outfit into one of four types:
#      • minimal  — 1–2 items, ≤1 chromatic piece
#      • simple   — 2 items with clear colour contrast
#      • layered  — jacket/outwear over inner garment
#      • complex  — 3+ distinct chromatic pieces
#    The outfit type is stored in the pipeline result dict and used
#    downstream by the scoring rules and recommendation engine.
#
#  FIX 3 — achromatic_anchor() made outfit-type-aware
#    The rule now receives the outfit_type and applies different logic:
#      • minimal / simple: neutral anchor is optional — 2-item colourful
#        outfits do not need a grey/black piece to be balanced.  The penalty
#        for having zero neutrals is removed; the rule returns 0.78 instead.
#      • layered: inner layer may be largely hidden; do not penalise for
#        missing neutrals if layering is present.
#      • complex: original logic applies — 3+ chromatic pieces genuinely
#        benefit from a neutral anchor; the penalty is correct.
#
#  FIX 4 — single-item score correction
#    When only 1 item is detected (e.g. a dress), the < 2-item fallback now
#    returns 0.70 (not 0.85) on rules that measure inter-item relationships
#    (hue_harmony, lightness_balance, contrast_harmony).  Rules that measure
#    properties of individual items (chroma_balance, achromatic_anchor) still
#    run their normal single-item logic.  This brings 1-item outfit scores
#    into the 65–72% range — "acceptable but unverifiable" — rather than
#    the misleading 79% that implied full harmony evaluation.
#
#  WHAT DID NOT CHANGE
#  ────────────────────
#  All scoring rule formulas, calibration curves, recommendation engine logic,
#  context gates, segmentation pipeline, and output contract are unchanged.
#  This release is purely additive: two new helper modules + small targeted
#  adjustments to three existing methods.
#
#  v4.1 CHANGES (scoring realism — unchanged in v5.0)
#  ─────────────────────────────────────────────────────
#    CHANGE 1 — _MAX_RAW: 0.95 → 0.88
#    CHANGE 2 — ScoreCalibrator: baseline_imperfection = 3.5 pts
#    CHANGE 3 — Revised upper calibration anchors
#
#  v4.0 CHANGES (YOLO segmentation — unchanged in v5.0)
#  ──────────────────────────────────────────────────────
#    YOLOv8-seg + DeepFashion2 replaces DeepLab
#    7-step mask quality pipeline
#    Layering detection + occlusion subtraction
#
#  References
#  ──────────
#    Itten (1961) · Munsell (1921) · Matsuda (1995)
#    Birkhoff (1933) · Cohen-Or et al. SIGGRAPH (2006)
#    Phung et al. (2005) — Skin Segmentation Using Color Pixel Classification
#    Kakumanu et al. (2007) — A survey of skin-color modeling
#    DeepFashion2 (Ge et al. CVPR 2019) — DeepFashion2 dataset / taxonomy
# =============================================================================

# ─── CELL 1: Install (run once per Colab session) ────────────────────────────
"""
%%bash
pip install -q torch torchvision opencv-python-headless \
               scikit-learn scikit-image matplotlib Pillow numpy scipy \
               ultralytics
"""

# ─── CELL 2: Mount Drive ─────────────────────────────────────────────────────
# (Colab-only — not used in production deployment)
# from google.colab import drive
# drive.mount('/content/drive')

# ─── CELL 3: Imports ─────────────────────────────────────────────────────────

import numpy as np
import cv2
import json
import colorsys
import warnings
from pathlib import Path

import matplotlib
matplotlib.use("Agg")  # headless-safe backend for server deployment
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.gridspec as gridspec
from matplotlib.colors import LinearSegmentedColormap

from PIL import Image
from sklearn.cluster import KMeans
from scipy.ndimage import binary_fill_holes

import torch
# torchvision is no longer needed for segmentation (YOLO replaces DeepLab).
# Kept only in case other system components use it; safe to remove if not.
# from torchvision import transforms
# from torchvision.models.segmentation import deeplabv3_resnet101

# ultralytics (YOLOv8) is imported lazily inside
# ClothingSegmenter._load_model() so the rest of the system loads even if
# the package is not installed in the current environment.

warnings.filterwarnings("ignore")


# =============================================================================
# MODULE 0 — SKIN DETECTOR  (NEW IN v2)
# =============================================================================

class SkinDetector:
    """
    Robust multi-cue HSV skin detector covering a wide range of ethnicities.

    Strategy (Kakumanu et al., 2007):
    ──────────────────────────────────
    Three independent HSV ranges are OR-combined to catch very light,
    medium, and dark skin tones.  An additional YCrCb range is used as
    a fourth vote for extra coverage in tricky lighting.

    A pixel is labelled "skin" only when at LEAST ONE range fires AND
    the pixel is not a near-achromatic grey (which would be clothing,
    not skin).

    The returned mask is used to EXCLUDE those pixels from color
    extraction — they are NEVER part of clothing color computation.
    """

    # HSV ranges: (H_lo, H_hi, S_lo, S_hi, V_lo, V_hi)
    # All values in OpenCV scale: H 0-180, S/V 0-255
    _HSV_RANGES = [
        # Light skin (Fitzpatrick I-II)
        ( 0,  20,  25, 160, 130, 255),
        # Medium skin (Fitzpatrick III-IV)
        ( 0,  18,  40, 180,  80, 230),
        # Warm/dark skin (Fitzpatrick V-VI)
        ( 5,  22,  25, 140,  50, 175),
        # Reddish / tanned
        (160, 180,  20, 160, 100, 255),
    ]

    # YCrCb range (Phung et al., 2005)
    _YCRCB_CR_LO, _YCRCB_CR_HI = 133, 173
    _YCRCB_CB_LO, _YCRCB_CB_HI = 77,  127

    # Minimum area of a skin blob to keep (avoids small patches in fabric)
    _MIN_BLOB_PX = 300

    def detect(self, image_rgb: np.ndarray) -> np.ndarray:
        """
        Args:
            image_rgb: H×W×3 uint8 RGB array.
        Returns:
            H×W uint8 binary mask — 1 = skin pixel to EXCLUDE.
        """
        bgr   = cv2.cvtColor(image_rgb, cv2.COLOR_RGB2BGR)
        hsv   = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
        ycrcb = cv2.cvtColor(bgr, cv2.COLOR_BGR2YCrCb)

        # ── Vote 1–4: HSV ranges ──────────────────────────────────────────────
        hsv_mask = np.zeros(image_rgb.shape[:2], dtype=np.uint8)
        for h_lo, h_hi, s_lo, s_hi, v_lo, v_hi in self._HSV_RANGES:
            lo = np.array([h_lo, s_lo, v_lo], dtype=np.uint8)
            hi = np.array([h_hi, s_hi, v_hi], dtype=np.uint8)
            hsv_mask |= cv2.inRange(hsv, lo, hi)

        # ── Vote 5: YCrCb ─────────────────────────────────────────────────────
        cr = ycrcb[:, :, 1].astype(np.int32)
        cb = ycrcb[:, :, 2].astype(np.int32)
        ycrcb_mask = (
            (cr >= self._YCRCB_CR_LO) & (cr <= self._YCRCB_CR_HI) &
            (cb >= self._YCRCB_CB_LO) & (cb <= self._YCRCB_CB_HI)
        ).astype(np.uint8) * 255

        # ── Combine: HSV AND YCrCb (intersection = higher precision) ─────────
        combined = cv2.bitwise_and(hsv_mask, ycrcb_mask)

        # ── Remove near-achromatic pixels (they're clothes, not skin) ─────────
        s_channel = hsv[:, :, 1]
        combined[s_channel < 20] = 0    # very low saturation → not skin

        # ── Morphological refinement ──────────────────────────────────────────
        k3 = np.ones((3, 3), np.uint8)
        k5 = np.ones((5, 5), np.uint8)
        combined = cv2.morphologyEx(combined, cv2.MORPH_OPEN,  k3, iterations=1)
        combined = cv2.morphologyEx(combined, cv2.MORPH_CLOSE, k5, iterations=2)
        combined = cv2.morphologyEx(combined, cv2.MORPH_DILATE, k3, iterations=1)

        # ── Remove tiny blobs (noise in fabric) ───────────────────────────────
        num_labels, labels, stats, _ = cv2.connectedComponentsWithStats(combined)
        clean = np.zeros_like(combined)
        for i in range(1, num_labels):
            if stats[i, cv2.CC_STAT_AREA] >= self._MIN_BLOB_PX:
                clean[labels == i] = 1

        return clean.astype(np.uint8)


# =============================================================================
# MODULE 0b — PIXEL FILTER  (NEW IN v2)
# =============================================================================

class PixelFilter:
    """
    Remove physically unreliable pixels from a clothing mask before
    color extraction.

    Two classes of invalid pixels:
    ─────────────────────────────
    Shadows     : V < shadow_v_thresh in HSV space.
                  These are underexposed regions where the sensor
                  doesn't capture accurate color information.

    Highlights  : L > highlight_l_thresh in LAB space (converted via
                  HSV shortcut for speed).  Specular reflections from
                  shiny fabrics or strong lighting wash out color.

    Both are masked out BEFORE KMeans, so they can never bias the
    dominant color toward black or blown-out white.
    """

    def __init__(
        self,
        shadow_v_thresh:    int = 22,    # HSV V below this = shadow (very dark)
        highlight_v_thresh: int = 238,   # HSV V above this = specular highlight
    ):
        self.shadow_v    = shadow_v_thresh
        self.highlight_v = highlight_v_thresh
        # NOTE: We intentionally do NOT filter on low saturation.
        # A grey shirt (S=0) is perfectly valid clothing — do not exclude it.

    def filter_mask(self, image_rgb: np.ndarray,
                    mask: np.ndarray) -> np.ndarray:
        """
        Returns a cleaned binary mask with shadow and highlight pixels removed.

        Args:
            image_rgb: H×W×3 uint8 RGB.
            mask:      H×W uint8 binary mask (1 = region of interest).
        Returns:
            Cleaned H×W uint8 mask.
        """
        bgr = cv2.cvtColor(image_rgb, cv2.COLOR_RGB2BGR)
        hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
        v   = hsv[:, :, 2]

        shadow_px    = v < self.shadow_v
        highlight_px = v > self.highlight_v

        bad_px = (shadow_px | highlight_px).astype(np.uint8)
        return (mask.astype(bool) & ~bad_px.astype(bool)).astype(np.uint8)


# =============================================================================
# MODULE 1 — CLOTHING SEGMENTER  (v4.0: YOLOv8 Instance Segmentation)
# =============================================================================

class ClothingSegmenter:
    """
    Per-garment instance segmentation using YOLOv8-seg + DeepFashion2 weights.

    Why YOLO replaces DeepLab
    ─────────────────────────
    DeepLab (v2/v3) produced ONE semantic "person" mask, then sliced it into
    height zones and tried to split the torso with KMeans.  This caused:

      • Zone cuts at hard-coded height fractions → wrong with sitting poses
      • KMeans torso split → failed when jacket and shirt had similar hues
      • Background colour bled into the silhouette → wrong dominant colours

    YOLOv8-seg + DeepFashion2 produces:

      • One binary mask per garment instance
      • Each detection carries a semantic label (outwear / top / trousers / …)
      • No zone maths needed — YOLO knows which garment is which
      • Masks go through a 7-step quality pipeline before any colour is sampled

    Output contract (identical to v2/v3 — no downstream changes needed):
        {
          "person_mask":    H×W uint8  (union of all cleaned garment masks)
          "clothing_items": {name: H×W uint8}
          "skin_mask":      H×W uint8  (passed through from SkinDetector)
        }

    Category name mapping (same keys as old zone names):
        torso        — standalone top (no outwear present)
        torso_upper  — outwear / jacket (when layering is detected)
        torso_lower  — inner shirt (visible under outwear)
        lower        — trousers, shorts, skirt
        full_outfit  — dress (replaces torso + lower)

    Note: DeepFashion2 has no shoe/feet class.  The "feet" key is never
    produced; recommendations about shoes will not appear.
    See FUTURE_WORK section below for a planned fallback.
    """

    # ── DeepFashion2 class index → (system_category, display_name) ─────────────
    #
    # Source: https://github.com/switchablenorms/DeepFashion2 (13 categories)
    # Verified against Bingsu/adetailer model's names dict.
    #
    # System categories: torso | torso_upper | lower | full_outfit
    # (torso_lower is derived, not directly from YOLO — see _build_clothing_items)
    _DF2_CLASS_MAP: dict = {
        0:  ("torso",       "short sleeve top"),
        1:  ("torso",       "long sleeve top"),
        2:  ("torso_upper", "short sleeve outwear"),
        3:  ("torso_upper", "long sleeve outwear"),
        4:  ("torso",       "vest"),
        5:  ("torso",       "sling"),
        6:  ("lower",       "shorts"),
        7:  ("lower",       "trousers"),
        8:  ("lower",       "skirt"),
        9:  ("full_outfit", "short sleeve dress"),
        10: ("full_outfit", "long sleeve dress"),
        11: ("full_outfit", "vest dress"),
        12: ("full_outfit", "sling dress"),
    }

    # ── Confidence thresholds ────────────────────────────────────────────────
    _CONF_THRESH   = 0.35   # below → skip detection entirely
    _CONF_HIGH     = 0.60   # above → high-confidence detection

    # ── Area filtering ───────────────────────────────────────────────────────
    _MIN_AREA_FRAC = 0.01   # garment must cover ≥ 1 % of image pixels
    _MIN_AREA_PX   = 500    # absolute floor regardless of image size

    # ── Mask cleaning kernel sizes ───────────────────────────────────────────
    _CLOSE_K       = 7      # morphological close: fill small holes
    _OPEN_K        = 3      # morphological open: remove isolated noise
    _BOUNDARY_ERODE = 2     # strip N px from garment edge to remove bg bleed
    _MIN_BLOB_PX   = 400    # minimum connected-component size after cleaning

    def __init__(
        self,
        model_path:   str   = None,
        device:       str   = None,
        conf_thresh:  float = None,
        verbose:      bool  = True,
    ):
        """
        Args:
            model_path:  Path to OutfitHarmony_HF_SafeRebuild_v1.pt.
                         Must be provided or present in working directory.
            device:      "cuda" or "cpu".  Auto-detected if None.
            conf_thresh: Detection confidence threshold (default 0.35).
            verbose:     Whether to print debug information.
        """
        self.device      = device or ("cuda" if torch.cuda.is_available() else "cpu")
        self.conf_thresh = conf_thresh if conf_thresh is not None else self._CONF_THRESH
        self._verbose    = verbose
        if self._verbose:
            print(f"[Segmenter] Device: {self.device}")
        self._load_model(model_path)

    # ── Model loading ─────────────────────────────────────────────────────────

    _DEFAULT_MODEL = "OutfitHarmony_HF_SafeRebuild_v1.pt"

    def _load_model(self, model_path: str = None) -> None:
        """
        Load YOLOv8-seg from a local model file.

        Raises FileNotFoundError if the model file does not exist.
        Lazy-imports ultralytics so the rest of the system can be imported
        even when ultralytics is not installed.
        """
        try:
            from ultralytics import YOLO
        except ImportError:
            raise ImportError(
                "ultralytics is required for segmentation.\n"
                "Install with:  pip install ultralytics"
            )

        if model_path is None:
            model_path = self._DEFAULT_MODEL

        model_file = Path(model_path)
        if not model_file.exists():
            raise FileNotFoundError(
                f"Segmentation model not found: {model_file.resolve()}\n"
                f"Place '{self._DEFAULT_MODEL}' in the working directory "
                f"or pass model_path= explicitly to the constructor."
            )

        if self._verbose:
            print(f"[Segmenter] Loading {model_file.name} …")
        self.model = YOLO(str(model_path))
        self.model.to(self.device)

        # Verify class names match our mapping
        names = getattr(self.model, "names", {})
        self._verify_class_names(names)
        if self._verbose:
            print(f"[Segmenter] Model ready  ({len(names)} classes).")

    def _verify_class_names(self, model_names: dict) -> None:
        """
        Cross-check model class names against our DF2 mapping.
        Logs a warning if names differ (different model variant loaded).
        """
        expected = {
            0: "short sleeve top",   1: "long sleeve top",
            2: "short sleeve outwear", 3: "long sleeve outwear",
            4: "vest",               5: "sling",
            6: "shorts",             7: "trousers",
            8: "skirt",              9: "short sleeve dress",
            10: "long sleeve dress", 11: "vest dress",
            12: "sling dress",
        }
        mismatches = []
        for idx, exp_name in expected.items():
            got = model_names.get(idx, "")
            if got.lower().strip() != exp_name.lower().strip():
                mismatches.append(f"  class {idx}: expected '{exp_name}', got '{got}'")
        if mismatches:
            if self._verbose:
                print("[Segmenter] WARNING — class name mismatches detected:")
                for m in mismatches:
                    print(m)
                print("[Segmenter] Proceeding with index-based mapping.")

    # ── Public API ────────────────────────────────────────────────────────────

    def segment(self, image_rgb: np.ndarray,
                skin_mask: np.ndarray = None) -> dict:
        """
        Run instance segmentation and return cleaned per-garment masks.

        Args:
            image_rgb:  H×W×3 uint8 RGB array.
            skin_mask:  Pre-computed skin mask (1 = skin pixel to exclude).
                        Computed fresh here if None.
        Returns:
            {
              "person_mask":    H×W uint8  (union of all garment masks)
              "clothing_items": {str: H×W uint8}
              "skin_mask":      H×W uint8
            }
        """
        H, W = image_rgb.shape[:2]
        if skin_mask is None:
            skin_mask = np.zeros((H, W), dtype=np.uint8)

        # ── Step 1: YOLO inference ─────────────────────────────────────────
        if self._verbose:
            print("[Segmenter] Running YOLOv8-seg inference …")
        raw_dets = self._run_inference(image_rgb, H, W)
        if self._verbose:
            print(f"[Segmenter] Raw detections: {len(raw_dets)}")

        # ── Step 2: Confidence + area filter ──────────────────────────────
        dets = self._filter_detections(raw_dets, H * W)
        if self._verbose:
            print(f"[Segmenter] After filtering: {len(dets)}")

        if not dets:
            if self._verbose:
                print("[Segmenter] ⚠  No clothing detected — returning empty result.")
            return {
                "person_mask":    np.zeros((H, W), dtype=np.uint8),
                "clothing_items": {},
                "skin_mask":      skin_mask,
            }

        # ── Step 3: Per-mask quality pipeline ─────────────────────────────
        for det in dets:
            det["mask"] = self._clean_mask(det["mask"])

        # ── Step 4: Adaptive skin removal ─────────────────────────────────
        for det in dets:
            det["mask"] = self._remove_skin(det["mask"], skin_mask)

        # ── Step 5: Build named category dict + layering logic ────────────
        clothing_items = self._build_clothing_items(dets, H, W)

        # ── Step 6: Build person mask (union of all garment masks) ────────
        person_mask = np.zeros((H, W), dtype=np.uint8)
        for mask in clothing_items.values():
            person_mask |= mask.astype(np.uint8)

        if self._verbose:
            print(f"[Segmenter] Clothing items: {list(clothing_items.keys())}")
            print(f"[Segmenter] Person coverage: {person_mask.mean()*100:.1f} %")

        return {
            "person_mask":    person_mask,
            "clothing_items": clothing_items,
            "skin_mask":      skin_mask,
        }

    # ── Step 1: Inference ─────────────────────────────────────────────────────

    def _run_inference(self, image_rgb: np.ndarray,
                       H: int, W: int) -> list:
        """
        Run the YOLO model and parse raw detections.

        Each detection dict:
          class_id  int      DeepFashion2 class index (0-12)
          label     str      human-readable garment name
          category  str      system category (torso / torso_upper / lower / full_outfit)
          conf      float    detection confidence
          mask      H×W u8   binary instance mask at original image resolution
        """
        # YOLO expects BGR — the rest of our pipeline uses RGB
        bgr  = cv2.cvtColor(image_rgb, cv2.COLOR_RGB2BGR)
        res  = self.model(bgr, verbose=False)[0]

        if res.masks is None:
            return []

        # masks.data: (N, Hm, Wm) float32 tensor (may be model output size)
        masks_t = res.masks.data
        if isinstance(masks_t, torch.Tensor):
            masks_np = masks_t.cpu().numpy()          # (N, Hm, Wm)
        else:
            masks_np = np.asarray(masks_t)

        confs    = res.boxes.conf.cpu().numpy()        # (N,)
        classes  = res.boxes.cls.cpu().numpy().astype(int)  # (N,)

        dets = []
        for i in range(len(masks_np)):
            cls_id = int(classes[i])
            if cls_id not in self._DF2_CLASS_MAP:
                continue                               # unknown class — skip

            category, label = self._DF2_CLASS_MAP[cls_id]
            conf            = float(confs[i])

            # Resize mask to original image dimensions if needed
            raw_mask = (masks_np[i] > 0.5).astype(np.uint8)
            if raw_mask.shape != (H, W):
                raw_mask = cv2.resize(
                    raw_mask, (W, H), interpolation=cv2.INTER_NEAREST
                )

            dets.append({
                "class_id": cls_id,
                "label":    label,
                "category": category,
                "conf":     conf,
                "mask":     raw_mask,
            })

        return dets

    # ── Step 2: Filtering ─────────────────────────────────────────────────────

    def _filter_detections(self, dets: list, total_px: int) -> list:
        """
        Drop detections that are:
          a) below the confidence threshold, OR
          b) too small (< 1 % of image or < 500 px absolute)
        """
        min_px  = max(self._MIN_AREA_PX, int(total_px * self._MIN_AREA_FRAC))
        kept    = []
        for det in dets:
            if det["conf"] < self.conf_thresh:
                if self._verbose:
                    print(f"   [Filter] ✗ {det['label']}  conf={det['conf']:.2f} < {self.conf_thresh}")
                continue
            area = int(det["mask"].sum())
            if area < min_px:
                if self._verbose:
                    print(f"   [Filter] ✗ {det['label']}  area={area} px < {min_px}")
                continue
            if self._verbose:
                print(f"   [Filter] ✓ {det['label']:<26}  conf={det['conf']:.2f}  "
                      f"area={area:,} px  cat={det['category']}")
            kept.append(det)
        return kept

    # ── Step 3: Mask cleaning ─────────────────────────────────────────────────

    def _clean_mask(self, mask: np.ndarray) -> np.ndarray:
        """
        Seven-step quality pipeline for a single raw YOLO instance mask.

        Why each step is needed
        ───────────────────────
        YOLO's segmentation head runs at a reduced resolution (e.g. 160×160)
        and upscales masks with bilinear interpolation.  This leaves:
          • Small gaps inside the garment (holes)           → close
          • Stray pixels at object edges                    → open
          • Remaining interior voids after open             → fill_holes
          • Background-coloured fringe at garment boundary  → erode
          • Disconnected noise blobs                        → component filter
        """
        # 1. Close — fill small holes inside garment silhouette
        k_close = np.ones((self._CLOSE_K, self._CLOSE_K), np.uint8)
        mask    = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, k_close, iterations=2)

        # 2. Open — remove isolated noise pixels at boundaries
        k_open  = np.ones((self._OPEN_K,  self._OPEN_K),  np.uint8)
        mask    = cv2.morphologyEx(mask, cv2.MORPH_OPEN,  k_open,  iterations=1)

        # 3. Fill remaining interior holes (handles complex concavities)
        mask    = binary_fill_holes(mask.astype(bool)).astype(np.uint8)

        # 4. Boundary erosion — strip the outermost pixels where YOLO's
        #    upsampled boundary prediction is least reliable.
        #    This is the same strategy used in the old DeepLab segmenter.
        e       = self._BOUNDARY_ERODE
        k_erode = np.ones((e * 2 + 1, e * 2 + 1), np.uint8)
        mask    = cv2.morphologyEx(mask, cv2.MORPH_ERODE, k_erode, iterations=1)

        # 5. Connected-component filter — keep only significant blobs
        mask    = self._keep_large_components(mask, self._MIN_BLOB_PX)

        return mask

    @staticmethod
    def _keep_large_components(mask: np.ndarray, min_px: int) -> np.ndarray:
        """
        Remove connected components smaller than min_px pixels.
        If all components are removed (edge case), keep the largest one.
        """
        num, labels, stats, _ = cv2.connectedComponentsWithStats(
            mask.astype(np.uint8)
        )
        clean = np.zeros_like(mask, dtype=np.uint8)
        for i in range(1, num):
            if stats[i, cv2.CC_STAT_AREA] >= min_px:
                clean[labels == i] = 1

        # Safety: if everything was removed, keep the largest blob
        if clean.sum() == 0 and num > 1:
            largest = 1 + int(np.argmax(stats[1:, cv2.CC_STAT_AREA]))
            clean[labels == largest] = 1

        return clean

    # ── Step 4: Skin removal ──────────────────────────────────────────────────

    @staticmethod
    def _remove_skin(mask: np.ndarray, skin_mask: np.ndarray) -> np.ndarray:
        """
        Remove skin pixels from a clothing mask using the same adaptive
        three-tier strategy as ColorExtractor (v2) for consistency.

        Tier 1 — skin_ratio > 0.30 : full removal
          The garment zone is dominated by skin (e.g. sleeveless top with
          many exposed arm pixels captured in the bounding box).

        Tier 2 — skin_ratio 0.15–0.30 : erode-first removal
          Moderate overlap.  Erode the skin mask before subtracting so
          that valid clothing pixels near the skin boundary are preserved.

        Tier 3 — skin_ratio ≤ 0.15 : skip
          Negligible skin overlap — touching the mask would only remove
          valid clothing pixels.
        """
        if skin_mask is None or int(skin_mask.sum()) == 0:
            return mask

        item_px    = max(int(mask.sum()), 1)
        overlap    = int((mask.astype(bool) & skin_mask.astype(bool)).sum())
        skin_ratio = overlap / item_px

        result = mask.copy()
        if skin_ratio > 0.30:
            result[skin_mask.astype(bool)] = 0
        elif skin_ratio > 0.15:
            k_erode = np.ones((5, 5), np.uint8)
            eroded  = cv2.erode(
                (skin_mask * 255).astype(np.uint8), k_erode, iterations=1
            )
            result[eroded > 0] = 0
        # else: skip — minimal overlap

        return result

    # ── Step 5: Category building + layering ──────────────────────────────────

    def _build_clothing_items(self, dets: list, H: int, W: int) -> dict:
        """
        Merge per-instance detections into the system's named category dict.

        Merge strategy
        ──────────────
        Same category, multiple detections → union of masks.
        This handles e.g. two overlapping trousers bounding boxes.

        Layering logic
        ──────────────
        When BOTH an outwear (torso_upper) AND a top (torso) are detected:

          • Rename 'torso'       → 'torso_lower'  (the inner shirt/sweater)
          • Keep  'torso_upper'  as-is            (the outwear/jacket)

        Then SUBTRACT the outwear mask from the inner-shirt mask:

          torso_lower -= torso_upper  (clamp to 0)

        This is critical for colour accuracy: without subtraction the
        inner-shirt colour extractor samples pixels that are actually
        covered by the jacket, producing a wrong average colour.

        Validation
        ──────────
        Categories with too few pixels after all processing are dropped.
        """
        # ── 5a: group by category and merge masks (union) ──────────────────
        groups: dict[str, np.ndarray] = {}
        for det in dets:
            cat  = det["category"]
            if cat not in groups:
                groups[cat] = np.zeros((H, W), dtype=np.uint8)
            groups[cat] = np.clip(
                groups[cat].astype(np.int16) + det["mask"].astype(np.int16),
                0, 1
            ).astype(np.uint8)

        # ── 5b: layering detection ─────────────────────────────────────────
        if "torso_upper" in groups and "torso" in groups:
            # Rename torso → torso_lower
            groups["torso_lower"] = groups.pop("torso")
            # Subtract jacket pixels from inner-shirt mask
            # (prevents counting jacket-covered area as shirt colour)
            inner  = groups["torso_lower"].astype(np.int16)
            jacket = groups["torso_upper"].astype(np.int16)
            groups["torso_lower"] = np.clip(inner - jacket, 0, 1).astype(np.uint8)
            if self._verbose:
                print("[Segmenter] Layering detected: jacket over inner shirt "
                      "→ jacket pixels removed from shirt mask.")

        # ── 5c: validate pixel count ───────────────────────────────────────
        final: dict[str, np.ndarray] = {}
        for cat, mask in groups.items():
            px = int(mask.sum())
            if px >= self._MIN_AREA_PX:
                final[cat] = mask
            else:
                if self._verbose:
                    print(f"[Segmenter] Dropped '{cat}' after merge ({px} px < "
                          f"{self._MIN_AREA_PX})")

        return final

    # ── Utility (retained from v3 for backward compat with any callers) ───────

    @staticmethod
    def _largest_component(mask: np.ndarray) -> np.ndarray:
        """Keep only the single largest connected region."""
        num, labels, stats, _ = cv2.connectedComponentsWithStats(
            mask.astype(np.uint8))
        if num < 2:
            return mask
        largest = 1 + int(np.argmax(stats[1:, cv2.CC_STAT_AREA]))
        return (labels == largest).astype(np.uint8)

    # ──────────────────────────────────────────────────────────────────────────
    # FUTURE WORK
    # ──────────────────────────────────────────────────────────────────────────
    # 1. Shoe detection:
    #    DeepFashion2 has no "shoes" class.  A planned workaround is to run a
    #    second lightweight COCO-trained detector (person keypoint → feet bbox)
    #    or a dedicated shoe detector, then extract the feet zone from the lower
    #    third of the bounding box.
    #
    # 2. Multi-person images:
    #    If multiple people are visible, YOLO will detect garments from all of
    #    them.  A person-clustering step (group detections by overlapping bboxes)
    #    is needed to isolate the target subject.
    #
    # 3. Confidence calibration:
    #    The 0.35 default threshold was chosen conservatively.  Users with a
    #    challenging image domain (outdoor photos, low-res) may benefit from
    #    lowering it to 0.25; studio photos may raise it to 0.50.
    # ──────────────────────────────────────────────────────────────────────────


# =============================================================================
# MODULE 1b — SEGMENTATION COVERAGE ASSESSOR  (NEW in v5.0)
# =============================================================================

class SegmentationCoverageAssessor:
    """
    Evaluates how completely YOLO detected the outfit BEFORE scoring begins.

    Why this is necessary
    ─────────────────────
    YOLO is not perfect.  In real images with occlusion, unusual poses, or
    low-contrast garments, it may miss one or more layers.  The v4.1 system
    had no way to distinguish:

      • A 2-item outfit that is intentionally minimal (top + skirt)
      • A 3-item outfit where YOLO only detected jacket + pants (missed shirt)

    Both looked identical to the scoring system: 2 clothing_items.  The score
    was equally confident in both cases, which is wrong.

    This module answers: "Given what YOLO returned, how confident are we that
    we saw the complete outfit?"

    It cannot know the ground truth (there is no ground truth at inference time),
    but it can detect structural signals that suggest partial detection:

      Signal 1 — Coverage ratio: person_mask / image_area.
        If YOLO's garment masks cover < 40% of the person bounding box, it is
        likely that some garments were missed.

      Signal 2 — Missing inner layer: torso_upper detected, torso_lower absent.
        A jacket/outwear is almost never worn without something underneath.
        If we detect the outwear but no inner shirt, the inner shirt was missed.

      Signal 3 — Missing lower body: torso detected, lower absent.
        Unless the image is a torso-only crop, missing lower-body suggests
        incomplete detection.  (Exception: full_outfit — a dress covers both.)

    Output — CoverageReport (dict):
      is_partial:     bool    — True when any signal fires
      confidence:     float   — 0.0–1.0 (fed into calibrator as extra penalty)
      flags:          [str]   — human-readable warning strings for the output
      n_detected:     int     — number of clothing_items found
      detected_cats:  [str]   — list of detected category names
      missing_signals:[str]   — which signals fired
    """

    # ── Thresholds ────────────────────────────────────────────────────────────
    # Coverage ratio: garment pixels / person-bounding-box pixels
    _MIN_COVERAGE_RATIO  = 0.40   # below → likely partial detection

    # Minimum items expected when outwear is detected (outwear + inner + lower)
    _MIN_ITEMS_LAYERED   = 2      # at least outwear + one more

    def assess(self, clothing_items: dict,
               person_mask: np.ndarray = None) -> dict:
        """
        Assess coverage completeness of detected clothing items.

        Args:
            clothing_items:  Dict {name: H×W mask} from ClothingSegmenter.
            person_mask:     H×W binary person mask (union of all garments).
                             If None, coverage ratio check is skipped.
        Returns:
            CoverageReport dict (see class docstring).
        """
        detected_cats   = list(clothing_items.keys())
        n_detected      = len(detected_cats)
        signals         = []
        flags           = []

        # ── Signal 1: Coverage ratio ──────────────────────────────────────────
        coverage_ratio  = 1.0   # default: full confidence if no person mask
        if person_mask is not None and person_mask.size > 0:
            garment_px  = sum(int(m.sum()) for m in clothing_items.values())
            person_px   = max(int(person_mask.sum()), 1)
            coverage_ratio = garment_px / person_px
            if coverage_ratio < self._MIN_COVERAGE_RATIO:
                signals.append("low_coverage")
                flags.append(
                    f"Low garment coverage ({coverage_ratio*100:.0f}% of person) — "
                    "some garments may not have been detected."
                )

        # ── Signal 2: Missing inner layer ────────────────────────────────────
        has_outwear  = "torso_upper" in detected_cats
        has_inner    = "torso_lower" in detected_cats or "torso" in detected_cats
        if has_outwear and not has_inner:
            signals.append("missing_inner_layer")
            flags.append(
                "Jacket/outwear detected but no inner shirt found — "
                "the inner layer may have been missed by segmentation."
            )

        # ── Signal 3: Missing lower body ─────────────────────────────────────
        has_lower       = "lower" in detected_cats
        has_full        = "full_outfit" in detected_cats
        has_upper       = any(c in detected_cats for c in
                              ("torso", "torso_upper", "torso_lower"))
        if has_upper and not has_lower and not has_full:
            signals.append("missing_lower")
            flags.append(
                "Upper garment detected but no lower garment found — "
                "trousers or skirt may not appear in the image frame "
                "or were missed by segmentation."
            )

        # ── Confidence score ──────────────────────────────────────────────────
        # Start at 1.0, subtract per signal.
        # Coverage ratio also contributes proportionally.
        is_partial  = len(signals) > 0
        confidence  = 1.0
        if "low_coverage" in signals:
            # Proportional: coverage=0.40 → confidence=0.85; coverage=0 → 0.60
            confidence -= 0.15 * max(0.0, 1.0 - coverage_ratio / self._MIN_COVERAGE_RATIO)
        if "missing_inner_layer" in signals:
            confidence -= 0.12   # inner layer missed → moderate uncertainty
        if "missing_lower" in signals:
            confidence -= 0.08   # lower body missing → could be image crop

        confidence = round(max(0.40, min(1.0, confidence)), 3)

        return {
            "is_partial":      is_partial,
            "confidence":      confidence,
            "flags":           flags,
            "n_detected":      n_detected,
            "detected_cats":   detected_cats,
            "missing_signals": signals,
            "coverage_ratio":  round(coverage_ratio, 3),
        }


# =============================================================================
# MODULE 1c — OUTFIT TYPE CLASSIFIER  (NEW in v5.0)
# =============================================================================

class OutfitTypeClassifier:
    """
    Classifies the detected outfit into one of four structural types.

    Why outfit type matters
    ───────────────────────
    The existing scoring system applies identical evaluation logic regardless
    of outfit structure.  This causes systematic failures:

      • minimal (1–2 items, one colour):  gets penalised for "no neutral anchor"
        even though a simple coordinated look doesn't need one.

      • simple (2 items, clear contrast):  achromatic_anchor applies the same
        "no neutral = 0.65" penalty as a complex outfit — unfair.

      • layered (jacket over shirt):  correctly detected by YOLO but the scoring
        system may apply complexity penalties that don't apply to this style.

      • complex (3+ distinct colours):  genuinely benefits from balance checking;
        applying the same weights as a minimal outfit wastes signal.

    Outfit types
    ────────────
    minimal  — 1–2 items with ≤1 chromatic piece.
               Examples: coloured dress, black top + grey trousers.
               Evaluation focus: colour quality and intentionality.
               Achromatic anchor: optional (not penalised for absence).

    simple   — 2 items with clear hue or lightness contrast.
               Examples: cream blouse + navy skirt, white shirt + khaki chinos.
               Evaluation focus: harmony and contrast quality.
               Achromatic anchor: optional if contrast is already clear.

    layered  — jacket / outwear detected over an inner layer.
               Examples: blazer + shirt + trousers, coat + dress.
               Evaluation focus: colour balance across all visible layers.
               Achromatic anchor: inner layer often functions as the neutral.

    complex  — 3+ distinct chromatic pieces simultaneously.
               Examples: 3-colour outfit with no neutral anchor.
               Evaluation focus: balance, not over-busy, clear hierarchy.
               Achromatic anchor: strongly recommended (full penalty applies).

    Output:  str — one of "minimal" | "simple" | "layered" | "complex"
    """

    def classify(self, clothing_items: dict,
                 color_analyses: dict,
                 mono_style: dict) -> str:
        """
        Classify the outfit type from detected items + colour analyses.

        Args:
            clothing_items:  {name: mask} from segmenter.
            color_analyses:  {name: analysis_dict} from ColorConverter.
            mono_style:      Output of ColorHarmonyRules._monochrome_style().
        Returns:
            Outfit type string: "minimal" | "simple" | "layered" | "complex"
        """
        n_items      = len(clothing_items)
        n_chromatic  = mono_style.get("n_chromatic", 0)
        style        = mono_style.get("style", "varied")

        # ── Layered: outwear explicitly detected ─────────────────────────────
        if "torso_upper" in clothing_items:
            return "layered"

        # ── Minimal: 1 item, or 2 items with ≤1 chromatic AND low L_spread ────
        # Exception: if 2 items have large lightness spread (≥35), the pairing
        # IS the style — it's a simple contrast-based outfit, not truly minimal.
        # Example: navy (L≈16) + white (L≈97) → ΔL=81 → "simple", not "minimal"
        if n_items <= 1:
            return "minimal"
        if n_items == 2 and n_chromatic <= 1:
            L_spread = mono_style.get("L_spread", 0.0)
            if L_spread >= 35.0:
                # High lightness contrast — the tonal pairing IS the look
                return "simple"
            return "minimal"

        # ── Complex: 3+ chromatic items ──────────────────────────────────────
        if n_chromatic >= 3:
            return "complex"

        # ── Simple: 2 items, clear contrast (the common case) ────────────────
        if n_items == 2:
            return "simple"

        # ── 3-item with ≤2 chromatic: treat as simple ─────────────────────────
        # (e.g. top + neutral + pants where two items are achromatic)
        return "simple"

    @staticmethod
    def describe(outfit_type: str) -> str:
        """Human-readable description for the output dict."""
        return {
            "minimal": "minimal / single-statement look",
            "simple":  "simple coordinated outfit",
            "layered": "layered outfit with outwear",
            "complex": "complex multi-piece outfit",
        }.get(outfit_type, "outfit")


# =============================================================================
# MODULE 2 — DOMINANT COLOR EXTRACTOR  (v2: skin-free, shadow-free)
# =============================================================================

class ColorExtractor:
    """
    Extracts the N most dominant colours from a clothing region, after
    removing skin pixels and invalid (shadow / highlight) pixels.

    v2 Changes
    ──────────
    • Skin pixels (from SkinDetector) are excluded BEFORE clustering.
    • Shadow and highlight pixels (from PixelFilter) are excluded too.
    • n_init raised to 20 for much more stable cluster centroids.
    • max_iter raised to 500.
    • Results are sorted by cluster SIZE (pixel count), not arbitrary order.
    • A minimum proportion threshold of 8 % avoids dust clusters.
    • Data quality score is reported: how many usable pixels remained
      after skin + noise removal (as fraction of raw mask area).
    """

    def __init__(
        self,
        n_colors:        int   = 3,
        min_pixels:      int   = 60,
        min_proportion:  float = 0.08,   # ignore clusters < 8 % of region
        n_init:          int   = 20,
        max_iter:        int   = 500,
        min_clean_px:    int   = 120,    # FIX 6: below this → low_confidence=True
        verbose:         bool  = True,
    ):
        self.n_colors       = n_colors
        self.min_pixels     = min_pixels
        self.min_proportion = min_proportion
        self.n_init         = n_init
        self.max_iter       = max_iter
        self.min_clean_px   = min_clean_px   # FIX 6
        self._verbose       = verbose

        self.skin_detector = SkinDetector()
        self.pixel_filter  = PixelFilter()

    def extract(
        self,
        image_rgb: np.ndarray,
        mask:      np.ndarray,
        pre_skin_mask: np.ndarray = None,
    ) -> dict:
        """
        Extract dominant colours from a clothing item mask.

        Args:
            image_rgb:      H×W×3 uint8 RGB.
            mask:           H×W uint8 binary mask for this item.
            pre_skin_mask:  Pre-computed skin mask (computed if None).
        Returns:
            {
              "colors":   [{"rgb": [R,G,B], "proportion": float}, …],
              "quality":  float,   # 0–1: fraction of usable pixels
              "raw_px":   int,     # pixels before cleaning
              "clean_px": int,     # pixels after cleaning
            }
        """
        raw_px = int(mask.sum())

        # ── Step 1: Adaptive skin removal (FIX 2, v2.1) ──────────────────────
        # The original strategy always removed all skin pixels, which is
        # over-aggressive for sleeveless / shorts / tight outfits where skin
        # pixels legitimately overlap garment bounding boxes.
        #
        # Strategy:
        #   skin_ratio > 0.40 → full removal (skin dominates → remove all)
        #   skin_ratio > 0.20 → partial: erode skin mask 1× before subtracting
        #   skin_ratio ≤ 0.20 → skip: almost no skin, don't touch the mask
        #
        # This preserves valid clothing pixels in high-skin-exposure images.
        if pre_skin_mask is None:
            skin_mask = self.skin_detector.detect(image_rgb)
        else:
            skin_mask = pre_skin_mask

        # Count skin overlap within this specific item mask
        item_px     = max(raw_px, 1)
        skin_in_item = int((skin_mask.astype(bool) & mask.astype(bool)).sum())
        skin_ratio   = skin_in_item / item_px

        no_skin = mask.copy()
        if skin_ratio > 0.40:
            # Full removal — skin clearly dominates this zone
            no_skin[skin_mask.astype(bool)] = 0
            skin_mode = "full"
        elif skin_ratio > 0.20:
            # Partial removal — erode skin mask to keep boundary clothing pixels
            k_erode = np.ones((5, 5), np.uint8)
            eroded_skin = cv2.erode(
                (skin_mask * 255).astype(np.uint8), k_erode, iterations=1
            )
            no_skin[(eroded_skin > 0)] = 0
            skin_mode = "partial"
        else:
            # Skip — minimal skin overlap, preserve all clothing pixels
            skin_mode = "skip"

        # ── Step 2: Remove shadow / highlight pixels ──────────────────────────
        clean = self.pixel_filter.filter_mask(image_rgb, no_skin)

        clean_px = int(clean.sum())
        quality  = clean_px / max(raw_px, 1)

        # FIX 6: items with very few usable pixels are marked low-confidence.
        # Their quality weight is capped at 0.35 so they cannot dominate scoring.
        low_confidence = clean_px < self.min_clean_px
        if low_confidence:
            quality = min(quality, 0.35)

        if self._verbose:
            print(f"         raw={raw_px:,}  skin={skin_ratio:.2f}({skin_mode})"
                  f"  after_skin={int(no_skin.sum()):,}  "
                  f"clean={clean_px:,}  quality={quality:.2f}")

        # ── Step 3: Extract pixels for clustering ─────────────────────────────
        yx = np.where(clean > 0)
        pixels = image_rgb[yx[0], yx[1]].astype(float)

        if len(pixels) < self.min_pixels:
            # Fallback: use raw mask average (reported with low quality)
            yx_raw = np.where(mask > 0)
            if len(yx_raw[0]) == 0:
                return self._fallback([128, 128, 128], 0, 0, 0)
            avg = image_rgb[yx_raw[0], yx_raw[1]].mean(axis=0).clip(0,255).astype(int)
            return self._fallback(avg.tolist(), raw_px, 0, 0.0)

        # ── Step 4: KMeans clustering ─────────────────────────────────────────
        k = min(self.n_colors, max(1, len(pixels) // 25))
        km = KMeans(
            n_clusters=k,
            n_init=self.n_init,
            max_iter=self.max_iter,
            random_state=42,
            algorithm="lloyd",
        )
        labels   = km.fit_predict(pixels)
        centers  = km.cluster_centers_.clip(0, 255).astype(int)
        total    = len(labels)

        # ── Step 5: Sort by cluster size (largest = most representative) ──────
        result = []
        for i in range(k):
            cnt  = (labels == i).sum()
            prop = cnt / total
            if prop >= self.min_proportion:
                result.append({
                    "rgb":        centers[i].tolist(),
                    "proportion": round(float(prop), 4),
                    "_count":     int(cnt),
                })

        result.sort(key=lambda x: x["_count"], reverse=True)
        for r in result:
            del r["_count"]

        if not result:
            # All clusters below threshold — return the biggest anyway
            biggest = int(np.bincount(labels).argmax())
            result = [{"rgb": centers[biggest].tolist(), "proportion": 1.0}]

        return {
            "colors":          result,
            "quality":         round(quality, 4),
            "raw_px":          raw_px,
            "clean_px":        clean_px,
            "low_confidence":  low_confidence,   # FIX 6
        }

    @staticmethod
    def _fallback(rgb, raw_px, clean_px, quality):
        return {
            "colors":          [{"rgb": rgb, "proportion": 1.0}],
            "quality":         quality,
            "raw_px":          raw_px,
            "clean_px":        clean_px,
            "low_confidence":  True,   # FIX 6: fallback is always low-confidence
        }

    @staticmethod
    def primary(extraction_result: dict) -> list:
        """Return the RGB of the most dominant (largest) cluster."""
        colors = extraction_result.get("colors", [])
        return colors[0]["rgb"] if colors else [128, 128, 128]


# =============================================================================
# MODULE 3 — COLOR SPACE CONVERTER  (unchanged from v1, reproduced for clarity)
# =============================================================================

class ColorConverter:
    """
    RGB → HSV, RGB → CIELAB, LAB → CIELCH, ΔE*ab — all from first principles.
    See v1 for full derivation notes.
    """

    _D65          = (0.95047, 1.00000, 1.08883)
    _RGB_TO_XYZ   = np.array([
        [0.4124564, 0.3575761, 0.1804375],
        [0.2126729, 0.7151522, 0.0721750],
        [0.0193339, 0.1191920, 0.9503041],
    ])

    @classmethod
    def rgb_to_hsv(cls, rgb):
        r, g, b = (c / 255.0 for c in rgb)
        h, s, v = colorsys.rgb_to_hsv(r, g, b)
        return {"hue": round(h*360, 2), "saturation": round(s,4), "value": round(v,4)}

    @classmethod
    def rgb_to_lab(cls, rgb):
        linear = []
        for c in rgb:
            cn = c / 255.0
            linear.append(cn/12.92 if cn <= 0.04045 else ((cn+0.055)/1.055)**2.4)
        xyz  = cls._RGB_TO_XYZ @ np.array(linear)
        xn, yn, zn = xyz / np.array(cls._D65)
        eps, kap = 0.008856, 903.3
        def f(t): return t**(1/3) if t > eps else (kap*t+16)/116
        fx, fy, fz = f(xn), f(yn), f(zn)
        return {"L": round(116*fy-16, 3), "a": round(500*(fx-fy), 3),
                "b": round(200*(fy-fz), 3)}

    @staticmethod
    def lab_to_lch(lab):
        C = float(np.hypot(lab["a"], lab["b"]))
        H = float(np.degrees(np.arctan2(lab["b"], lab["a"])) % 360)
        return {"L": lab["L"], "C": round(C, 3), "H": round(H, 3)}

    @staticmethod
    def delta_e(lab1, lab2):
        return float(np.sqrt(
            (lab1["L"]-lab2["L"])**2 + (lab1["a"]-lab2["a"])**2 +
            (lab1["b"]-lab2["b"])**2))

    @classmethod
    def full(cls, rgb):
        lab = cls.rgb_to_lab(rgb)
        return {"rgb": rgb, "hsv": cls.rgb_to_hsv(rgb),
                "lab": lab, "lch": cls.lab_to_lch(lab)}

    @staticmethod
    def is_achromatic(lch, threshold=15.0):
        return lch["C"] < threshold

    @staticmethod
    def hue_distance(h1, h2):
        diff = abs(h1-h2) % 360
        return min(diff, 360-diff)


# =============================================================================
# MODULE 4 — AREA CALCULATOR  (unchanged)
# =============================================================================

class AreaCalculator:
    @staticmethod
    def compute(clothing_items: dict) -> dict:
        areas = {n: {"pixel_count": int(m.sum())} for n, m in clothing_items.items()}
        total = sum(d["pixel_count"] for d in areas.values()) or 1
        for d in areas.values():
            d["ratio"] = round(d["pixel_count"] / total, 6)
        return areas


# =============================================================================
# MODULE 5 — HARMONY RULES  (v2: quality-aware, calibrated)
# =============================================================================

class ColorHarmonyRules:
    """
    Five independent colour harmony rules.

    v2.1 Changes (FIX 7)
    ─────────────────────
    • Monochrome / low-variance detection: when all items share a tight
      hue range (std < 25°) the outfit is intentionally cohesive.
      In that case:
        – hue_harmony receives a "monochrome bonus" (0.80–0.92 base)
        – contrast_harmony weight is reduced internally via a per-call
          multiplier, preventing ΔE-based penalties on intentional unity.
      This correctly models the fashion principle: monochrome ≠ bad contrast;
      monochrome = controlled harmony.
    """

    conv = ColorConverter()

    # ── Per-rule hard cap (v4.1) ──────────────────────────────────────────────
    #
    # WHY THIS CHANGED: 0.95 → 0.88
    # ─────────────────────────────
    # Under DeepLab segmentation, rules were evaluated on noisy colors
    # contaminated by background bleed and skin leakage.  That noise acted
    # as a natural ceiling — rules rarely reached 0.90 in practice because
    # the input data was impure.
    #
    # YOLO-seg produces semantically clean, per-garment masks.  With pure
    # inputs, rules now legitimately reach 0.92–0.95 for ordinary well-dressed
    # people.  The cap must reflect what a real stylist would score a single
    # harmony dimension: no real outfit is "95% perfect" on hue harmony or
    # contrast — there is always some imperfection or personal taste that
    # reduces the assessment.
    #
    # 0.88 maps to: "this dimension is executed very well, with room for
    # refinement."  0.95 mapped to: "near-perfect," which is too generous
    # for a subjective, real-world system.
    #
    # Effect on max achievable raw score (all 5 rules at ceiling):
    #   Before: 5 × 0.95 → raw_pct = 95.0
    #   After:  5 × 0.88 → raw_pct = 88.0
    #
    _MAX_RAW = 0.88   # v4.1: was 0.95 — see reasoning above

    def _cap(self, score: float) -> float:
        return min(float(score), self._MAX_RAW)

    # ── v7.0 Perception Helpers ───────────────────────────────────────────────
    #
    # Three helpers that implement the v7.0 perceptual improvements.
    # All are stateless and operate on the same data structures already used
    # by the rule methods.  No pipeline changes required.

    @staticmethod
    def _visual_weights(analyses: list, area_ratios: list) -> list:
        """
        FIX 3 — Visual weight: area × (1 + chroma_norm).

        Problem: area-only weighting treats a large grey trouser as equally
        dominant to a large crimson jacket.  The eye is drawn to chroma, not
        just size.  A small but vivid item commands visual attention; a large
        muted item recedes.

        Formula:
            chroma_norm = min(C* / 85.0, 1.0)
            visual_weight = area_ratio × (1 + chroma_norm)

        The +1 term ensures achromatic items (C*=0) still contribute their
        area weight — they're not invisible, just not amplified.

        Weights are normalised to sum to 1 so they remain a valid weighting
        vector for np.average().

        Effect examples:
            vivid red top   (C*=75): area=0.30 → vw = 0.30 × (1+0.88) = 0.564
            grey trousers  (C*= 8): area=0.55 → vw = 0.55 × (1+0.09) = 0.600
            ↑ The grey is still heavier because it's much larger; the red
              closes the gap significantly despite being smaller.

            black jeans     (C*= 3): area=0.45 → vw = 0.45 × (1+0.04) = 0.468
            hot-pink top  (C*=80): area=0.30 → vw = 0.30 × (1+0.94) = 0.582
            ↑ Now the vivid pink outweighs the larger black item — correct.
        """
        raw = []
        for a, ar in zip(analyses, area_ratios):
            chroma_norm = min(a["lch"]["C"] / 85.0, 1.0)
            raw.append(ar * (1.0 + chroma_norm))
        total = sum(raw) or 1.0
        return [v / total for v in raw]

    @staticmethod
    def _hero_index(analyses: list, area_ratios: list) -> int:
        """
        FIX 2 — Hero item: the item with the highest visual impact.

        Hero = the single garment the eye is most drawn to.
        Visual impact = area × (1 + chroma_norm)   (same formula as _visual_weights)

        Why chroma matters here: a vivid small item can be the clear focal
        point of an outfit even when it covers less area than a muted anchor
        piece.  A bright red scarf at 12% area has higher visual impact than
        a beige coat at 45% area.

        Returns the index (into analyses / area_ratios) of the hero item.
        """
        best_idx    = 0
        best_impact = -1.0
        for idx, (a, ar) in enumerate(zip(analyses, area_ratios)):
            chroma_norm = min(a["lch"]["C"] / 85.0, 1.0)
            impact      = ar * (1.0 + chroma_norm)
            if impact > best_impact:
                best_impact = impact
                best_idx    = idx
        return best_idx

    @staticmethod
    def _blend_toward_max(pair_scores: list, pair_weights: list,
                          alpha: float = 0.35) -> float:
        """
        FIX 1 (upward direction) — for contrast and lightness rules.

        Problem: pure weighted-average dilutes the signal from a single
        outstanding pair.  If 3 pairs are moderate but 1 pair has excellent
        visual contrast, the average drags that signal down to mediocre.
        Human perception does not average — one strong contrast pair makes
        the outfit feel dynamic.

        Formula:
            blended = α × max(pair_scores) + (1-α) × weighted_average

        α = 0.35: the max contributes 35% weight.  This is enough to rescue
        a score when one pair is excellent (rescues ≈ 5–8 pts in practice on
        a 3-pair outfit) without making single-pair outfits unrealistically
        dominant.

        α is intentionally not tunable from outside to keep the API clean.
        If ground truth data later suggests a different value, change it here.
        """
        if not pair_scores:
            return 0.70
        max_s  = float(max(pair_scores))
        w_avg  = float(np.average(pair_scores, weights=np.array(pair_weights) + 1e-9))
        return alpha * max_s + (1.0 - alpha) * w_avg

    @staticmethod
    def _blend_toward_min(pair_scores: list, pair_weights: list,
                          beta: float = 0.30) -> float:
        """
        FIX 1 (downward direction) — for hue harmony rule only.

        Problem: one strongly-clashing pair gets averaged away when all other
        pairs are harmonious.  But a single badly-clashing pair is enough to
        make an outfit look wrong — human perception is asymmetric here.

        Formula:
            blended = β × min(pair_scores) + (1-β) × weighted_average

        β = 0.30: the worst pair contributes 30% weight.  This is gentler
        than the upward blend (0.35) because chroma_balance already partially
        captures the "too much clashing colour" signal; we don't want to
        double-penalise.
        """
        if not pair_scores:
            return 0.70
        min_s  = float(min(pair_scores))
        w_avg  = float(np.average(pair_scores, weights=np.array(pair_weights) + 1e-9))
        return beta * min_s + (1.0 - beta) * w_avg

    # ── Monochrome Detection (FIX 7) ─────────────────────────────────────────

    @staticmethod
    def _monochrome_style(analyses: list) -> dict:
        """
        Compute hue variance across items and return a style descriptor.

        v3 — SIX style classes (was four)
        ────────────────────────────────────
        monochrome           circ_std < 10°, 0 or all chromatic items match
                             — single hue, intentionally uniform
        cohesive             10–25°           — analogous / near-triadic palette
        statement_piece      EXACTLY 1 chromatic item + ≥1 neutral item
                             — classic "colour + neutrals" styling; the chromatic
                               item is a deliberate focal point, NOT a failure
                               to add accents.  Must never trigger accent recs.
        high_contrast_neutral all achromatic AND L* spread > 40
                             — dark suit + white shirt; intentional tonal contrast
        neutral_flat         all achromatic AND L* spread ≤ 40
                             — grey-on-grey; may need lightness help, not hue help
        varied               everything else  — full contrast scoring

        v3 rationale for statement_piece
        ─────────────────────────────────
        Before v3 the system classified "red top + black jacket + navy pants" as
        "monochrome" because only one chromatic hue was detected.  This caused:
          a) a "monochrome_flat" issue to fire → "add an accent colour"
          b) that recommendation directly contradicted the outfit's intent
        The statement_piece class fixes this: one colour + neutrals IS a complete,
        intentional look.  The correct advice for such outfits is "you're done",
        not "add more colour".

        Returns:
            {
              "hue_std":       float,
              "style":         str,
              "hue_bonus":     float | None,   # shortcut return for hue_harmony
              "contrast_wt":   float,          # contrast weight multiplier
              "n_chromatic":   int,            # number of chromatic items
              "n_neutral":     int,            # number of neutral/achromatic items
              "L_spread":      float,          # max - min L* across items
            }
        """
        conv = ColorConverter()
        chromatic_items = [a for a in analyses if not conv.is_achromatic(a["lch"])]
        neutral_items   = [a for a in analyses if     conv.is_achromatic(a["lch"])]

        chromatic_hues = [a["lch"]["H"] for a in chromatic_items]
        L_values       = [a["lch"]["L"] for a in analyses]
        L_spread       = max(L_values) - min(L_values) if L_values else 0.0

        n_chromatic = len(chromatic_items)
        n_neutral   = len(neutral_items)

        base_extra = {"n_chromatic": n_chromatic,
                      "n_neutral":   n_neutral,
                      "L_spread":    round(L_spread, 1)}

        # ── All-achromatic: no chromatic items at all ─────────────────────────
        if n_chromatic == 0:
            if L_spread > 40:
                # High-contrast neutrals (e.g. dark suit + white shirt) —
                # intentional and classical; must NOT be treated as monochrome.
                return {**base_extra, "hue_std": 0.0,
                        "style": "high_contrast_neutral",
                        "hue_bonus": 0.90, "contrast_wt": 1.0}
            else:
                # All-neutral, low spread (e.g. grey-on-grey) — needs lightness help
                return {**base_extra, "hue_std": 0.0,
                        "style": "neutral_flat",
                        "hue_bonus": 0.80, "contrast_wt": 0.60}

        # ── Exactly ONE chromatic item + at least one neutral ─────────────────
        # This is the "statement piece" pattern: e.g. red top + black jeans,
        # yellow dress + white blazer, cobalt jacket + grey trousers.
        # The one colour IS the outfit's personality.  Recommending "add more
        # colour" here would be actively bad advice.
        if n_chromatic == 1 and n_neutral >= 1:
            return {**base_extra, "hue_std": 0.0,
                    "style": "statement_piece",
                    "hue_bonus": 0.87,    # clean, intentional look
                    "contrast_wt": 0.85}  # contrast still matters (L*-based)

        # ── Multiple chromatic items: measure hue spread ───────────────────────
        if len(chromatic_hues) < 2:
            # Edge case: only 1 chromatic hue but no neutrals to pair with
            return {**base_extra, "hue_std": 0.0,
                    "style": "monochrome",
                    "hue_bonus": 0.88, "contrast_wt": 0.50}

        # ── Circular standard deviation of chromatic hue angles ───────────────
        angles_rad = np.deg2rad(chromatic_hues)
        mean_sin   = np.sin(angles_rad).mean()
        mean_cos   = np.cos(angles_rad).mean()
        R          = np.clip(np.hypot(mean_sin, mean_cos), 1e-9, 1.0)
        circ_std   = float(np.degrees(np.sqrt(-2 * np.log(R))))

        if circ_std < 10:
            style, hue_bonus, contrast_wt = "monochrome", 0.88, 0.40
        elif circ_std < 25:
            style, hue_bonus, contrast_wt = "cohesive",   0.84, 0.70
        else:
            style, hue_bonus, contrast_wt = "varied",     None, 1.00

        return {**base_extra,
                "hue_std":     round(circ_std, 2),
                "style":       style,
                "hue_bonus":   hue_bonus,
                "contrast_wt": contrast_wt}

    def _compute_palette_context(self, analyses, area_ratios=None):
        """Unified context signal computation for CCPA (Phase 1)."""
        if len(analyses) < 2:
            return {
                'mean_C': 0.0,
                'chroma_CV': 0.0,
                'chroma_signal': 0.0,
                'cv_signal': 0.0,
                'temperature_coherence': 0.5,
                'graduation_score': 0.0,
                'soft_strength': 0.0,
                'confused_pairs': 0,
                'strongly_confused': 0,
                'confusion_triggered': False,
                'family': 'achromatic',
                'temperature': 'neutral',
                'mean_H': 0.0,
                'outfit_gaps': {
                    'needs_dark_anchor': False,
                    'needs_light_anchor': False,
                    'needs_chromatic_accent': False,
                    'needs_neutral': False,
                    'needs_L_graduation': False,
                }
            }
        
        ars = area_ratios or [1.0] * len(analyses)
        
        # === STEP 1: Raw signal extraction ===
        chromas = [a['lch']['C'] for a in analyses]
        Ls = [a['lch']['L'] for a in analyses]
        labs = [a['lab'] for a in analyses]
        
        mean_C = float(np.mean(chromas))
        std_C = float(np.std(chromas))
        chroma_CV = std_C / (mean_C + 1e-6)
        L_range = max(Ls) - min(Ls)
        
        # === STEP 2: Temperature coherence ===
        chromatic_items = [(a, ar) for a, ar in zip(analyses, ars) if a['lch']['C'] >= 15.0]
        
        if not chromatic_items:
            temperature_coherence = 0.5
            temperature = 'neutral'
        else:
            warm_count = 0.0
            cool_count = 0.0
            for a, ar in chromatic_items:
                H = a['lch']['H']
                if (0 <= H < 90) or (330 <= H < 360):
                    warm_count += 1.0
                elif 150 <= H < 290:
                    cool_count += 1.0
                else:  # neutral zones: 90-150, 290-330
                    warm_count += 0.5
                    cool_count += 0.5
            total = warm_count + cool_count
            temperature_coherence = max(warm_count, cool_count) / total if total > 0 else 0.5
            temperature = 'warm' if warm_count >= cool_count else 'cool'
        
        # === STEP 3: Graduation score ===
        Ls_sorted = sorted(Ls)
        steps = [Ls_sorted[i+1] - Ls_sorted[i] for i in range(len(Ls_sorted)-1)]
        mean_step = np.mean(steps)
        if mean_step < 1e-6:
            raw_grad = 0.0
        else:
            cv_steps = float(np.std(steps) / mean_step)
            raw_grad = float(np.clip(1.0 - cv_steps, 0.0, 1.0))
        n_weight = min(len(analyses) - 1, 3) / 3.0
        graduation_score = raw_grad * n_weight
        
        # === STEP 4: Composite soft_strength ===
        # Guard: if mean_C < 6, palette is all-neutral, not "soft".
        # Absence of color is not softness — softness requires color to be muted.
        # Linear ramp 0→1 below C*=6; existing formula above C*=6.
        # Continuous at join: both branches yield 1.0 at mean_C=6.
        if mean_C < 6.0:
            chroma_signal = float(mean_C / 6.0)
        else:
            chroma_signal = float(np.clip((35.0 - mean_C) / (35.0 - 6.0), 0.0, 1.0))
        cv_signal = float(np.clip(1.0 - chroma_CV / 0.80, 0.0, 1.0))
        
        soft_strength = (
            0.25 * chroma_signal +
            0.15 * cv_signal +
            0.35 * temperature_coherence +
            0.25 * graduation_score
        )
        soft_strength = float(np.clip(soft_strength, 0.0, 1.0))
        
        # === STEP 5: Confusion Guard ===
        n = len(analyses)
        n_pairs = n * (n - 1) // 2
        confused_pairs = 0
        strongly_confused = 0
        
        for i in range(n):
            for j in range(i + 1, n):
                de = float(np.sqrt(
                    (labs[i]['L'] - labs[j]['L'])**2 +
                    (labs[i]['a'] - labs[j]['a'])**2 +
                    (labs[i]['b'] - labs[j]['b'])**2))
                dL = abs(Ls[i] - Ls[j])
                if de < 10.0 and dL < 8.0:
                    confused_pairs += 1
                if de < 5.0 and dL < 4.0:
                    strongly_confused += 1
        
        confusion_triggered = False
        if n_pairs > 0:
            if strongly_confused >= max(n_pairs - 1, 1):
                soft_strength = 0.0
                confusion_triggered = True
            elif confused_pairs >= max(n_pairs - 1, 1):
                soft_strength = min(soft_strength, 0.05)
                confusion_triggered = True
        
        # === STEP 6: Family classification ===
        if not chromatic_items:
            family = 'achromatic'
            mean_H = 0.0
        else:
            chrom_hues = [a['lch']['H'] for a, _ in chromatic_items]
            chrom_chromas = [a['lch']['C'] for a, _ in chromatic_items]
            chrom_Ls = [a['lch']['L'] for a, _ in chromatic_items]
            mean_H = float(np.mean(chrom_hues))
            mean_chrom_C = float(np.mean(chrom_chromas))
            mean_chrom_L = float(np.mean(chrom_Ls))
            
            if mean_chrom_C <= 15:
                family = 'warm_neutral' if temperature == 'warm' else 'cool_neutral'
            elif mean_chrom_C > 40 and mean_chrom_L > 40:
                family = 'bold'
            elif mean_chrom_C > 25 and mean_chrom_L < 55:
                family = 'jewel'
            elif 8 <= mean_chrom_C <= 30 and mean_chrom_L > 65:
                family = 'pastel'
            elif (0 <= mean_H < 110 or mean_H >= 330) and 8 <= mean_chrom_C <= 50:
                family = 'earth'
            else:
                family = 'mixed'
                
        # === STEP 7: Gap analysis ===
        outfit_gaps = {
            'needs_dark_anchor': not any(L < 35 for L in Ls),
            'needs_light_anchor': not any(L > 80 for L in Ls),
            'needs_chromatic_accent': all(C < 15 for C in chromas),
            'needs_neutral': not any(C < 12 for C in chromas),
            'needs_L_graduation': (L_range < 15) or (L_range < 25 and soft_strength < 0.4),
        }
        
        return {
            'mean_C': round(mean_C, 2),
            'chroma_CV': round(chroma_CV, 3),
            'chroma_signal': round(chroma_signal, 3),
            'cv_signal': round(cv_signal, 3),
            'temperature_coherence': round(temperature_coherence, 3),
            'graduation_score': round(graduation_score, 3),
            'soft_strength': round(soft_strength, 3),
            'confused_pairs': confused_pairs,
            'strongly_confused': strongly_confused,
            'confusion_triggered': confusion_triggered,
            'family': family,
            'temperature': temperature,
            'mean_H': round(mean_H, 2),
            'outfit_gaps': outfit_gaps
        }

    # ── Rule 1: Hue Harmony ───────────────────────────────────────────────────

    def hue_harmony(self, analyses, quality_weights=None, area_ratios=None):
        """
        v7.0: Hero pair weighting + visual weights + min-blend (FIX 1, 2, 3).

        FIX 1 — Min-blend:
            One badly-clashing pair should drag down the score even when
            all other pairs are harmonious.  The score is now:
                β × min(pair_score) + (1-β) × weighted_average
            β = 0.30.  This is the asymmetric counterpart to the max-blend
            in contrast_harmony — human perception of hue clash is punishing.

        FIX 2 — Hero pair weighting:
            Pairs that include the hero item (highest visual impact) receive
            a 2× weight multiplier.  The hero-vs-rest axis is the primary
            harmony signal; background pairs are secondary.

        FIX 3 — Visual weights replace area_ratios:
            Pair weights now use visual_weight = area × (1 + chroma_norm)
            instead of raw area.  Vivid items attract the eye regardless of
            their physical size.
        """
        if len(analyses) < 2:
            return self._cap(0.70)

        # FIX 7: detect monochrome / cohesive / high-contrast-neutral style first
        mono = self._monochrome_style(analyses)
        if mono["hue_bonus"] is not None:
            return self._cap(mono["hue_bonus"])

        ars  = area_ratios or [1.0] * len(analyses)
        vws  = self._visual_weights(analyses, ars)          # FIX 3
        hero = self._hero_index(analyses, ars)              # FIX 2
        qws  = quality_weights or [1.0] * len(analyses)

        chromatic_idx = [
            i for i, a in enumerate(analyses)
            if not self.conv.is_achromatic(a["lch"])
        ]
        if len(chromatic_idx) < 2:
            return self._cap(0.88)

        pair_scores, pair_weights = [], []
        for ii in range(len(chromatic_idx)):
            for jj in range(ii + 1, len(chromatic_idx)):
                i = chromatic_idx[ii]
                j = chromatic_idx[jj]
                diff = self.conv.hue_distance(
                    analyses[i]["lch"]["H"], analyses[j]["lch"]["H"]
                )
                pair_scores.append(self._hue_pair_score(diff))

                # FIX 3: visual weight (area × chroma)
                dom_w = (qws[i] * vws[i] + qws[j] * vws[j]) / 2.0
                # FIX 2: hero pair amplification
                if i == hero or j == hero:
                    dom_w *= 2.0
                pair_weights.append(dom_w)

        # FIX 1: blend toward the worst pair (hue clash is punishing)
        score = self._blend_toward_min(pair_scores, pair_weights, beta=0.30)
        return self._cap(score)

    @staticmethod
    def _hue_pair_score(diff):
        pts = [(0,1.00),(25,0.90),(45,0.83),(70,0.60),(100,0.50),(130,0.65),(160,0.73),(180,0.78)]
        for i in range(len(pts)-1):
            d0, s0 = pts[i]; d1, s1 = pts[i+1]
            if d0 <= diff <= d1:
                t = (diff-d0)/(d1-d0)
                return s0 + t*(s1-s0)
        return 0.60

    # ── Rule 2: Lightness Balance ─────────────────────────────────────────────

    def lightness_balance(self, analyses, quality_weights=None,
                          area_ratios=None):
        """
        v7.0: Max-blend + visual weights (FIX 1, 3).

        FIX 1 — Max-blend:
            score = 0.35 × max(pair_scores) + 0.65 × weighted_average
            One outstanding lightness pair (e.g. white top + near-black pants)
            now has real influence on the score rather than being averaged away
            by moderate pairs.

        FIX 3 — Visual weights:
            Pair weights now use area × (1 + chroma_norm) instead of raw area,
            consistent with hue_harmony and contrast_harmony.

        v6 max-ΔL* bonus retained — it remains valid as an explicit extreme-
        spread reward on top of the blended base.
        """
        if len(analyses) < 2:
            return self._cap(0.70)

        ars = area_ratios or [1.0] * len(analyses)
        vws = self._visual_weights(analyses, ars)            # FIX 3
        Ls  = [a["lch"]["L"] for a in analyses]
        qws = quality_weights or [1.0] * len(analyses)

        pair_s, pair_w = [], []
        max_delta_L    = 0.0
        for i in range(len(Ls)):
            for j in range(i + 1, len(Ls)):
                delta_L = abs(Ls[i] - Ls[j])
                max_delta_L = max(max_delta_L, delta_L)
                pair_s.append(self._lightness_pair_score(delta_L))
                pair_w.append((qws[i] * vws[i] + qws[j] * vws[j]) / 2.0)

        # FIX 1: blend toward the strongest pair
        base_score = self._blend_toward_max(pair_s, pair_w, alpha=0.35)

        # v6 retained: bonus for extreme-spread outfits
        bonus = 0.0
        if max_delta_L >= 60.0:
            bonus = 0.04 * min((max_delta_L - 60.0) / 30.0, 1.0)

        return self._cap(base_score + bonus)

    @staticmethod
    def _lightness_pair_score(dL: float) -> float:
        """
        Smooth lightness balance score.

        FIX 4 (v2.1) — Widened acceptable window.
        FIX 4b (v2.1) — Plateau extended to dL=90 so canonical
        high-contrast neutral outfits (dark suit ΔL*≈89, white shirt)
        stay firmly inside the good zone.

        Curve:
          dL < 5   → 0.45   items blend, too similar
          dL 5-15  → ramp up to plateau
          dL 15-90 → broad plateau 0.88-0.95
          dL 90-98 → gentle descent to 0.45
          dL > 98  → floor 0.30
        """
        if dL < 5:    return 0.45
        if dL < 15:   return 0.45 + 0.43*(dL-5)/10
        if dL <= 90:
            return 0.88 + 0.07*np.sin(np.pi*(dL-15)/(90-15))
        if dL <= 98:  return 0.88 - 0.43*(dL-90)/8
        return max(0.30, 0.45 - 0.15*(dL-98)/10)

    # ── Rule 3: Chroma Balance ────────────────────────────────────────────────

    def chroma_balance(self, analyses, area_ratios, quality_weights=None):
        if len(analyses) < 2:
            return self._cap(0.85)
        ws = quality_weights or [1.0]*len(analyses)
        scores = []
        for a, ratio, w in zip(analyses, area_ratios, ws):
            chroma_norm = min(a["lch"]["C"] / 85.0, 1.0)
            ideal_max   = 1.0 - chroma_norm * 0.65
            if ratio <= ideal_max:
                scores.append((1.0, w))
            else:
                excess  = (ratio-ideal_max) / max(1.0-ideal_max, 1e-6)
                penalty = excess * chroma_norm * 0.55
                scores.append((max(0.20, 1.0-penalty), w))
        s_arr = np.array([s for s,_ in scores])
        w_arr = np.array([w for _,w in scores])
        return self._cap(float(np.average(s_arr, weights=w_arr+1e-9)))

    # ── Rule 4: Achromatic Anchor ─────────────────────────────────────────────

    def achromatic_anchor(self, analyses, quality_weights=None,
                          outfit_type: str = None, palette_ctx=None):
        """
        Reward outfits that include at least one neutral (achromatic) anchor
        piece — but only penalise its absence when the outfit structure actually
        benefits from one.

        v5.0 change: outfit-type awareness
        ────────────────────────────────────
        Before v5.0, any outfit with zero neutral items returned 0.65 regardless
        of structure.  This caused systematic under-scoring of 2-item outfits
        with clear colour harmony (e.g. cream blouse + mauve skirt → 0.65 even
        though the outfit is intentionally colourful and well-paired).

        The fix is conditional on outfit_type:

          minimal / simple:
            These outfits may intentionally have no neutral anchor.  A cream
            blouse + mauve skirt is a complete look.  A cobalt top + white skirt
            has the white as a near-neutral.  Return 0.78 (neutral / acceptable)
            instead of 0.65 when no neutral is present.
            Rationale: a human stylist does not insist on a grey scarf for
            every 2-item outfit.  The rule should reflect this.

          layered:
            The inner layer often functions as a de-facto neutral (a white
            shirt under a jacket, or a light top under an outwear).  If no
            true achromatic item is found, the penalty is softened to 0.72.
            If a neutral IS found, the full reward applies.

          complex (3+ chromatic) / None (unspecified):
            Original logic applies.  Complex outfits genuinely benefit from a
            neutral anchor; its absence is a real problem worth flagging.
        """
        if len(analyses) < 2:
            # Single item: achromatic role is undefined
            return self._cap(0.75)

        flags = [self.conv.is_achromatic(a["lch"]) for a in analyses]
        n_neu = sum(flags)
        ratio = n_neu / len(flags)

        # ── No neutral items: outfit_type determines the penalty ─────────────
        if n_neu == 0:
            if outfit_type in ("minimal", "simple"):
                # 2-item colourful outfits don't need a neutral — they ARE the palette
                return self._cap(0.78)   # was 0.65 — removes 3-pt unfair penalty
            if outfit_type == "layered":
                # Inner layer likely acts as neutral even if not truly achromatic
                return self._cap(0.72)   # mild softening
            # complex / None: v9 CCPA interpolation
            # In soft palettes, muted items ARE de-facto anchors even if C*>10.
            # Interpolate floor from 0.65 (v8) toward 0.75 based on soft_strength.
            # Gated: confusion_triggered palettes stay at v8 floor (identical blobs
            # must not benefit from this lift).
            if palette_ctx and not palette_ctx.get('confusion_triggered', False):
                ss = palette_ctx.get('soft_strength', 0.0)
                soft_floor = 0.65 + 0.10 * ss  # 0.65 → 0.75 as ss → 1
                return self._cap(soft_floor)
            return self._cap(0.65)

        # ── Neutral items present: identical to original logic ────────────────
        if ratio >= 1.0:
            return self._cap(0.80)
        if 0.25 <= ratio <= 0.55:
            return self._cap(0.92)
        if ratio < 0.25:
            return self._cap(0.65 + ratio * 1.08)
        return self._cap(0.92 - (ratio - 0.55) * 0.55)

    # ── Rule 5: Contrast Harmony ──────────────────────────────────────────────

    def contrast_harmony(self, analyses, quality_weights=None,
                         area_ratios=None, palette_ctx=None):
        """
        Perceptual contrast between clothing items.

        v7.0 Changes
        ─────────────
        FIX 1 — Max-blend replaces pure weighted average:
            raw = 0.35 × max(pair_scores) + 0.65 × weighted_average
            One strongly-contrasting pair is enough to make an outfit look
            dynamic — it should not be averaged away by moderate pairs.

        FIX 2 — Hero pair amplification (new in v7.0):
            Pairs that include the hero item (highest visual impact) get a 2×
            weight multiplier.  The hero-vs-rest axis is the primary contrast
            signal; pair-of-secondaries is secondary.

        FIX 3 — Visual weights replace raw area_ratios:
            Pair weights use area × (1 + chroma_norm).  Vivid items pull their
            visual weight regardless of physical coverage.

        v6 retained: ΔL* anchor boost, monochrome shortcut, contrast_wt blend.
        """
        if len(analyses) < 2:
            return self._cap(0.70)

        mono = self._monochrome_style(analyses)
        style       = mono["style"]
        contrast_wt = mono["contrast_wt"]

        if style == "monochrome":
            return self._cap(0.78)
        if style == "high_contrast_neutral":
            return self._cap(0.87)

        labs  = [a["lab"]      for a in analyses]
        Ls    = [a["lch"]["L"] for a in analyses]
        qws   = quality_weights or [1.0] * len(analyses)
        ars   = area_ratios     or [1.0] * len(analyses)

        vws  = self._visual_weights(analyses, ars)           # FIX 3
        hero = self._hero_index(analyses, ars)               # FIX 2

        pair_s, pair_w = [], []
        max_delta_L    = 0.0

        for i in range(len(labs)):
            for j in range(i + 1, len(labs)):
                de          = self.conv.delta_e(labs[i], labs[j])
                delta_L     = abs(Ls[i] - Ls[j])
                max_delta_L = max(max_delta_L, delta_L)

                _ss = palette_ctx.get('soft_strength', 0.0) if palette_ctx else 0.0
                pair_s.append(self._contrast_score(de, soft_strength=_ss))

                # FIX 3: visual weight (area × chroma)
                dom_w = (qws[i] * vws[i] + qws[j] * vws[j]) / 2.0
                # FIX 2: hero pair amplification
                if i == hero or j == hero:
                    dom_w *= 2.0
                pair_w.append(dom_w)

        # FIX 1: blend toward the strongest pair
        raw_score = self._blend_toward_max(pair_s, pair_w, alpha=0.35)

        # v6 retained: blend toward neutral when style is not fully varied
        neutral_base = 0.78
        blended = contrast_wt * raw_score + (1.0 - contrast_wt) * neutral_base

        # v6 retained: ΔL* anchor boost
        boost = 0.0
        if max_delta_L >= 55.0:
            has_dark_anchor  = any(L < 12.0 for L in Ls)
            has_light_anchor = any(L > 92.0 for L in Ls)
            base_boost  = 0.04 * min((max_delta_L - 55.0) / 40.0, 1.0)
            anchor_mult = 1.5 if (has_dark_anchor or has_light_anchor) else 1.0
            boost       = min(base_boost * anchor_mult, 0.06)

        return self._cap(blended + boost)

    @staticmethod
    def _contrast_score(de: float, soft_strength: float = 0.0) -> float:
        """
        Monotonic exponential saturation for perceptual contrast (ΔE*ab).

        v6.0 REDESIGN — Gaussian → Monotonic
        ──────────────────────────────────────
        Root cause: The old Gaussian (peak at ΔE=50) PENALISED high contrast.
        Example: Black+Pink (ΔE≈74) → old score 0.51; White+DarkPants (ΔE≈77)
        → old score 0.44.  Both are beautiful, high-contrast pairings that
        human stylists would rate positively.

        Perceptual principle: visual SEPARATION between clothing items is
        monotonically desirable (up to the physical maximum).  The concern
        about "clashing" is a HUE relationship — already modelled by
        hue_harmony().  contrast_harmony() should only model separation.

        New curve: f(ΔE) = max(floor, peak × (1 − exp(−ΔE / σ)))
          When soft_strength=0 (v8 default):
            σ = 28, peak = 0.93, floor = 0.30
          When soft_strength=1 (fully soft palette):
            σ = 14, peak = 0.81, floor = 0.42
          Intermediate values interpolate linearly.

        v9.0 — CCPA interpolation
        ──────────────────────────
        σ shrinks for soft palettes: lower ΔE values are correctly
        recognized as intentional separation rather than failures.
        floor rises: even minimal contrast in a muted palette is valued.
        peak drops: vivid separation is less expected in soft palettes.

        Safety clamps:
          σ clamped to [12, 30] to prevent floating-point drift.
        """
        s     = float(np.clip(soft_strength, 0.0, 1.0))
        sigma = 28.0 + (14.0 - 28.0) * s   # 28 → 14 as s → 1
        sigma = float(np.clip(sigma, 12.0, 30.0))  # safety clamp
        peak  = 0.93 + (0.81 - 0.93) * s   # 0.93 → 0.81
        floor = 0.30 + (0.42 - 0.30) * s   # 0.30 → 0.42
        raw   = peak * (1.0 - np.exp(-de / sigma))
        return float(max(floor, raw))


# =============================================================================
# MODULE 6 — SCORE CALIBRATOR  (NEW IN v2)
# =============================================================================

class ScoreCalibrator:
    """
    Converts a raw weighted-average rule score into a realistic final score.

    v4.1 REDESIGN — three targeted changes (approved 2025)
    ───────────────────────────────────────────────────────
    CONTEXT: After upgrading segmentation from DeepLab to YOLO-seg, the system
    started producing unrealistically high scores (approaching 100%) on ordinary
    outfits.  The root cause: DeepLab's noisy masks used to silently introduce
    two implicit score reducers that YOLO eliminated:
      1. Impure pixel extraction → mean_quality ≈ 0.65 → quality_penalty ≈ 1.5 pts
      2. Contaminated rule inputs → rules capped naturally at ~0.87 in practice

    With YOLO, both reducers disappeared simultaneously:
      1. Clean masks → mean_quality ≈ 0.95 → quality_penalty ≈ 0 pts
      2. Pure inputs → rules reach their hard cap of 0.88 cleanly

    The three approved changes correct this without touching any other module.

    CHANGE 1 — Configurable baseline imperfection  (new parameter)
    ──────────────────────────────────────────────────────────────
    A fixed deduction applied to every outfit regardless of quality.

    Rationale: No real outfit is without flaw.  Fashion stylists never
    award 100/100 — they reserve the top of the scale for theoretical
    perfection.  This deduction models that professional reserve.

    It replaces the implicit penalty that noisy segmentation used to provide.
    Being configurable lets future deployments tune it empirically against
    human-rated outfit datasets.

    Default: 3.5 pts  (chosen so YOLO's practical ceiling of raw≈88 maps
    to a final score of ~84%, which sits comfortably in "excellent" territory
    without being unreachable or suspiciously round).

    CHANGE 2 — Quality component reduced: 5.0 → 4.0 pts max
    ─────────────────────────────────────────────────────────
    The baseline penalty now covers the "always-present" imperfection,
    so the quality component only needs to model data uncertainty.
    Keeping it at 5.0 would double-penalise outfits with low-quality
    segmentation.  4.0 is the residual data-uncertainty budget.

    CHANGE 3 — Revised upper calibration anchors
    ─────────────────────────────────────────────
    The old anchors were calibrated for DeepLab raw scores (ceiling ~95).
    With the new _MAX_RAW = 0.88, raw scores max at 88.  The anchors have
    been repositioned accordingly so the target score ranges are preserved:

      Target ranges (final score after baseline penalty):
        Average outfit  →  60–72 %    (raw ≈ 68–78)
        Good outfit     →  72–80 %    (raw ≈ 78–85)
        Excellent       →  80–86 %    (raw ≈ 85–88, YOLO practical ceiling)
        Near-perfect    →  86–88 %    (raw > 88, theoretically unreachable
                                       with new _MAX_RAW=0.88)

    Full before/after mapping comparison:
      Raw   Old anchors   New anchors   Net change (new_final - old_final)
      ──    ───────────   ───────────   ─────────────────────────────────
       55        55.0          55.0          same
       70        64.0          65.0          +1 (low range unchanged)
       78        73.7          73.5          −0.2
       85        81.0          82.5          +1.5 (before subtracting baseline)
       88        83.4          87.5          +4.1 (before subtracting baseline)
       93        86.0          91.0          +5   (unreachable with new cap)
      100        92.0          93.0          +1   (unreachable with new cap)

    After subtracting the 3.5 pt baseline, the effective output range at
    YOLO's practical ceiling (raw ≈ 88) is:  87.5 − 3.5 = 84.0 %  ✓
    """

    def __init__(
        self,
        # ── v4.1: new parameter — configurable baseline imperfection ──────────
        baseline_imperfection: float = 3.5,
        # ── v4.1: quality component reduced 5.0 → 4.0 (see class docstring) ──
        max_quality_penalty:   float = 4.0,
        # ── Piecewise calibration anchors: (raw_pct, pre_baseline_cal_pct) ────
        anchors: list = None,
    ):
        """
        Args:
            baseline_imperfection:  Fixed deduction applied to every outfit.
                                    Models the professional "reserve" that no
                                    system awards 100/100. Default: 3.5.
                                    Tune upward (e.g. 4.0–5.0) if scores still
                                    skew high after deployment observation.
            max_quality_penalty:    Additional deduction for low extraction
                                    quality (e.g. heavy skin removal).
                                    Applied on top of baseline. Default: 4.0.
            anchors:                Override the piecewise calibration curve.
                                    Format: list of (raw_pct, calibrated_pct).
                                    Useful for per-deployment tuning.
        """
        self.baseline = baseline_imperfection
        self.mqp      = max_quality_penalty

        # ── v4.1 calibration anchors ──────────────────────────────────────────
        # Lower half (raw < 55): unchanged from v2.1 — low scores stay the same.
        # Upper half: repositioned for YOLO's narrower score range (ceiling ~88).
        # These are the PRE-BASELINE values; subtract self.baseline after.
        #
        # Design constraints applied:
        #   • raw = 55 → cal = 55  (anchor: no change below this point)
        #   • raw = 88 → cal = 87.5 → final ≈ 84  (YOLO excellent outfit)
        #   • Monotonically increasing (no score inversions)
        #   • Smooth (no sharp jumps at intermediate values)
        self.anchors = anchors or [
            (  0.0,   0.0),
            ( 40.0,  40.0),
            ( 55.0,  55.0),   # ← anchor: curve is identity below this point
            ( 70.0,  65.0),   # v4.1: was 75→70 (shifted left to match new range)
            ( 78.0,  73.5),   # v4.1: new anchor in good-outfit band
            ( 85.0,  82.5),   # v4.1: was 85→81 — eased slightly upward
            ( 88.0,  87.5),   # v4.1: YOLO practical ceiling → final ≈ 84
            ( 93.0,  91.0),   # v4.1: not achievable with _MAX_RAW=0.88
            (100.0,  93.0),   # v4.1: hard ceiling (theoretical only)
        ]

    def _piecewise(self, raw: float) -> float:
        """Linear interpolation between calibration anchor points."""
        pts = self.anchors
        if raw <= pts[0][0]:
            return pts[0][1]
        if raw >= pts[-1][0]:
            return pts[-1][1]
        for i in range(len(pts) - 1):
            x0, y0 = pts[i]
            x1, y1 = pts[i + 1]
            if x0 <= raw <= x1:
                t = (raw - x0) / (x1 - x0)
                return y0 + t * (y1 - y0)
        return raw

    def calibrate(self, raw_score_pct: float, mean_quality: float,
                  coverage_report: dict = None) -> float:
        """
        Convert raw weighted-average rule score → realistic final score.

        Formula (v5.0):
            compressed        = piecewise(raw_score_pct)
            quality_component = (1 − max(mean_quality, 0.40)) × mqp
            coverage_penalty  = 0 if detection complete, else 0–4 pts
            total_penalty     = baseline + quality_component + coverage_penalty
            final             = clamp(compressed − total_penalty, 0, 100)

        v5.0 addition — coverage_penalty:
        ───────────────────────────────────
        When the SegmentationCoverageAssessor flags partial detection
        (is_partial=True), an additional penalty is applied proportional to
        (1 - confidence).  Maximum coverage_penalty = 4.0 pts.

        This models the evaluation uncertainty: if we only saw 2 of an outfit's
        3 layers, the final score should reflect that the evaluation is incomplete,
        not that the outfit is bad.  The penalty brings the score into "acceptable
        but unverifiable" territory rather than "Good / Balanced".

        With full detection (is_partial=False): coverage_penalty = 0.  No change
        vs v4.1 for complete detections.
        """
        # Step 1: compress
        compressed = self._piecewise(raw_score_pct)

        # Step 2: quality component
        effective_quality = max(mean_quality, 0.40)
        quality_component = (1.0 - effective_quality) * self.mqp

        # Step 3: coverage uncertainty penalty (v5.0)
        coverage_penalty = 0.0
        if coverage_report and coverage_report.get("is_partial", False):
            conf             = float(coverage_report.get("confidence", 1.0))
            coverage_penalty = (1.0 - conf) * 4.0   # max 4 pts at confidence=0

        # Step 4: total penalty and clamp
        total_penalty = self.baseline + quality_component + coverage_penalty
        calibrated    = max(0.0, min(100.0, compressed - total_penalty))
        return round(calibrated, 1)


# =============================================================================
# MODULE 7 — HARMONY SCORE AGGREGATOR  (v2: quality-aware + calibrated)
# =============================================================================

class HarmonyScoreAggregator:
    """
    Combines five rule scores into a single calibrated harmony percentage.

    v4.1: passes baseline_imperfection through to ScoreCalibrator so the
    parameter is tunable at the top-level analyzer without touching internals.
    compute() now also returns calibration_params in its output dict so
    callers can observe exactly what deductions were applied.
    """

    DEFAULT_WEIGHTS = {
        "hue_score":        0.30,
        "lightness_score":  0.20,
        "chroma_score":     0.20,
        "achromatic_score": 0.15,
        "contrast_score":   0.15,
    }

    def __init__(self, weights=None, baseline_imperfection: float = 3.5,
                 max_quality_penalty: float = 4.0):
        raw = weights or self.DEFAULT_WEIGHTS
        total = sum(raw.values()) or 1.0
        self.weights    = {k: v/total for k, v in raw.items()}
        # v4.1: forward tunable parameters to calibrator
        self.calibrator = ScoreCalibrator(
            baseline_imperfection=baseline_imperfection,
            max_quality_penalty=max_quality_penalty,
        )

    def compute(self, rule_scores: dict, mean_quality: float = 1.0,
                coverage_report: dict = None) -> dict:
        weighted = sum(
            float(rule_scores.get(r, 0.5)) * w
            for r, w in self.weights.items()
        )
        raw_pct = round(weighted * 100, 1)

        # v5.0: forward coverage_report to calibrator for uncertainty penalty
        cal_pct = self.calibrator.calibrate(raw_pct, mean_quality,
                                            coverage_report=coverage_report)

        breakdown = {
            r: {
                "raw_score":    round(float(rule_scores.get(r, 0.5)), 4),
                "weight":       round(w, 4),
                "contribution": round(float(rule_scores.get(r, 0.5)) * w, 4),
            }
            for r, w in self.weights.items()
        }

        effective_quality  = max(mean_quality, 0.40)
        quality_component  = round((1.0 - effective_quality) * self.calibrator.mqp, 2)
        cov_penalty        = 0.0
        if coverage_report and coverage_report.get("is_partial", False):
            cov_penalty = round((1.0 - float(coverage_report.get("confidence", 1.0))) * 4.0, 2)
        total_penalty = round(self.calibrator.baseline + quality_component + cov_penalty, 2)

        return {
            "raw_score_percent":   raw_pct,
            "final_score_percent": cal_pct,
            "mean_quality":        round(mean_quality, 3),
            "interpretation":      self._interpret(cal_pct),
            "rule_breakdown":      breakdown,
            "calibration_params": {
                "baseline_imperfection": self.calibrator.baseline,
                "quality_component":     quality_component,
                "coverage_penalty":      cov_penalty,
                "total_penalty":         total_penalty,
                "pre_penalty_score":     round(self.calibrator._piecewise(raw_pct), 2),
            },
        }

    @staticmethod
    def _interpret(score):
        if score >= 83: return "★★★★★  Excellent — masterfully coordinated outfit"
        if score >= 70: return "★★★★☆  Great — outfit works very well together"
        if score >= 56: return "★★★☆☆  Good — mostly harmonious with minor tensions"
        if score >= 42: return "★★☆☆☆  Fair — noticeable colour conflicts"
        return              "★☆☆☆☆  Poor — strong clashes detected"


# =============================================================================
# MODULE 7b — PERCEPTION MODIFIER  (v8.0: Soft Harmony & Balance Awareness)
# =============================================================================

class PerceptionModifier:
    """
    Perception Phase 2: teach the system to recognise elegance, not just contrast.

    This class is a post-processing layer applied to `rule_scores` after the
    five rule methods run but before the `HarmonyScoreAggregator`.  It does
    NOT change any rule logic.  It adjusts the resulting scores based on
    higher-level palette context that the individual rules cannot see.

    ─────────────────────────────────────────────────────────────────────────
    WHY A SEPARATE LAYER?
    ─────────────────────────────────────────────────────────────────────────
    Each rule evaluates one dimension in isolation.  None of them can ask:
    "is the *overall* palette muted and cohesive?"  That requires combining
    signals from all rules — which is exactly what this modifier does.

    ─────────────────────────────────────────────────────────────────────────
    MODIFIER A — Soft Palette Recognition
    ─────────────────────────────────────────────────────────────────────────
    Problem:
        An outfit of beige top + olive trousers + tan coat has low ΔE between
        items because ALL items are muted.  _contrast_score(ΔE=18) = 0.44 —
        the system reads "low separation → weak outfit."  But a human stylist
        reads "earthy cohesion → elegant."

    Root cause:
        _contrast_score is calibrated for general color distance.  For muted
        palettes, low ΔE is a FEATURE, not a bug.

    Fix:
        When mean C* < 35 and chroma is consistent (not one vivid item hiding
        among dull ones), boost contrast_score and lightness_score.
        The boost is proportional to how muted the palette is.
        Guards prevent it from firing on all-neutral or vivid-mixed outfits.

    ─────────────────────────────────────────────────────────────────────────
    MODIFIER B — Chromatic Smoothness
    ─────────────────────────────────────────────────────────────────────────
    Problem:
        The v7 min-blend on hue_harmony punishes the "worst pair."  For a
        navy + slate + denim outfit (hue range ≈ 45°), the worst pair is still
        45° apart — which scores 0.83 on _hue_pair_score.  But the min-blend
        uses β=0.30 on that, pulling the score slightly below what a human
        would assign for a clearly analogous palette.

    Fix:
        When all chromatic hues span ≤ 65°, reward the smooth transition with
        a hue_score boost proportional to how tight the range is.  Tighter
        hue range = more deliberate, more elegant.

    ─────────────────────────────────────────────────────────────────────────
    MODIFIER C — Visual Balance
    ─────────────────────────────────────────────────────────────────────────
    Problem:
        The system has no concept of "the colors are distributed comfortably
        across the outfit."  A 3-item outfit where all three pieces have
        similar visual weight feels balanced; one where one item monopolises
        attention can feel tense even if hue harmony is fine.

    Fix:
        Measure the Shannon entropy of visual weights (area × chroma) across
        items.  High entropy = weight distributed evenly = balance.
        When entropy > 0.80 of maximum and the outfit is not already in
        conflict (chroma_score ≥ 0.68), boost chroma_score slightly.
        Only fires for 3+ item outfits (2-item balance is trivially binary).

    ─────────────────────────────────────────────────────────────────────────
    IMPORTANT CONSTRAINTS
    ─────────────────────────────────────────────────────────────────────────
    - All boosts are ADDITIVE and CAPPED at _MAX_RAW (0.88)
    - No modifier can lower a score — they only lift undervalued patterns
    - Each modifier has guards that prevent inappropriate firing
    - The modifier info dict is included in the pipeline output for auditability
    """

    # ── Modifier A: soft palette ──────────────────────────────────────────────
    _MUTED_C_THRESHOLD   = 35.0   # mean C* below this → muted palette
    _MUTED_C_MIN         = 6.0    # above this → not all-neutral (guard)
    _MUTED_CV_MAX        = 0.80   # chroma consistency: std/mean < this
    _SOFT_CONTRAST_BOOST = 0.08   # max boost to contrast_score
    _SOFT_LIGHT_BOOST    = 0.05   # max boost to lightness_score

    # ── Modifier B: chromatic smoothness ─────────────────────────────────────
    _SMOOTH_HUE_MAX      = 65.0   # max hue distance for "smooth"
    _SMOOTH_BOOST        = 0.06   # max boost to hue_score

    # ── Modifier C: REMOVED in v9 (replaced by CCPA graduation bonus) ────────

    _MAX_RAW             = 0.88   # hard cap (mirrors ColorHarmonyRules._MAX_RAW)

    # ─────────────────────────────────────────────────────────────────────────

    def adjust(
        self,
        rule_scores: dict,
        analyses: list,
        area_ratios: list,
        mono_dict: dict,
        palette_ctx: dict = None,
    ) -> tuple:
        """
        Apply modifiers and return adjusted rule_scores + audit dict.

        v9 changes:
          - palette_ctx parameter added for CCPA-aware Modifier A reduction
          - Modifier C (visual balance) removed — replaced by CCPA graduation bonus

        Parameters
        ──────────
        rule_scores  : output of the five harmony rules (dict of str→float)
        analyses     : list of color analysis dicts (from ColorConverter.full)
        area_ratios  : list of float (item pixel area / total clothing area)
        mono_dict    : output of ColorHarmonyRules._monochrome_style()
        palette_ctx  : output of _compute_palette_context() or None (v8 compat)

        Returns
        ───────
        (adjusted_scores: dict, modifier_info: dict)

        adjusted_scores  : copy of rule_scores with boosts applied
        modifier_info    : audit dict — which modifiers fired and by how much
        """
        if len(analyses) < 2:
            return dict(rule_scores), {}

        adjusted = dict(rule_scores)
        info: dict = {}

        # ── Modifier A ────────────────────────────────────────────────────────
        soft = self._soft_palette(analyses, mono_dict, palette_ctx=palette_ctx)
        if soft["fires"]:
            adjusted["contrast_score"]  = min(
                self._MAX_RAW, adjusted["contrast_score"]  + soft["contrast_boost"]
            )
            adjusted["lightness_score"] = min(
                self._MAX_RAW, adjusted["lightness_score"] + soft["lightness_boost"]
            )
            info["soft_palette"] = soft

        # ── Modifier B ────────────────────────────────────────────────────────
        smooth = self._chromatic_smoothness(analyses, mono_dict)
        if smooth["fires"]:
            adjusted["hue_score"] = min(
                self._MAX_RAW, adjusted["hue_score"] + smooth["boost"]
            )
            info["chromatic_smoothness"] = smooth

        # ── Modifier C: REMOVED in v9 ─────────────────────────────────────────
        # Visual balance was replaced by the CCPA graduation bonus applied
        # directly to lightness_score in the scoring harness / analyze().

        return adjusted, info

    # ── Modifier A implementation ─────────────────────────────────────────────

    def _soft_palette(self, analyses: list, mono_dict: dict,
                      palette_ctx: dict = None) -> dict:
        """
        Detect muted/soft palettes where low ΔE is intentional.

        v9 change: when CCPA palette_ctx is available and soft_strength > 0.5,
        cap contrast_boost at 0.04 * muted_strength to prevent double-boosting
        (CCPA already adapted the contrast curve for soft palettes).

        Guards:
          - mean C* > 6 → not all-neutral (neutral_flat handles that)
          - mean C* < 35 → genuinely muted
          - chroma CV < 0.80 → consistent muting (not one vivid amid dull ones)
          - style not high_contrast_neutral or neutral_flat (already handled)
        """
        # Guard: already handled by main style detector
        if mono_dict.get("style") in ("high_contrast_neutral", "neutral_flat"):
            return {"fires": False}

        chromas  = [a["lch"]["C"] for a in analyses]
        mean_C   = float(np.mean(chromas))
        std_C    = float(np.std(chromas))

        if mean_C < self._MUTED_C_MIN:
            return {"fires": False}
        if mean_C >= self._MUTED_C_THRESHOLD:
            return {"fires": False}

        # Coefficient of variation: measures how uniformly muted the palette is
        chroma_cv = std_C / (mean_C + 1e-6)
        if chroma_cv > self._MUTED_CV_MAX:
            # One vivid item among dull items — not a muted palette.
            # This is handled correctly by existing rules; no boost needed.
            return {"fires": False}

        # Strength: how muted?  0 at threshold, 1 at C*=6
        muted_strength = float(np.clip(
            (self._MUTED_C_THRESHOLD - mean_C) / (self._MUTED_C_THRESHOLD - self._MUTED_C_MIN),
            0.0, 1.0
        ))

        contrast_boost  = round(self._SOFT_CONTRAST_BOOST  * muted_strength, 4)
        lightness_boost = round(self._SOFT_LIGHT_BOOST * muted_strength, 4)

        return {
            "fires":           True,
            "mean_chroma":     round(mean_C, 1),
            "chroma_cv":       round(chroma_cv, 3),
            "muted_strength":  round(muted_strength, 3),
            "contrast_boost":  contrast_boost,
            "lightness_boost": lightness_boost,
        }

    # ── Modifier B implementation ─────────────────────────────────────────────

    def _chromatic_smoothness(self, analyses: list, mono_dict: dict) -> dict:
        """
        Detect analogous/transitional hue palettes.

        'Smooth' = all chromatic items span ≤ 65° of the hue wheel.
        Examples: olive+mustard+tan (≈35°), navy+slate+teal (≈45°).

        Guards:
          - style must be 'varied' or 'cohesive' (monochrome etc. have their
            own hue_bonus and don't need this)
          - ≥ 2 chromatic items
          - max pairwise hue distance ≤ _SMOOTH_HUE_MAX
        """
        style = mono_dict.get("style", "varied")
        if style not in ("varied", "cohesive"):
            return {"fires": False}

        conv      = ColorConverter()
        chromatic = [a for a in analyses if not conv.is_achromatic(a["lch"])]
        if len(chromatic) < 2:
            return {"fires": False}

        hues = [a["lch"]["H"] for a in chromatic]
        max_dist = 0.0
        for i in range(len(hues)):
            for j in range(i + 1, len(hues)):
                d = abs(hues[i] - hues[j])
                d = min(d, 360.0 - d)
                max_dist = max(max_dist, d)

        if max_dist > self._SMOOTH_HUE_MAX:
            return {"fires": False}

        # Tighter hue range → stronger smoothness signal
        smoothness = float(np.clip(1.0 - max_dist / self._SMOOTH_HUE_MAX, 0.0, 1.0))
        boost      = round(self._SMOOTH_BOOST * smoothness, 4)

        return {
            "fires":        True,
            "max_hue_dist": round(max_dist, 1),
            "smoothness":   round(smoothness, 3),
            "boost":        boost,
        }

    # ── Modifier C: REMOVED in v9 ──────────────────────────────────────────────
    # Visual balance (_visual_balance) has been removed.
    # Its role is replaced by the CCPA graduation bonus applied to
    # lightness_score. See Phase 2.6 in score_lch_outfit() and analyze().


# =============================================================================
# MODULE 8 — VISUALIZER  (v2: skin overlay, quality badges, diagnostic grid)
# =============================================================================

class HarmonyVisualizer:
    """
    Produces a publication-quality matplotlib figure.

    v2 additions
    ─────────────
    • Skin exclusion overlay panel (shows what was removed)
    • Quality badge on each colour swatch
    • Calibration annotation (raw vs. calibrated score)
    • Clean pixel counts in zone labels
    """

    _BG       = "#0d0d1a"
    _BG_LIGHT = "#161628"
    _TEXT     = "#e4e4f0"
    _ACCENT   = "#7b68ee"

    _SCORE_RAMP = LinearSegmentedColormap.from_list(
        "harmony_v2",
        [(0.0,"#c62828"),(0.40,"#f57f17"),(0.70,"#2e7d32"),(1.0,"#0097a7")],
    )

    # ── Public API ────────────────────────────────────────────────────────────

    def render(self, image_rgb, seg_result, item_extractions,
               color_analyses, final_result, figsize=(24, 18)):
        """Build the full analysis figure."""
        clothing = seg_result["clothing_items"]
        p_mask   = seg_result["person_mask"]
        s_mask   = seg_result.get("skin_mask", np.zeros_like(p_mask))
        n_items  = max(len(clothing), 1)
        score    = final_result["final_score_percent"]
        raw_s    = final_result.get("raw_score_percent", score)
        quality  = final_result.get("mean_quality", 1.0)
        s_col    = self._score_hex(score)
        n_cols   = max(n_items, 4)

        fig = plt.figure(figsize=figsize, facecolor=self._BG)
        gs  = gridspec.GridSpec(4, 1, figure=fig, hspace=0.42,
                                left=0.03, right=0.97, top=0.91, bottom=0.04)
        gr0 = gridspec.GridSpecFromSubplotSpec(1, 4, subplot_spec=gs[0], wspace=0.12)
        gr1 = gridspec.GridSpecFromSubplotSpec(1, n_cols, subplot_spec=gs[1], wspace=0.07)
        gr2 = gridspec.GridSpecFromSubplotSpec(1, 1, subplot_spec=gs[2])
        gr3 = gridspec.GridSpecFromSubplotSpec(1, 1, subplot_spec=gs[3])

        # Title
        fig.text(0.50, 0.958, "👗  Clothing Color Harmony Analysis  v2.1",
                 ha="center", fontsize=18, fontweight="bold", color=self._TEXT)
        fig.text(0.50, 0.937,
                 f"Calibrated: {score} %   │   Raw: {raw_s} %   │   "
                 f"Data Quality: {quality*100:.0f} %   │   {final_result['interpretation']}",
                 ha="center", fontsize=10, color=s_col)

        # Row 0: original | person mask | skin removed | gauge
        ax_orig = fig.add_subplot(gr0[0])
        ax_prs  = fig.add_subplot(gr0[1])
        ax_skin = fig.add_subplot(gr0[2])
        ax_gau  = fig.add_subplot(gr0[3])

        self._plot_image(ax_orig, image_rgb, "Original")
        self._plot_image(ax_prs, self._overlay(image_rgb, p_mask, (200,220,100), 0.38),
                         "Person Mask")
        skin_vis = self._skin_exclusion_vis(image_rgb, p_mask, s_mask)
        self._plot_image(ax_skin, skin_vis, "Skin Removed ✓")
        self._draw_gauge(ax_gau, score, raw_s)

        # Row 1: clothing item overlays
        palette = plt.cm.Set3(np.linspace(0, 0.9, n_items))
        for idx, (name, mask) in enumerate(clothing.items()):
            if idx >= n_cols: break
            ax = fig.add_subplot(gr1[idx])
            col = (np.array(palette[idx][:3]) * 255).astype(int)
            ex  = item_extractions.get(name, {})
            q   = ex.get("quality", 1.0)
            cpx = ex.get("clean_px", int(mask.sum()))
            self._plot_image(
                ax,
                self._overlay(image_rgb, mask, col, 0.48),
                f"{name.upper()}\n{cpx:,} clean px  q={q:.2f}",
                fontsize=7,
            )
        for idx in range(len(clothing), n_cols):
            ax = fig.add_subplot(gr1[idx]); ax.axis("off")
            ax.set_facecolor(self._BG)

        # Row 2: swatches
        ax_sw = fig.add_subplot(gr2[0])
        self._draw_swatches(ax_sw, clothing, item_extractions, color_analyses)

        # Row 3: bars
        ax_bar = fig.add_subplot(gr3[0])
        self._draw_bars(ax_bar, final_result)

        return fig

    # ── Helpers ───────────────────────────────────────────────────────────────

    @staticmethod
    def _plot_image(ax, img, title, fontsize=9):
        ax.imshow(img); ax.set_title(title, color="#c8c8e0", fontsize=fontsize, pad=4)
        ax.axis("off"); ax.set_facecolor("#0d0d1a")

    @staticmethod
    def _overlay(img, mask, color, alpha):
        out = img.astype(float).copy()
        m   = mask.astype(bool)
        out[~m] *= 0.25
        for ch, cv in enumerate(color):
            out[m, ch] = out[m, ch]*(1-alpha) + cv*alpha
        return out.clip(0,255).astype(np.uint8)

    @staticmethod
    def _skin_exclusion_vis(image_rgb, person_mask, skin_mask):
        """
        Visualise the skin removal: person region shown normally,
        skin pixels highlighted in salmon red, rest dimmed.
        """
        out = image_rgb.astype(float).copy()
        person = person_mask.astype(bool)
        skin   = skin_mask.astype(bool)
        out[~person] *= 0.20
        # Highlight skin pixels in semi-transparent red
        out[skin, 0] = out[skin, 0]*0.4 + 220*0.6
        out[skin, 1] = out[skin, 1]*0.4 + 80*0.6
        out[skin, 2] = out[skin, 2]*0.4 + 80*0.6
        return out.clip(0,255).astype(np.uint8)

    def _draw_gauge(self, ax, score, raw_score):
        ax.set_facecolor(self._BG); ax.set_aspect("equal")
        theta_bg = np.linspace(np.pi, 0, 200)
        ax.plot(np.cos(theta_bg), np.sin(theta_bg),
                color="#1e1e36", linewidth=18, solid_capstyle="round")

        # Raw score (thin grey arc)
        raw_ang = np.pi*(1-raw_score/100)
        theta_r = np.linspace(np.pi, raw_ang, 200)
        ax.plot(np.cos(theta_r), np.sin(theta_r),
                color="#404060", linewidth=14, solid_capstyle="round", zorder=3)

        # Calibrated score (bright coloured arc)
        cal_ang = np.pi*(1-score/100)
        theta_c = np.linspace(np.pi, cal_ang, 200)
        ax.plot(np.cos(theta_c), np.sin(theta_c),
                color=self._score_hex(score),
                linewidth=10, solid_capstyle="round", zorder=5)

        for pct in (0,25,50,75,100):
            ang = np.pi*(1-pct/100)
            ax.plot([0.88*np.cos(ang),1.02*np.cos(ang)],
                    [0.88*np.sin(ang),1.02*np.sin(ang)],
                    color="#404060", lw=1.5)
            ax.text(1.20*np.cos(ang), 1.20*np.sin(ang), str(pct),
                    ha="center", va="center", fontsize=7, color="#808095")

        ax.text(0, 0.20, f"{score:.1f}%", ha="center", va="center",
                fontsize=22, fontweight="bold", color=self._score_hex(score))
        ax.text(0,-0.05, "Calibrated", ha="center", fontsize=8, color="#9090aa")
        ax.text(0,-0.22, f"Raw: {raw_score:.1f}%", ha="center", fontsize=7,
                color="#606080")
        ax.set_xlim(-1.38,1.38); ax.set_ylim(-0.42,1.35)
        ax.axis("off")
        ax.set_title("Harmony Score", color="#c8c8e0", fontsize=9, pad=4)

    def _draw_swatches(self, ax, clothing, item_extractions, color_analyses):
        ax.set_facecolor(self._BG_LIGHT); ax.axis("off")
        ax.set_title("Dominant Colours  (skin & noise removed)",
                     color=self._TEXT, fontsize=11, pad=8)
        n = len(clothing)
        if n == 0: return
        cw = 1.0 / n

        for ci, name in enumerate(clothing):
            ex      = item_extractions.get(name, {})
            colors  = ex.get("colors", [])
            quality = ex.get("quality", 1.0)
            an      = color_analyses.get(name, {})
            lch     = an.get("lch", {})
            hsv     = an.get("hsv", {})
            x0      = ci * cw + 0.01

            # Quality badge colour
            qcol = "#00c853" if quality>0.65 else ("#fdd835" if quality>0.35 else "#e53935")

            ax.text(x0+cw*0.45, 0.97, name.replace("_"," ").upper(),
                    transform=ax.transAxes, ha="center", va="top",
                    fontsize=8, fontweight="bold", color=self._TEXT)
            ax.text(x0+cw*0.45, 0.90, f"Q={quality:.2f}",
                    transform=ax.transAxes, ha="center", fontsize=7, color=qcol)

            for row, c in enumerate(colors[:3]):
                rgb  = c["rgb"]; prop = c["proportion"]
                yt   = 0.82 - row*0.27; yb = yt - 0.23
                rect = mpatches.FancyBboxPatch(
                    (x0+0.01, yb), cw*0.88, 0.20,
                    boxstyle="round,pad=0.005",
                    facecolor=[v/255.0 for v in rgb],
                    edgecolor="#ffffff30", linewidth=0.8,
                    transform=ax.transAxes, zorder=3)
                ax.add_patch(rect)
                lum    = 0.299*rgb[0]+0.587*rgb[1]+0.114*rgb[2]
                tc     = "#111" if lum > 128 else "#eee"
                ax.text(x0+cw*0.45, (yt+yb)/2,
                        f"RGB({rgb[0]},{rgb[1]},{rgb[2]})\n{prop*100:.0f}%",
                        transform=ax.transAxes, ha="center", va="center",
                        fontsize=6.5, color=tc, zorder=4)

            if lch:
                neutral = ColorConverter.is_achromatic(lch)
                tone    = "Neutral" if neutral else "Chromatic"
                ax.text(x0+cw*0.45, 0.05,
                        f"L*={lch.get('L',0):.0f}  C*={lch.get('C',0):.0f}  "
                        f"H={lch.get('H',0):.0f}°\n"
                        f"S={hsv.get('saturation',0)*100:.0f}%  "
                        f"V={hsv.get('value',0)*100:.0f}%  [{tone}]",
                        transform=ax.transAxes, ha="center", va="bottom",
                        fontsize=6.5, color="#9999bb")

    def _draw_bars(self, ax, final_result):
        ax.set_facecolor(self._BG_LIGHT)
        labels_map = {
            "hue_score":        "🎨  Hue Harmony        (30 %)",
            "lightness_score":  "☀️   Lightness Balance  (20 %)",
            "chroma_score":     "💎  Chroma Balance     (20 %)",
            "achromatic_score": "⚪  Achromatic Anchor  (15 %)",
            "contrast_score":   "🔆  Contrast Harmony   (15 %)",
        }
        bd = final_result["rule_breakdown"]
        names  = [labels_map.get(k, k) for k in bd]
        scores = [bd[k]["raw_score"]*100 for k in bd]
        y_pos  = np.arange(len(names))
        bcols  = [self._score_hex(s) for s in scores]
        bars   = ax.barh(y_pos, scores, color=bcols, height=0.52,
                         alpha=0.88, edgecolor="#ffffff25", linewidth=0.5)
        for bar, s in zip(bars, scores):
            ax.text(bar.get_width()+0.7, bar.get_y()+bar.get_height()/2,
                    f"{s:.1f}%", va="center", fontsize=9, color=self._TEXT)

        # Raw score line (grey)
        raw = final_result.get("raw_score_percent", final_result["final_score_percent"])
        ax.axvline(raw, color="#606080", lw=1.5, ls=":", alpha=0.7)
        # Calibrated score line (gold)
        cal = final_result["final_score_percent"]
        ax.axvline(cal, color="gold", lw=2, ls="--", alpha=0.88)
        ax.text(cal+0.5, len(names)-0.6, f"Cal {cal}%",
                color="gold", fontsize=10, fontweight="bold")

        ax.set_yticks(y_pos)
        ax.set_yticklabels(names, color=self._TEXT, fontsize=9)
        ax.set_xlim(0, 108)
        ax.set_xlabel("Rule Score (%)", color="#9090aa", fontsize=9)
        ax.set_title("Rule-by-Rule Breakdown  │  dashed=calibrated  ·····=raw",
                     color=self._TEXT, fontsize=10, pad=8)
        ax.tick_params(axis="x", colors="#707085")
        ax.tick_params(axis="y", length=0)
        for sp in ax.spines.values(): sp.set_color("#252535")
        ax.set_axisbelow(True)
        ax.xaxis.grid(True, color="#252535", ls="--", lw=0.6)

    def _score_hex(self, score):
        return matplotlib.colors.to_hex(self._SCORE_RAMP(score/100.0))

    # ── Recommendation Panel (NEW in v2.2) ────────────────────────────────────

    def render_recommendations(
        self,
        recommendations: dict,
        figsize: tuple = (18, 9),
    ) -> plt.Figure:
        """
        Render a standalone recommendation card figure.

        Designed to be called after render() to produce a shareable,
        human-readable card — one panel per recommendation, plus a
        palette swatch strip at the bottom.

        Args:
            recommendations: Output of FashionRecommendationEngine.build_report().
            figsize:         Figure size in inches.
        Returns:
            matplotlib Figure (caller is responsible for plt.show / savefig).
        """
        if not isinstance(recommendations, dict):
            recommendations = {}
        score         = recommendations.get("score", 0)
        if not isinstance(score, (int, float)):
            score = 0
        level         = recommendations.get("feedback_level", "medium")
        if not isinstance(level, str):
            level = "medium"
        recs          = recommendations.get("recommendations", [])
        if not isinstance(recs, list):
            recs = []
        palettes      = recommendations.get("palette_suggestions", [])
        if not isinstance(palettes, list):
            palettes = []
        issues_list   = recommendations.get("issues_detected", [])
        if not isinstance(issues_list, list):
            issues_list = []

        level_cfg = {
            "high":   {"label": "✦ High Harmony",   "col": "#00c853", "emoji": "✨"},
            "medium": {"label": "◆ Medium Harmony",  "col": "#fdd835", "emoji": "💡"},
            "low":    {"label": "▼ Needs Work",       "col": "#e53935", "emoji": "⚠"},
        }
        cfg = level_cfg.get(level, level_cfg["medium"])

        fig = plt.figure(figsize=figsize, facecolor=self._BG)

        # ── Title strip ───────────────────────────────────────────────────────
        fig.text(0.50, 0.97, "👗  Fashion Recommendations",
                 ha="center", fontsize=17, fontweight="bold", color=self._TEXT)
        fig.text(0.50, 0.94,
                 f"{cfg['emoji']}  Score {score:.0f}%   ·   {cfg['label']}   ·   "
                 f"Issues: {', '.join(str(x) for x in issues_list) if issues_list else 'None'}",
                 ha="center", fontsize=10, color=cfg["col"])

        gs = gridspec.GridSpec(
            2, 1, figure=fig,
            height_ratios=[3, 1],
            hspace=0.28,
            left=0.03, right=0.97, top=0.88, bottom=0.04,
        )

        # ── Row 0: Recommendation cards ───────────────────────────────────────
        ax_recs = fig.add_subplot(gs[0])
        self._draw_rec_cards(ax_recs, recs, cfg)

        # ── Row 1: Palette suggestions ────────────────────────────────────────
        ax_pal = fig.add_subplot(gs[1])
        self._draw_palette_strip(ax_pal, palettes)

        return fig

    def _draw_rec_cards(self, ax, recs, cfg):
        """Draw recommendation cards side-by-side."""
        ax.set_facecolor(self._BG_LIGHT)
        ax.axis("off")
        ax.set_title("Recommendations  (ranked by importance)",
                     color=self._TEXT, fontsize=11, pad=7, loc="left", x=0.01)

        if not recs:
            ax.text(0.50, 0.50, "No specific issues detected — keep it up!",
                    transform=ax.transAxes, ha="center", va="center",
                    fontsize=13, color="#00c853")
            return

        n = min(len(recs), 6)
        card_w = 1.0 / n
        urgency_cols = {
            "important": "#e53935",
            "moderate":  "#fdd835",
            "subtle":    "#00c853",
        }

        for idx, rec in enumerate(recs[:n]):
            if not isinstance(rec, dict):
                rec = {}
            x0 = idx * card_w + 0.008
            cw = card_w - 0.016
            cx = x0 + cw / 2

            urgency = rec.get("urgency", "moderate")
            if not isinstance(urgency, str):
                urgency = "moderate"
            ucol    = urgency_cols.get(urgency, "#fdd835")

            # Card background
            card_bg = mpatches.FancyBboxPatch(
                (x0, 0.04), cw, 0.90,
                boxstyle="round,pad=0.012",
                facecolor=self._BG,
                edgecolor=ucol,
                linewidth=1.6,
                transform=ax.transAxes,
                zorder=2,
            )
            ax.add_patch(card_bg)

            # Rank badge (top-left corner)
            ax.text(x0 + 0.012, 0.90,
                    f"#{rec.get('rank', idx+1)}",
                    transform=ax.transAxes,
                    ha="left", va="top", fontsize=9,
                    fontweight="bold", color=ucol, zorder=3)

            # Urgency tag (top-right corner)
            ax.text(x0 + cw - 0.008, 0.90,
                    urgency.upper(),
                    transform=ax.transAxes,
                    ha="right", va="top", fontsize=7,
                    color=ucol, zorder=3, style="italic")

            # Category label
            cat_label = str(rec.get("category", "")).replace("_", " ").title()
            ax.text(cx, 0.81, cat_label,
                    transform=ax.transAxes,
                    ha="center", va="top", fontsize=8,
                    fontweight="bold", color="#aaaacc", zorder=3)

            # Affected item badge
            item_label = rec.get("item_affected", "")
            if item_label:
                ax.text(cx, 0.73, f"→ {item_label}",
                        transform=ax.transAxes,
                        ha="center", va="top", fontsize=7.5,
                        color=self._TEXT, zorder=3,
                        bbox=dict(boxstyle="round,pad=0.18",
                                  facecolor="#252540", alpha=0.75,
                                  edgecolor="#ffffff18", linewidth=0.5))

            # Main recommendation text (word-wrapped manually)
            text = str(rec.get("text", ""))
            wrapped = self._wrap_text(text, max_chars=42)
            ax.text(cx, 0.62, wrapped,
                    transform=ax.transAxes,
                    ha="center", va="top", fontsize=8,
                    color=self._TEXT, zorder=3,
                    linespacing=1.45,
                    wrap=False)

            # Reason (smaller, muted)
            reason = str(rec.get("reason", ""))
            wrapped_reason = self._wrap_text(reason, max_chars=48)
            ax.text(cx, 0.22, wrapped_reason,
                    transform=ax.transAxes,
                    ha="center", va="top", fontsize=6.5,
                    color="#7070a0", zorder=3,
                    linespacing=1.35)

    def _draw_palette_strip(self, ax, palettes):
        """Draw suggested colour palette swatches."""
        ax.set_facecolor(self._BG_LIGHT)
        ax.axis("off")
        ax.set_title("Suggested Colours to Incorporate",
                     color=self._TEXT, fontsize=10, pad=6, loc="left", x=0.01)

        if not palettes:
            ax.text(0.50, 0.50, "No specific palette suggestions.",
                    transform=ax.transAxes, ha="center", va="center",
                    fontsize=10, color="#606080")
            return

        n  = min(len(palettes), 6)
        sw = 1.0 / (n + 1)

        for i, pal in enumerate(palettes[:n]):
            if not isinstance(pal, dict):
                pal = {}
            x0  = (i + 0.3) * sw
            rgb = pal.get("rgb", [128, 128, 128])
            if not isinstance(rgb, (list, tuple)) or len(rgb) < 3:
                rgb = [128, 128, 128]
            
            try:
                col = [float(v) / 255.0 for v in rgb[:3]]
            except (ValueError, TypeError):
                col = [0.5, 0.5, 0.5]

            # Main colour circle
            circle = mpatches.Circle((x0 + sw * 0.3, 0.52), 0.12,
                                     color=col, zorder=3,
                                     transform=ax.transAxes)
            ax.add_patch(circle)

            # Hex label under the circle
            ax.text(x0 + sw * 0.3, 0.30, str(pal.get("hex", "")),
                    transform=ax.transAxes,
                    ha="center", fontsize=7.5, color="#888899")

            # Name above the circle
            ax.text(x0 + sw * 0.3, 0.82, str(pal.get("name", "")),
                    transform=ax.transAxes,
                    ha="center", fontsize=9, fontweight="bold",
                    color=self._TEXT)

            # Role below hex
            ax.text(x0 + sw * 0.3, 0.13, str(pal.get("role", "")),
                    transform=ax.transAxes,
                    ha="center", fontsize=6.5, color="#6868aa",
                    style="italic")

    @staticmethod
    def _wrap_text(text: str, max_chars: int = 40) -> str:
        """
        Wrap a long string into multiple lines at word boundaries.
        Pure-Python, no external dependency.
        """
        if len(text) <= max_chars:
            return text
        words  = text.split()
        lines  = []
        current = ""
        for word in words:
            if current and len(current) + 1 + len(word) > max_chars:
                lines.append(current)
                current = word
            else:
                current = (current + " " + word).strip()
        if current:
            lines.append(current)
        return "\n".join(lines)


# =============================================================================
# MODULE 9 — FASHION RECOMMENDATION ENGINE  (NEW in v2.2)
# =============================================================================

class FashionRecommendationEngine:
    """
    Rule-based fashion recommendation engine layered on top of the harmony
    scoring pipeline.  Zero new dependencies — all inputs come from the dict
    returned by ClothingColorHarmonyAnalyzer.analyze().

    Design principles
    ─────────────────
    • Stateless — each call to build_report() is fully self-contained.
    • Tiered intensity — recommendation strength scales with score:
        High  (≥80) → subtle polish hints
        Medium (≥60) → actionable improvements
        Low   (<60)  → strong corrective guidance
    • Ranked output — issues sorted by fashion impact, not detection order.
    • Human-readable — every text field is natural English, no jargon.

    Output contract
    ───────────────
    {
      "score":             float,          # echoed from pipeline
      "feedback_level":    str,            # "high" | "medium" | "low"
      "issues_detected":   [str, …],       # plain-English issue labels
      "recommendations":   [
          {
              "rank":          int,
              "category":      str,
              "urgency":       str,         # "subtle"|"moderate"|"important"
              "text":          str,         # actionable instruction
              "reason":        str,         # why it matters
              "item_affected": str,         # garment label
          }, …
      ],
      "palette_suggestions": [
          {"name": str, "hex": str, "rgb": [R,G,B], "role": str}, …
      ],
    }
    """

    # ── Human-readable labels for segmenter zone names ────────────────────────
    _ITEM_LABELS = {
        "torso":       "top",
        "torso_upper": "jacket",
        "torso_lower": "inner shirt",
        "lower":       "pants",
        "feet":        "shoes",
        "full_outfit": "outfit",
    }

    # ── Curated palette system (v9.0 Phase 3) ─────────────────────────────────
    _CURATED_PALETTE = [
        {'name': 'Camel', 'hex': '#C19A6B', 'rgb': [193, 154, 107], 'lch': (66.1, 31.3, 74.5), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Tan', 'hex': '#D2B48C', 'rgb': [210, 180, 140], 'lch': (75.0, 24.9, 78.4), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Olive', 'hex': '#6B7240', 'rgb': [107, 114, 64], 'lch': (46.4, 29.0, 112.5), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Dark Olive', 'hex': '#4A5028', 'rgb': [74, 80, 40], 'lch': (32.6, 24.6, 112.7), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Rust', 'hex': '#B74C2E', 'rgb': [183, 76, 46], 'lch': (46.2, 56.9, 43.0), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Sienna', 'hex': '#A0522D', 'rgb': [160, 82, 45], 'lch': (43.8, 46.1, 50.6), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Warm Beige', 'hex': '#D4B896', 'rgb': [212, 184, 150], 'lch': (76.4, 21.6, 76.7), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Dark Chocolate', 'hex': '#3E2723', 'rgb': [62, 39, 35], 'lch': (18.4, 12.4, 34.6), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Sand', 'hex': '#C2B280', 'rgb': [194, 178, 128], 'lch': (72.8, 27.7, 93.6), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Terracotta', 'hex': '#C1654C', 'rgb': [193, 101, 76], 'lch': (53.1, 46.2, 41.6), 'family': 'earth', 'temperature': 'warm'},
        {'name': 'Light Grey', 'hex': '#C8C8C8', 'rgb': [200, 200, 200], 'lch': (80.6, 0.0, 180.0), 'family': 'cool_neutral', 'temperature': 'neutral'},
        {'name': 'Mid Grey', 'hex': '#808080', 'rgb': [128, 128, 128], 'lch': (53.6, 0.0, 180.0), 'family': 'cool_neutral', 'temperature': 'neutral'},
        {'name': 'Charcoal', 'hex': '#404040', 'rgb': [64, 64, 64], 'lch': (27.1, 0.0, 180.0), 'family': 'cool_neutral', 'temperature': 'neutral'},
        {'name': 'Slate', 'hex': '#708090', 'rgb': [112, 128, 144], 'lch': (52.8, 10.8, 258.5), 'family': 'cool_neutral', 'temperature': 'cool'},
        {'name': 'Silver', 'hex': '#C0C0C0', 'rgb': [192, 192, 192], 'lch': (77.7, 0.0, 180.0), 'family': 'cool_neutral', 'temperature': 'neutral'},
        {'name': 'Cool Beige', 'hex': '#D8D2C4', 'rgb': [216, 210, 196], 'lch': (84.3, 7.7, 92.6), 'family': 'cool_neutral', 'temperature': 'cool'},
        {'name': 'Ash', 'hex': '#B2BEB5', 'rgb': [178, 190, 181], 'lch': (75.8, 6.6, 151.9), 'family': 'cool_neutral', 'temperature': 'cool'},
        {'name': 'Steel', 'hex': '#5C6B73', 'rgb': [92, 107, 115], 'lch': (44.3, 7.4, 239.5), 'family': 'cool_neutral', 'temperature': 'cool'},
        {'name': 'Ivory', 'hex': '#FAF3E0', 'rgb': [250, 243, 224], 'lch': (95.9, 10.0, 94.7), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Cream', 'hex': '#FFFDD0', 'rgb': [255, 253, 208], 'lch': (98.5, 22.8, 106.6), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Warm Grey', 'hex': '#B5A69B', 'rgb': [181, 166, 155], 'lch': (69.1, 8.4, 65.1), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Taupe', 'hex': '#8B7765', 'rgb': [139, 119, 101], 'lch': (51.4, 13.7, 69.4), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Khaki', 'hex': '#C3B091', 'rgb': [195, 176, 145], 'lch': (72.7, 18.5, 83.9), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Oatmeal', 'hex': '#EAE6DF', 'rgb': [234, 230, 223], 'lch': (91.4, 3.9, 88.0), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Sand Beige', 'hex': '#E1D9C1', 'rgb': [225, 217, 193], 'lch': (86.7, 12.9, 95.5), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Ecru', 'hex': '#D6CFC7', 'rgb': [214, 207, 199], 'lch': (83.5, 4.9, 78.1), 'family': 'warm_neutral', 'temperature': 'warm'},
        {'name': 'Burgundy', 'hex': '#7B2035', 'rgb': [123, 32, 53], 'lch': (28.1, 41.7, 13.8), 'family': 'jewel', 'temperature': 'cool'},
        {'name': 'Emerald', 'hex': '#50C878', 'rgb': [80, 200, 120], 'lch': (72.5, 59.5, 149.4), 'family': 'jewel', 'temperature': 'cool'},
        {'name': 'Sapphire', 'hex': '#0F52BA', 'rgb': [15, 82, 186], 'lch': (37.3, 63.9, 289.9), 'family': 'jewel', 'temperature': 'cool'},
        {'name': 'Deep Teal', 'hex': '#005C53', 'rgb': [0, 92, 83], 'lch': (34.6, 25.9, 183.4), 'family': 'jewel', 'temperature': 'cool'},
        {'name': 'Amethyst', 'hex': '#9966CC', 'rgb': [153, 102, 204], 'lch': (52.5, 60.7, 311.6), 'family': 'jewel', 'temperature': 'cool'},
        {'name': 'Ruby', 'hex': '#E0115F', 'rgb': [224, 17, 95], 'lch': (48.4, 75.4, 10.8), 'family': 'jewel', 'temperature': 'warm'},
        {'name': 'Dark Gold', 'hex': '#B8860B', 'rgb': [184, 134, 11], 'lch': (59.2, 63.5, 81.1), 'family': 'jewel', 'temperature': 'warm'},
        {'name': 'Garnet', 'hex': '#73020C', 'rgb': [115, 2, 12], 'lch': (22.7, 53.1, 33.5), 'family': 'jewel', 'temperature': 'warm'},
        {'name': 'Dusty Rose', 'hex': '#C48B8B', 'rgb': [196, 139, 139], 'lch': (63.4, 23.4, 21.8), 'family': 'pastel', 'temperature': 'warm'},
        {'name': 'Lavender', 'hex': '#B39DDB', 'rgb': [179, 157, 219], 'lch': (68.6, 35.1, 305.6), 'family': 'pastel', 'temperature': 'cool'},
        {'name': 'Sage', 'hex': '#8FAF8A', 'rgb': [143, 175, 138], 'lch': (68.3, 23.8, 139.6), 'family': 'pastel', 'temperature': 'cool'},
        {'name': 'Baby Blue', 'hex': '#89CFF0', 'rgb': [137, 207, 240], 'lch': (79.7, 26.8, 239.6), 'family': 'pastel', 'temperature': 'cool'},
        {'name': 'Blush', 'hex': '#FEC5E5', 'rgb': [254, 197, 229], 'lch': (85.3, 26.5, 342.4), 'family': 'pastel', 'temperature': 'warm'},
        {'name': 'Mint', 'hex': '#AAF0D1', 'rgb': [170, 240, 209], 'lch': (89.6, 29.2, 164.0), 'family': 'pastel', 'temperature': 'cool'},
        {'name': 'Peach', 'hex': '#FFD1AA', 'rgb': [255, 209, 170], 'lch': (86.9, 27.7, 66.9), 'family': 'pastel', 'temperature': 'warm'},
        {'name': 'Lilac', 'hex': '#C8A2C8', 'rgb': [200, 162, 200], 'lch': (71.1, 24.9, 325.5), 'family': 'pastel', 'temperature': 'cool'},
        {'name': 'Cobalt', 'hex': '#3359A8', 'rgb': [51, 89, 168], 'lch': (39.0, 48.5, 286.4), 'family': 'bold', 'temperature': 'cool'},
        {'name': 'Red', 'hex': '#FF0000', 'rgb': [255, 0, 0], 'lch': (53.2, 104.6, 40.0), 'family': 'bold', 'temperature': 'warm'},
        {'name': 'Orange', 'hex': '#FF7F00', 'rgb': [255, 127, 0], 'lch': (66.9, 85.7, 59.6), 'family': 'bold', 'temperature': 'warm'},
        {'name': 'Hot Pink', 'hex': '#FF69B4', 'rgb': [255, 105, 180], 'lch': (65.5, 65.1, 350.6), 'family': 'bold', 'temperature': 'warm'},
        {'name': 'Electric Blue', 'hex': '#0055FF', 'rgb': [0, 85, 255], 'lch': (43.8, 99.8, 297.3), 'family': 'bold', 'temperature': 'cool'},
        {'name': 'Yellow', 'hex': '#FFFF00', 'rgb': [255, 255, 0], 'lch': (97.1, 96.9, 102.9), 'family': 'bold', 'temperature': 'warm'},
        {'name': 'Lime', 'hex': '#00FF00', 'rgb': [0, 255, 0], 'lch': (87.7, 119.8, 136.0), 'family': 'bold', 'temperature': 'cool'},
        {'name': 'Magenta', 'hex': '#FF00FF', 'rgb': [255, 0, 255], 'lch': (60.3, 115.5, 328.2), 'family': 'bold', 'temperature': 'cool'},
        {'name': 'White', 'hex': '#FFFFFF', 'rgb': [255, 255, 255], 'lch': (100.0, 0.0, 180.0), 'family': 'achromatic', 'temperature': 'neutral'},
        {'name': 'Off-White', 'hex': '#FAF9F6', 'rgb': [250, 249, 246], 'lch': (97.9, 1.6, 97.1), 'family': 'achromatic', 'temperature': 'neutral'},
        {'name': 'Light Grey', 'hex': '#C8C8C8', 'rgb': [200, 200, 200], 'lch': (80.6, 0.0, 180.0), 'family': 'achromatic', 'temperature': 'neutral'},
        {'name': 'Mid Grey', 'hex': '#808080', 'rgb': [128, 128, 128], 'lch': (53.6, 0.0, 180.0), 'family': 'achromatic', 'temperature': 'neutral'},
        {'name': 'Dark Grey', 'hex': '#505050', 'rgb': [80, 80, 80], 'lch': (34.0, 0.0, 180.0), 'family': 'achromatic', 'temperature': 'neutral'},
        {'name': 'Charcoal', 'hex': '#404040', 'rgb': [64, 64, 64], 'lch': (27.1, 0.0, 180.0), 'family': 'achromatic', 'temperature': 'neutral'},
        {'name': 'Black', 'hex': '#1A1A1A', 'rgb': [26, 26, 26], 'lch': (9.3, 0.0, 180.0), 'family': 'achromatic', 'temperature': 'neutral'},
        {'name': 'Navy', 'hex': '#1B2A4A', 'rgb': [27, 42, 74], 'lch': (17.4, 22.4, 283.2), 'family': 'achromatic', 'temperature': 'cool'},
    ]

    _NEUTRALS = []
    _ACCENTS = []

    # Map roles for backward compatibility
    _roles = {
        "White": "brighten & add contrast",
        "Ivory": "soften and warm",
        "Light Grey": "cool neutral anchor",
        "Warm Beige": "warm neutral anchor",
        "Camel": "classic warm neutral",
        "Mid Grey": "versatile mid-tone anchor",
        "Taupe": "earthy neutral anchor",
        "Charcoal": "dark grounding anchor",
        "Navy": "sophisticated dark anchor",
        "Black": "define and ground",
    }

    _seen_neutrals = set()
    for _entry in _CURATED_PALETTE:
        _name = _entry['name']
        if _name in _roles and _name not in _seen_neutrals:
            _seen_neutrals.add(_name)
            _NEUTRALS.append({
                "name": _name,
                "hex": _entry["hex"],
                "rgb": _entry["rgb"],
                "L": _entry["lch"][0],
                "role": _roles[_name]
            })

    _seen_accents = set()
    for _entry in _CURATED_PALETTE:
        _name = _entry['name']
        if _entry['family'] not in ('cool_neutral', 'warm_neutral', 'achromatic') and _name not in _seen_accents:
            _seen_accents.add(_name)
            _ACCENTS.append({
                "name": _name,
                "hex": _entry["hex"],
                "rgb": _entry["rgb"],
                "hue": _entry["lch"][2]
            })


    # ── Template strings for recommendation rendering (v9) ────────────────────
    _TEMPLATES = {
        'swap':           'Try {color} {garment} instead',
        'swap_alt':       'Replace the {garment} with {color}',
        'swap_improve':   '{color} {garment} would improve harmony',
        'add_accessory':  'A {color} accessory would tie the look together',
        'add_contrast':   'Add a {color} belt or scarf for contrast',
        'darker':         'Darker {garment} would add depth',
        'lighter':        'A lighter {garment} would open up the outfit',
        'refine_darker':  'A slightly darker {garment} would sharpen the look',
        'refine_warmer':  'Try a warmer shade for the {garment}',
        'affirm':         'Well-coordinated outfit \u2014 no changes needed',
        'affirm_feature': 'Strong color harmony \u2014 the {feature} works well',
        'affirm_add':     'A {color} accessory would complement the look',
        'affirm_deepen':  'A dark {color} belt would deepen the palette',
        'neutral_add':    'Adding a neutral piece would let the colors breathe',
        'neutral_swap':   'Swap the {garment} for a neutral like {color}',
    }

    # =========================================================================
    # PUBLIC API  (v9 — 9-Step Reverse-Scoring Pipeline)
    # =========================================================================

    def build_report(self, pipeline_result: dict) -> dict:
        """
        v9 recommendation pipeline — deterministic 9-step process.

        Steps
        ─────
        1. Mode selection  (affirm / refine / repair)
        2. Read gap analysis from palette_ctx
        3. Worst-item identification (leave-one-out)
        4. Family & temperature classification
        5. Reverse scoring (worst items × palette candidates)
        6. Identity filter (4 checks)
        7. Gap-aware ranking
        8. Template rendering
        9. Affirm enhancement
        """
        score = float(pipeline_result.get("score", 50.0))
        items = pipeline_result.get("items", [])

        if len(items) < 2:
            return self._empty_report(score)

        # Build analysis dicts from items
        analyses = []
        area_ratios = []
        for it in items:
            ci = it["color_info"]
            lch = ci["lch"]
            L, C, H = lch["L"], lch["C"], lch["H"]
            lab = ci.get("lab")
            if lab is None:
                H_rad = np.radians(H)
                lab = {"L": L, "a": float(C * np.cos(H_rad)),
                       "b": float(C * np.sin(H_rad))}
            hsv = ci.get("hsv", {"H": H, "S": min(C / 85.0, 1.0),
                                  "V": L / 100.0})
            analyses.append({"lab": lab, "lch": lch,
                             "rgb": it.get("color", [128, 128, 128]),
                             "hsv": hsv})
            area_ratios.append(it.get("area_ratio", 1.0 / len(items)))

        # Get or compute palette_ctx
        palette_ctx = pipeline_result.get("palette_ctx")
        if palette_ctx is None:
            _rules = ColorHarmonyRules()
            palette_ctx = _rules._compute_palette_context(analyses, area_ratios)

        is_confused = palette_ctx.get("confusion_triggered", False)

        # ── Step 1: Mode selection ────────────────────────────────────────
        if score >= 78 and not is_confused:
            mode = "affirm"
        elif score >= 58:
            mode = "refine"
        else:
            mode = "repair"

        feedback_level = {"affirm": "high", "refine": "medium",
                          "repair": "low"}[mode]

        # ── Step 2: Read gap analysis ─────────────────────────────────────
        gaps = palette_ctx.get("outfit_gaps", {})
        issues = self._gaps_to_issues(gaps)

        # ── Affirm mode → skip to Step 9 ─────────────────────────────────
        if mode == "affirm":
            recs = self._affirm_enhancement(gaps, palette_ctx)
            return {
                "score": round(score, 1),
                "feedback_level": feedback_level,
                "mode": mode,
                "outfit_context": palette_ctx,
                "issues_detected": issues,
                "recommendations": recs,
                "palette_suggestions": self._palette_suggestions(recs),
            }

        # ── Step 3: Worst-item identification (LOO) ───────────────────────
        rules = ColorHarmonyRules()
        original_raw = self._quick_score(rules, analyses, area_ratios)
        worst_indices = self._find_worst_items(
            rules, analyses, area_ratios, original_raw)

        # ── Step 4: Family & temperature ──────────────────────────────────
        family = palette_ctx.get("family", "mixed")
        temperature = palette_ctx.get("temperature", "neutral")

        # ── Step 5: Reverse scoring ───────────────────────────────────────
        candidates = self._reverse_score(
            rules, analyses, area_ratios, worst_indices,
            original_raw, items)

        # ── Step 6: Identity filter ───────────────────────────────────────
        candidates = self._identity_filter(candidates, palette_ctx)

        # ── Step 7: Gap-aware ranking ─────────────────────────────────────
        mean_L = float(np.mean([a["lch"]["L"] for a in analyses]))
        ranked = self._gap_aware_rank(candidates, gaps, mean_L)

        # ── Step 8: Template rendering ────────────────────────────────────
        recs = self._render_recommendations(ranked, mode, gaps)

        palette_sugs = self._palette_suggestions(ranked[:3])

        return {
            "score": round(score, 1),
            "feedback_level": feedback_level,
            "mode": mode,
            "outfit_context": palette_ctx,
            "issues_detected": issues,
            "recommendations": recs,
            "palette_suggestions": palette_sugs,
        }

    # =========================================================================
    # 9-STEP PIPELINE — INTERNAL METHODS
    # =========================================================================

    def _find_worst_items(self, rules, analyses, area_ratios, original_score):
        """Step 3: Leave-one-out worst-item identification."""
        n = len(analyses)
        if n <= 2:
            return list(range(n))

        improvements = []
        for i in range(n):
            reduced = analyses[:i] + analyses[i + 1:]
            reduced_ar = area_ratios[:i] + area_ratios[i + 1:]
            total = sum(reduced_ar)
            if total > 0:
                reduced_ar = [r / total for r in reduced_ar]
            reduced_score = self._quick_score(rules, reduced, reduced_ar)
            improvements.append((reduced_score - original_score, i))

        improvements.sort(reverse=True)
        return [idx for _, idx in improvements[:2]]

    def _reverse_score(self, rules, analyses, area_ratios,
                       worst_indices, original_score, items):
        """Step 5: Try every palette color as replacement for worst items."""
        candidates = []

        for target_idx in worst_indices:
            target_name = items[target_idx].get("name", f"item_{target_idx}")
            target_label = self._label(target_name)

            for color in self._CURATED_PALETTE:
                new_analysis = self._make_analysis_from_lch(color["lch"])
                modified = list(analyses)
                modified[target_idx] = new_analysis

                new_score = self._quick_score(rules, modified, area_ratios)
                improvement = new_score - original_score

                if improvement > 0:
                    candidates.append({
                        "target_idx": target_idx,
                        "target_garment": target_name,
                        "target_label": target_label,
                        "color_name": color["name"],
                        "color_hex": color["hex"],
                        "color_rgb": color["rgb"],
                        "color_lch": color["lch"],
                        "color_family": color["family"],
                        "color_temperature": color["temperature"],
                        "score_improvement": round(improvement, 2),
                    })

        return candidates

    def _quick_score(self, rules, analyses, area_ratios):
        """Lightweight 5-rule raw weighted sum — no calibration, no modifiers."""
        if len(analyses) < 2:
            return 50.0
        hue = rules.hue_harmony(analyses, area_ratios=area_ratios)
        lightness = rules.lightness_balance(analyses, area_ratios=area_ratios)
        chroma = rules.chroma_balance(analyses, area_ratios)
        achromatic = rules.achromatic_anchor(analyses)
        contrast = rules.contrast_harmony(analyses, area_ratios=area_ratios)
        raw = (0.30 * hue + 0.20 * lightness + 0.20 * chroma +
               0.15 * achromatic + 0.15 * contrast)
        return raw * 100.0

    def _identity_filter(self, candidates, palette_ctx):
        """Step 6: 4-check identity preservation filter."""
        outfit_family = palette_ctx.get("family", "mixed")
        outfit_temp = palette_ctx.get("temperature", "neutral")
        soft_strength = palette_ctx.get("soft_strength", 0.0)
        temp_coherence = palette_ctx.get("temperature_coherence", 0.5)

        filtered = []
        for c in candidates:
            cf = c["color_family"]
            ct = c["color_temperature"]
            c_C = c["color_lch"][1]
            c_H = c["color_lch"][2]

            # Check 1: Family mismatch (achromatic/neutrals always pass)
            if cf not in ("achromatic", "cool_neutral", "warm_neutral"):
                if outfit_family not in ("mixed",) and cf != outfit_family:
                    continue

            # Check 2: Temperature flip (both must be non-neutral)
            if ct != "neutral" and outfit_temp != "neutral":
                if ct != outfit_temp:
                    continue

            # Check 3: Soft strength drift
            if c_C > 50 and soft_strength > 0.5:
                continue

            # Check 4: Temperature sector enforcement
            if temp_coherence > 0.65:
                candidate_sector = self._temperature_sector(c_H)
                if candidate_sector != "neutral":
                    outfit_sector = "warm" if outfit_temp == "warm" else "cool"
                    if candidate_sector != outfit_sector:
                        continue

            filtered.append(c)

        return filtered

    def _gap_aware_rank(self, candidates, gaps, mean_L):
        """Step 7: Score improvement + gap tiebreaker ranking."""
        if not candidates:
            return []

        candidates.sort(key=lambda c: -c["score_improvement"])

        best_imp = candidates[0]["score_improvement"]
        band = [c for c in candidates
                if c["score_improvement"] >= best_imp - 3.0]
        rest = [c for c in candidates
                if c["score_improvement"] < best_imp - 3.0]

        for c in band:
            L = c["color_lch"][0]
            C = c["color_lch"][1]
            if gaps.get("needs_dark_anchor"):
                c["_tb"] = -L
            elif gaps.get("needs_light_anchor"):
                c["_tb"] = L
            elif gaps.get("needs_chromatic_accent"):
                c["_tb"] = C
            elif gaps.get("needs_neutral"):
                c["_tb"] = -C
            elif gaps.get("needs_L_graduation"):
                c["_tb"] = abs(L - mean_L)
            else:
                c["_tb"] = 0.0

        band.sort(key=lambda c: -c.get("_tb", 0.0))

        ranked = []
        seen_slots = set()
        for c in band + rest:
            slot = c["target_garment"]
            if slot not in seen_slots:
                seen_slots.add(slot)
                c.pop("_tb", None)
                c["fills_gap"] = self._check_gap_fill(c["color_lch"], gaps)
                ranked.append(c)
                if len(ranked) >= 3:
                    break

        return ranked

    def _render_recommendations(self, ranked, mode, gaps):
        """Step 8: Template rendering → list of recommendation dicts."""
        recs = []
        for i, c in enumerate(ranked, 1):
            template_key = self._select_template(mode, c, gaps)
            template = self._TEMPLATES.get(template_key,
                                           self._TEMPLATES["swap_improve"])
            text = template.format(
                color=c["color_name"],
                garment=c["target_label"],
                feature=c["target_label"],
            )

            imp = c["score_improvement"]
            if imp >= 8:
                urgency = "important"
            elif imp >= 4:
                urgency = "moderate"
            else:
                urgency = "subtle"

            reason = self._build_reason(c, mode)

            recs.append({
                "rank":              i,
                "target_garment":    c["target_garment"],
                "target_label":      c["target_label"],
                "color_name":        c["color_name"],
                "color_hex":         c["color_hex"],
                "color_lch":         c["color_lch"],
                "score_improvement": c["score_improvement"],
                "fills_gap":         c.get("fills_gap"),
                "text":              text,
                "urgency":           urgency,
                # Backward-compatible keys for visualizer
                "category":          template_key,
                "item_affected":     c["target_label"],
                "reason":            reason,
            })

        return recs

    def _select_template(self, mode, candidate, gaps):
        """Select the appropriate template key based on mode and gaps."""
        if mode == "repair":
            if gaps.get("needs_dark_anchor"):
                return "darker" if candidate["color_lch"][0] < 40 else "swap"
            if gaps.get("needs_light_anchor"):
                return "lighter" if candidate["color_lch"][0] > 75 else "swap"
            if gaps.get("needs_chromatic_accent"):
                return "add_contrast"
            return "swap"

        if mode == "refine":
            if gaps.get("needs_neutral"):
                return "neutral_swap"
            return "swap_improve"

        return "affirm_add"

    def _affirm_enhancement(self, gaps, palette_ctx):
        """Step 9: Optional accessory suggestion for affirm mode."""
        active_gaps = {k: v for k, v in gaps.items() if v}

        affirm_rec = {
            "rank": 1,
            "text": self._TEMPLATES["affirm"],
            "urgency": "subtle",
            "category": "affirm",
            "item_affected": "outfit",
            "reason": "Your outfit has excellent color harmony.",
            "target_garment": "outfit",
            "target_label": "outfit",
            "color_name": "",
            "color_hex": "",
            "color_lch": (0, 0, 0),
            "score_improvement": 0.0,
            "fills_gap": None,
        }

        if not active_gaps:
            return [affirm_rec]

        gap_filler = self._find_gap_filler(active_gaps, palette_ctx)
        recs = [affirm_rec]

        if gap_filler:
            text = self._TEMPLATES["affirm_add"].format(
                color=gap_filler["name"])
            recs.append({
                "rank": 2,
                "text": text,
                "urgency": "subtle",
                "category": "affirm_add",
                "item_affected": "accessories",
                "reason": f"A {gap_filler['name']} accessory would "
                          f"fill a small structural gap.",
                "target_garment": "accessories",
                "target_label": "accessories",
                "color_name": gap_filler["name"],
                "color_hex": gap_filler["hex"],
                "color_lch": gap_filler["lch"],
                "score_improvement": 0.0,
                "fills_gap": list(active_gaps.keys())[0],
            })

        return recs

    # =========================================================================
    # HELPERS
    # =========================================================================

    @staticmethod
    def _feedback_level(score: float) -> str:
        if score >= 80.0:  return "high"
        if score >= 60.0:  return "medium"
        return "low"

    @classmethod
    def _label(cls, zone_name: str) -> str:
        """Map a segmenter zone name to a human-readable garment label."""
        return cls._ITEM_LABELS.get(zone_name, zone_name.replace("_", " "))

    @staticmethod
    def _lch_to_lab(lch_tuple):
        """Convert (L, C, H) to {'L', 'a', 'b'} dict."""
        L, C, H = lch_tuple
        H_rad = np.radians(H)
        return {"L": L, "a": float(C * np.cos(H_rad)),
                "b": float(C * np.sin(H_rad))}

    @staticmethod
    def _temperature_sector(H):
        """Map a hue angle to warm/cool/neutral sector."""
        if (0 <= H < 90) or (330 <= H < 360):
            return "warm"
        elif 150 <= H < 290:
            return "cool"
        return "neutral"

    @staticmethod
    def _make_analysis_from_lch(lch_tuple):
        """Create a minimal analysis dict from an (L, C, H) tuple."""
        L, C, H = lch_tuple
        H_rad = np.radians(H)
        a = float(C * np.cos(H_rad))
        b = float(C * np.sin(H_rad))
        return {
            "lab": {"L": L, "a": a, "b": b},
            "lch": {"L": L, "C": C, "H": H},
            "rgb": [128, 128, 128],
            "hsv": {"H": H, "S": min(C / 85.0, 1.0), "V": L / 100.0},
        }

    @staticmethod
    def _gaps_to_issues(gaps):
        """Convert outfit_gaps dict to a list of issue label strings."""
        labels = {
            "needs_dark_anchor": "Missing Dark Anchor",
            "needs_light_anchor": "Missing Light Anchor",
            "needs_chromatic_accent": "Missing Chromatic Accent",
            "needs_neutral": "Missing Neutral",
            "needs_L_graduation": "Flat Lightness Range",
        }
        return [labels[k] for k, v in gaps.items() if v and k in labels]

    @staticmethod
    def _check_gap_fill(lch_tuple, gaps):
        """Check if a color fills any active gap."""
        L, C, _ = lch_tuple
        if gaps.get("needs_dark_anchor") and L < 35:
            return "needs_dark_anchor"
        if gaps.get("needs_light_anchor") and L > 80:
            return "needs_light_anchor"
        if gaps.get("needs_chromatic_accent") and C > 20:
            return "needs_chromatic_accent"
        if gaps.get("needs_neutral") and C < 12:
            return "needs_neutral"
        if gaps.get("needs_L_graduation"):
            return "needs_L_graduation"
        return None

    def _find_gap_filler(self, active_gaps, palette_ctx):
        """Find a palette color that fills the primary gap."""
        temperature = palette_ctx.get("temperature", "neutral")
        family = palette_ctx.get("family", "mixed")

        if active_gaps.get("needs_dark_anchor"):
            target_L = (0, 35)
            target_C = (0, 200)
        elif active_gaps.get("needs_light_anchor"):
            target_L = (80, 100)
            target_C = (0, 200)
        elif active_gaps.get("needs_chromatic_accent"):
            target_L = (30, 80)
            target_C = (20, 200)
        elif active_gaps.get("needs_neutral"):
            target_L = (30, 85)
            target_C = (0, 12)
        else:
            return None

        best = None
        best_sc = -1.0
        for color in self._CURATED_PALETTE:
            L, C, _ = color["lch"]
            if not (target_L[0] <= L <= target_L[1]):
                continue
            if not (target_C[0] <= C <= target_C[1]):
                continue
            t_match = 1.0 if color["temperature"] == temperature else 0.5
            f_match = 1.0 if color["family"] in (
                "achromatic", "cool_neutral", "warm_neutral", family) else 0.3
            sc = t_match * f_match
            if sc > best_sc:
                best_sc = sc
                best = color

        return best

    @staticmethod
    def _build_reason(candidate, mode):
        """Build a human-readable reason string for a recommendation."""
        imp = candidate["score_improvement"]
        gap = candidate.get("fills_gap")

        if mode == "repair":
            base = f"This change would improve harmony by ~{imp:.0f} points"
        else:
            base = f"This subtle change adds ~{imp:.0f} points of harmony"

        if gap:
            gap_reasons = {
                "needs_dark_anchor":
                    " and adds a grounding dark element",
                "needs_light_anchor":
                    " and introduces a brightening light piece",
                "needs_chromatic_accent":
                    " and adds needed color interest",
                "needs_neutral":
                    " and brings in a calming neutral",
                "needs_L_graduation":
                    " and creates a smoother lightness gradient",
            }
            base += gap_reasons.get(gap, "")

        return base + "."

    def _palette_suggestions(self, ranked_or_recs):
        """Build palette suggestion list from ranked candidates."""
        suggestions = []
        seen = set()
        for c in ranked_or_recs:
            name = c.get("color_name", "")
            if not name or name in seen:
                continue
            seen.add(name)
            hex_val = c.get("color_hex", "")
            rgb_val = c.get("color_rgb")
            lch_val = c.get("color_lch", (0, 0, 0))
            gap = c.get("fills_gap")

            if gap and "neutral" in str(gap):
                role = "anchor"
            elif gap and "chromatic" in str(gap):
                role = "accent"
            elif lch_val[1] < 12:
                role = "anchor"
            else:
                role = "accent"

            if rgb_val is None:
                for p in self._CURATED_PALETTE:
                    if p["name"] == name:
                        rgb_val = p["rgb"]
                        break
                if rgb_val is None:
                    rgb_val = [128, 128, 128]

            suggestions.append({
                "name": name, "hex": hex_val,
                "rgb":  rgb_val, "role": role,
            })
            if len(suggestions) >= 4:
                break

        return suggestions

    def _empty_report(self, score):
        """Fallback report for outfits with fewer than 2 items."""
        return {
            "score": round(score, 1),
            "feedback_level": self._feedback_level(score),
            "mode": "affirm" if score >= 78 else (
                "refine" if score >= 58 else "repair"),
            "outfit_context": {},
            "issues_detected": [],
            "recommendations": [],
            "palette_suggestions": [],
        }

class ClothingColorHarmonyAnalyzer:
    """
    End-to-end clothing colour harmony analysis with v2 robustness improvements.

    Usage
    ─────
        analyzer = ClothingColorHarmonyAnalyzer()
        result   = analyzer.analyze('/content/drive/MyDrive/outfit.jpg')

    Output schema
    ─────────────
        {
          "image":              str,
          "items":              [ {name, color, area_pixels, area_ratio,
                                   color_info, dominant_colors, quality}, … ],
          "score":              float,         # calibrated 0-100
          "raw_score":          float,         # pre-calibration 0-100
          "mean_quality":       float,         # 0-1 data quality
          "details":            {rule: score_pct, …},
          "interpretation":     str,
          "rule_breakdown":     {rule: {raw_score, weight, contribution}, …},
        }
    """

    def __init__(self, n_colors_per_item=3, harmony_weights=None,
                 model_path=None, conf_thresh=None,
                 baseline_imperfection: float = 3.5,   # v4.1: tunable
                 verbose: bool = True,
                 render: bool = True):
        self._verbose = verbose
        self._render  = render

        if self._verbose:
            print("=" * 64)
            print("   Clothing Color Harmony Analyzer  v9.0")
            print("   Soft Harmony · Visual Balance · Perception Phase 2  ·  YOLOv8-seg")
            print("=" * 64)

        self.segmenter   = ClothingSegmenter(model_path=model_path,
                                             conf_thresh=conf_thresh,
                                             verbose=self._verbose)
        self.skin_det    = SkinDetector()
        self.extractor   = ColorExtractor(n_colors=n_colors_per_item,
                                          verbose=self._verbose)
        self.converter   = ColorConverter()
        self.area_calc   = AreaCalculator()
        self.rules       = ColorHarmonyRules()
        # v5.0: new context-awareness modules
        self.coverage_assessor = SegmentationCoverageAssessor()
        self.outfit_classifier = OutfitTypeClassifier()
        # v4.1: baseline_imperfection is now surfaced here so the parameter
        # can be tuned in one place without touching internal modules.
        self.aggregator  = HarmonyScoreAggregator(
            weights=harmony_weights,
            baseline_imperfection=baseline_imperfection,
        )
        self.visualizer   = HarmonyVisualizer()
        self.recommender  = FashionRecommendationEngine()
        self.perception   = PerceptionModifier()     # v8.0: soft harmony & balance
        if self._verbose:
            print(f"[Analyzer] baseline_imperfection = {baseline_imperfection} pts")
            print("[Analyzer] All modules initialised.\n")

    # ── Image Loading ─────────────────────────────────────────────────────────

    def load_image(self, path_or_array, max_dim=800):
        """Load image from file path or accept a numpy array directly."""
        if isinstance(path_or_array, np.ndarray):
            # Direct numpy array input — ensure uint8 RGB H×W×3
            img_arr = path_or_array
            if img_arr.ndim == 2:
                img_arr = np.stack([img_arr]*3, axis=-1)
            if img_arr.dtype != np.uint8:
                img_arr = img_arr.astype(np.uint8)
            h, w = img_arr.shape[:2]
            if max(w, h) > max_dim:
                scale = max_dim / max(w, h)
                new_w, new_h = int(w * scale), int(h * scale)
                pil_img = Image.fromarray(img_arr).resize(
                    (new_w, new_h), Image.LANCZOS)
                if self._verbose:
                    print(f"[Loader] Resized: {w}×{h} → {new_w}×{new_h}")
                return np.array(pil_img)
            return img_arr
        # File path input
        img = Image.open(path_or_array).convert("RGB")
        w, h = img.size
        if max(w, h) > max_dim:
            scale = max_dim / max(w, h)
            img   = img.resize((int(w*scale), int(h*scale)), Image.LANCZOS)
            if self._verbose:
                print(f"[Loader] Resized: {w}×{h} → {img.size[0]}×{img.size[1]}")
        return np.array(img)

    # ── Single Image Analysis ─────────────────────────────────────────────────

    def analyze(self, image_path, save_figure=False, show_figure=False,
                save_debug=False, save_recommendations=False):
        """
        Run the complete v2 pipeline on one image.

        Args:
            image_path:   Path to input image, or H×W×3 uint8 numpy array.
            save_figure:  Save analysis PNG alongside the input.
            show_figure:  Display inline (Colab / Jupyter).
            save_debug:   Also save a debug grid showing intermediate steps.
        """
        # Ensure sub-modules verbose state matches the analyzer's verbose state
        if hasattr(self, "segmenter") and hasattr(self.segmenter, "_verbose"):
            self.segmenter._verbose = self._verbose
        if hasattr(self, "extractor") and hasattr(self.extractor, "_verbose"):
            self.extractor._verbose = self._verbose

        # Resolve input label for logging / JSON output
        _input_label = image_path if isinstance(image_path, str) else "<numpy_array>"

        if self._verbose:
            print(f"\n{'─'*64}")
            print(f"[Pipeline] {_input_label}")
            print(f"{'─'*64}")

        # ── 1 / Load ──────────────────────────────────────────────────────────
        image_rgb = self.load_image(image_path)
        if self._verbose:
            print(f"[1/9] Loaded  {image_rgb.shape[1]}×{image_rgb.shape[0]} px")

        # ── 2 / Skin Detection ────────────────────────────────────────────────
        if self._verbose:
            print("[2/9] Detecting skin pixels …")
        skin_mask = self.skin_det.detect(image_rgb)
        skin_pct  = skin_mask.sum() / skin_mask.size * 100
        if self._verbose:
            print(f"      Skin pixels: {int(skin_mask.sum()):,}  ({skin_pct:.1f}% of image)")

        # ── 3 / Segmentation ──────────────────────────────────────────────────
        if self._verbose:
            print("[3/9] Segmenting clothing regions …")
        seg      = self.segmenter.segment(image_rgb, skin_mask)
        clothing = seg["clothing_items"]

        if not clothing:
            if self._verbose:
                print("[!] No clothing items detected.")
            return {"error": "no clothing items detected", "image": _input_label}

        # ── 3b / Coverage Assessment (v5.0) ───────────────────────────────────
        if self._verbose:
            print("[3b] Assessing segmentation coverage …")
        coverage_report = self.coverage_assessor.assess(clothing, seg["person_mask"])
        if self._verbose:
            print(f"      Items detected: {coverage_report['n_detected']}  "
                  f"Coverage: {coverage_report['coverage_ratio']*100:.0f}%  "
                  f"Confidence: {coverage_report['confidence']*100:.0f}%  "
                  f"Partial: {coverage_report['is_partial']}")
            for flag in coverage_report["flags"]:
                print(f"      ⚠  {flag}")

        # ── 4 / Color Extraction (skin + noise free) ──────────────────────────
        if self._verbose:
            print("[4/9] Extracting clean dominant colours …")
        item_extractions = {}
        for name, mask in clothing.items():
            if self._verbose:
                print(f"      ── {name} ──")
            ex = self.extractor.extract(image_rgb, mask,
                                        pre_skin_mask=skin_mask)
            item_extractions[name] = ex
            primary = ex["colors"][0]["rgb"]
            if self._verbose:
                print(f"         primary RGB {primary}  quality={ex['quality']:.2f}")

        # ── 5 / Color Space Conversion ────────────────────────────────────────
        if self._verbose:
            print("[5/9] Converting to LAB / LCH / HSV …")
        color_analyses = {}
        analysis_list  = []
        quality_list   = []

        for name, ex in item_extractions.items():
            rgb      = self.extractor.primary(ex)
            analysis = self.converter.full(rgb)
            color_analyses[name] = analysis
            analysis_list.append(analysis)
            quality_list.append(ex["quality"])
            if self._verbose:
                lch = analysis["lch"]
                print(f"      {name:<18} L*={lch['L']:5.1f}  C*={lch['C']:5.1f}  "
                      f"H={lch['H']:6.1f}°  Q={ex['quality']:.2f}")

        mean_quality = float(np.mean(quality_list)) if quality_list else 1.0

        # ── 5b / Outfit Type Classification (v5.0) ────────────────────────────
        if self._verbose:
            print("[5b] Classifying outfit type …")
        mono_for_type = self.rules._monochrome_style(analysis_list)
        outfit_type   = self.outfit_classifier.classify(
            clothing, color_analyses, mono_for_type
        )
        outfit_desc   = OutfitTypeClassifier.describe(outfit_type)
        if self._verbose:
            print(f"      Outfit type: {outfit_type}  ({outfit_desc})")
            print("[6/9] Computing areas …")
        area_info   = self.area_calc.compute(clothing)
        area_ratios = [area_info[n]["ratio"] for n in clothing]

        # ── v9: Compute palette context (CCPA) ───────────────────────────
        palette_ctx = self.rules._compute_palette_context(
            analysis_list, area_ratios)
        if self._verbose:
            print(f"      soft_strength: {palette_ctx['soft_strength']:.3f}")
            print(f"      family: {palette_ctx['family']}"
                  f"  temp: {palette_ctx['temperature']}")
            if palette_ctx.get('confusion_triggered'):
                print(f"      CONFUSION GUARD: "
                      f"{palette_ctx['confused_pairs']} confused pairs")

        # ── 7 / Harmony Rules ─────────────────────────────────────────────────
        if self._verbose:
            print("[7/9] Applying harmony rules …")
        rule_scores = {
            # v7.0: area_ratios + visual weights + hero logic active in all 3 rules
            "hue_score":        self.rules.hue_harmony(
                                    analysis_list, quality_list, area_ratios),
            "lightness_score":  self.rules.lightness_balance(
                                    analysis_list, quality_list, area_ratios),
            "chroma_score":     self.rules.chroma_balance(
                                    analysis_list, area_ratios, quality_list),
            "achromatic_score": self.rules.achromatic_anchor(
                                    analysis_list, quality_list,
                                    outfit_type=outfit_type,
                                    palette_ctx=palette_ctx),
            "contrast_score":   self.rules.contrast_harmony(
                                    analysis_list, quality_list, area_ratios,
                                    palette_ctx=palette_ctx),
        }
        if self._verbose:
            for rule, score in rule_scores.items():
                bar = "█"*int(score*20) + "░"*(20-int(score*20))
                print(f"      {rule:<22} [{bar}] {score*100:5.1f}%")

        # ── 7b / Perception Modifiers (v8.0) ──────────────────────────────────
        # Applied after rules, before aggregation. Adjusts scores for
        # soft palettes, smooth hue transitions, and visual balance.
        rule_scores, perception_info = self.perception.adjust(
            rule_scores, analysis_list, area_ratios, mono_for_type,
            palette_ctx=palette_ctx)
        if self._verbose and perception_info:
            print("      [Perception modifiers applied]")
            for mod_name, mod_data in perception_info.items():
                boosts = {k: v for k, v in mod_data.items()
                          if k.endswith("boost") and v > 0}
                print(f"        ↳ {mod_name}: {boosts}")
            print("      [Adjusted scores]")
            for rule, score in rule_scores.items():
                bar = "█"*int(score*20) + "░"*(20-int(score*20))
                print(f"      {rule:<22} [{bar}] {score*100:5.1f}%")

        # ── v9: Graduation bonus ──────────────────────────────────────────
        if palette_ctx and not palette_ctx.get('confusion_triggered', False):
            grad_bonus = 0.06 * palette_ctx.get('graduation_score', 0)
            rule_scores['lightness_score'] = min(
                0.88, rule_scores['lightness_score'] + grad_bonus)
            if self._verbose and grad_bonus > 0.001:
                print(f"      [Graduation bonus] "
                      f"+{grad_bonus*100:.2f}% to lightness_score")

        # ── 8 / Final Score ───────────────────────────────────────────────────
        if self._verbose:
            print("[8/9] Computing calibrated final score …")
        # v5.0: coverage_report feeds the uncertainty penalty into calibration
        final = self.aggregator.compute(rule_scores, mean_quality,
                                        coverage_report=coverage_report)
        if self._verbose:
            cov_pen = final["calibration_params"].get("coverage_penalty", 0.0)
            print(f"\n  ▶  RAW SCORE:        {final['raw_score_percent']:5.1f} %")
            print(f"  ▶  CALIBRATED SCORE: {final['final_score_percent']:5.1f} %"
                  + (f"  (incl. {cov_pen:.1f}pt coverage penalty)" if cov_pen else ""))
            print(f"  ▶  DATA QUALITY:     {mean_quality*100:5.1f} %")
            print(f"  ▶  OUTFIT TYPE:      {outfit_type}  ({outfit_desc})")
            print(f"  ▶  {final['interpretation']}\n")

        # ── 9 / Visualise ─────────────────────────────────────────────────────
        if self._render:
            if self._verbose:
                print("[9/9] Rendering visualization …")
            fig = self.visualizer.render(
                image_rgb, seg, item_extractions, color_analyses, final)

            stem = Path(image_path).stem if isinstance(image_path, str) else "analysis"
            if save_figure:
                out = stem + "_harmony_v4.png"
                fig.savefig(out, dpi=150, bbox_inches="tight",
                            facecolor=self.visualizer._BG)
                if self._verbose:
                    print(f"[Output] Saved → {out}")

            if save_debug:
                self._save_debug(image_rgb, seg, skin_mask, stem)

            if show_figure:
                plt.show()
            else:
                plt.close(fig)

        # ── JSON Output ───────────────────────────────────────────────────────
        result = {
            "image":        _input_label,
            "items": [
                {
                    "name":           name,
                    "color":          color_analyses[name]["rgb"],
                    "area_pixels":    area_info[name]["pixel_count"],
                    "area_ratio":     area_info[name]["ratio"],
                    "quality":        item_extractions[name]["quality"],
                    "clean_px":       item_extractions[name]["clean_px"],
                    "low_confidence": item_extractions[name].get("low_confidence", False),
                    "color_info": {
                        "hsv": color_analyses[name]["hsv"],
                        "lab": color_analyses[name]["lab"],
                        "lch": color_analyses[name]["lch"],
                    },
                    "dominant_colors": item_extractions[name]["colors"],
                }
                for name in clothing
            ],
            "score":          final["final_score_percent"],
            "raw_score":      final["raw_score_percent"],
            "mean_quality":   mean_quality,
            "outfit_type":    outfit_type,           # v5.0
            "outfit_desc":    outfit_desc,            # v5.0
            "coverage":       coverage_report,        # v5.0
            "monochrome_style": self.rules._monochrome_style(analysis_list),
            "perception_modifiers": perception_info,
            "details":        {r: round(v["raw_score"]*100, 1)
                               for r, v in final["rule_breakdown"].items()},
            "interpretation": final["interpretation"],
            "rule_breakdown": final["rule_breakdown"],
            "palette_ctx":    palette_ctx,
        }

        # ── Recommendation Engine (NEW in v2.2) ───────────────────────────────
        if self._verbose:
            print("[Rec] Generating fashion recommendations …")
        rec_report = self.recommender.build_report(result)
        result["recommendations"] = rec_report

        # Print summary to console
        if self._verbose:
            level_sym = {"high": "✨", "medium": "💡", "low": "⚠ "}.get(
                rec_report["feedback_level"], "·")
            print(f"\n  {level_sym}  Feedback level: {rec_report['feedback_level'].upper()}")
            if rec_report["issues_detected"]:
                print(f"  Issues found:   {', '.join(rec_report['issues_detected'])}")
            for r in rec_report["recommendations"]:
                print(f"  #{r['rank']} [{r['urgency']:>9s}] {r['text'][:72]}")

        # Render and optionally save the recommendation card
        if self._render and save_recommendations:
            rec_fig  = self.visualizer.render_recommendations(rec_report)
            rec_stem = (Path(image_path).stem if isinstance(image_path, str) else "analysis") + "_recommendations.png"
            if save_figure:
                rec_fig.savefig(rec_stem, dpi=150, bbox_inches="tight",
                                facecolor=self.visualizer._BG)
                if self._verbose:
                    print(f"[Rec] Recommendations saved → {rec_stem}")
            if show_figure:
                plt.show()
            else:
                plt.close(rec_fig)

        return result

    # ── Production API Entry Point ────────────────────────────────────────────

    def analyze_image(self, image_path, mode="production"):
        """
        Clean callable entry point for production / API usage.

        Args:
            image_path:  Path to input image.
            mode:        "production" — no prints, no rendering, returns clean dict.
                         "debug"     — full prints + rendering (delegates to analyze()).

        Returns:
            Structured dict suitable for JSON serialization:
            {
                "score": float,
                "raw_score": float,
                "feedback_level": str,
                "interpretation": str,
                "outfit_type": str,
                "items": [ { "name", "color_rgb", "area_ratio", "lch" } ],
                "recommendation": {
                    "mode": str,
                    "issues_detected": [str],
                    "suggestions": [ { "rank", "text", "urgency", "reason" } ],
                    "palette_suggestions": [ { "name", "hex", "rgb", "role" } ]
                }
            }
        """
        if mode == "debug":
            return self.analyze(image_path, save_figure=True,
                                show_figure=True, save_recommendations=True)

        # Production mode: suppress prints and rendering temporarily
        prev_verbose, prev_render = self._verbose, self._render
        self._verbose = False
        self._render  = False
        try:
            full_result = self.analyze(
                image_path,
                save_figure=False,
                show_figure=False,
                save_recommendations=False,
            )
        finally:
            # Always restore original state
            self._verbose = prev_verbose
            self._render  = prev_render

        # Check for error case (no clothing detected)
        if "error" in full_result:
            return full_result

        # Build clean API response
        rec_report = full_result.get("recommendations", {})

        api_items = []
        for item in full_result.get("items", []):
            api_items.append({
                "name":      item["name"],
                "color_rgb": item["color"],
                "area_ratio": round(item["area_ratio"], 4),
                "lch": item.get("color_info", {}).get("lch", {}),
            })

        api_suggestions = []
        for r in rec_report.get("recommendations", []):
            api_suggestions.append({
                "rank":    r.get("rank"),
                "text":    r.get("text", ""),
                "urgency": r.get("urgency", ""),
                "reason":  r.get("reason", ""),
            })

        return {
            "score":           round(full_result["score"], 1),
            "raw_score":       round(full_result["raw_score"], 1),
            "feedback_level":  rec_report.get("feedback_level", "medium"),
            "interpretation":  full_result.get("interpretation", ""),
            "outfit_type":     full_result.get("outfit_type", ""),
            "items":           api_items,
            "recommendation": {
                "mode":              rec_report.get("mode", ""),
                "issues_detected":   rec_report.get("issues_detected", []),
                "suggestions":       api_suggestions,
                "palette_suggestions": rec_report.get("palette_suggestions", []),
            },
        }

    # ── Debug Export ──────────────────────────────────────────────────────────

    def _save_debug(self, image_rgb, seg, skin_mask, stem):
        """Save a 2-row debug grid showing all intermediate masks."""
        items   = seg["clothing_items"]
        n       = len(items) + 2
        fig, ax = plt.subplots(2, max(n, 3), figsize=(5*max(n,3), 8),
                                facecolor="#0d0d1a")
        for a in ax.flat: a.axis("off"); a.set_facecolor("#0d0d1a")

        def _show(a, img, ttl):
            a.imshow(img); a.set_title(ttl, color="white", fontsize=8)

        _show(ax[0,0], image_rgb, "Original")
        _show(ax[0,1],
              (skin_mask[:,:,None]*np.array([220,80,80])).clip(0,255).astype(np.uint8),
              "Skin Mask")
        pm = seg["person_mask"]
        _show(ax[0,2],
              (pm[:,:,None]*np.array([80,200,80])).clip(0,255).astype(np.uint8),
              "Person Mask")

        for i, (name, mask) in enumerate(items.items()):
            col = [(i*80)%255, (100+i*60)%255, (200-i*40)%255]
            vis = (mask[:,:,None]*np.array(col)).clip(0,255).astype(np.uint8)
            _show(ax[1, i], vis, name)

        out = stem + "_debug.png"
        fig.savefig(out, dpi=120, bbox_inches="tight", facecolor="#0d0d1a")
        plt.close(fig)
        if self._verbose:
            print(f"[Debug] Saved → {out}")

    # ── Batch Analysis ────────────────────────────────────────────────────────

    def analyze_batch(self, image_paths, save_figures=True):
        results = []
        for path in image_paths:
            try:
                r = self.analyze(path, save_figure=save_figures,
                                 show_figure=True)
                results.append(r)
            except Exception as e:
                if self._verbose:
                    print(f"[Error] {path}: {e}")
                results.append({"error": str(e), "image": path})
        if self._verbose:
            self._leaderboard(results)
        return results

    @staticmethod
    def _leaderboard(results):
        valid = sorted([r for r in results if "score" in r],
                       key=lambda r: r["score"], reverse=True)
        print("\n" + "═"*64)
        print("   OUTFIT RANKING  (calibrated scores)")
        print("═"*64)
        for i, r in enumerate(valid, 1):
            name  = Path(r["image"]).name
            s     = r["score"]; raw = r.get("raw_score", s)
            bar   = "█"*int(s/5) + "░"*(20-int(s/5))
            stars = "★"*int(round(s/20))
            print(f"  #{i}  [{bar}] {s:5.1f}%  (raw {raw:.1f}%)  {stars}  {name}")
        print("═"*64)


# =============================================================================
# PHASE 0: VALIDATION HARNESS
# =============================================================================

def _make_analysis(lch_tuple):
    """Constructs a synthetic analysis dict bypassing YOLO and ColorExtractor."""
    L, C, H = lch_tuple
    H_rad = np.radians(H)
    a = C * np.cos(H_rad)
    b = C * np.sin(H_rad)
    rgb = [128, 128, 128]  # Placeholder, not used for scoring
    return {
        'lab': {'L': L, 'a': a, 'b': b},
        'lch': {'L': L, 'C': C, 'H': H},
        'rgb': rgb,
        'hsv': {'H': H, 'S': min(C/85.0, 1.0), 'V': L/100.0},
    }

def score_lch_outfit(lch_list, area_ratios, outfit_type=None):
    """Runs the scoring pipeline directly on LCH values."""
    rules = ColorHarmonyRules()
    perception = PerceptionModifier()
    aggregator = HarmonyScoreAggregator()
    
    analyses = [_make_analysis(lch) for lch in lch_list]
    mono = rules._monochrome_style(analyses)
    
    # Phase 1: compute palette context
    palette_ctx = None
    if hasattr(rules, '_compute_palette_context'):
        palette_ctx = rules._compute_palette_context(analyses, area_ratios)
    
    rule_scores = {
        'hue_score': rules.hue_harmony(analyses, area_ratios=area_ratios),
        'lightness_score': rules.lightness_balance(analyses, area_ratios=area_ratios),
        'chroma_score': rules.chroma_balance(analyses, area_ratios),
        # Phase 2.2: achromatic_anchor now accepts palette_ctx
        'achromatic_score': rules.achromatic_anchor(analyses, outfit_type=outfit_type, palette_ctx=palette_ctx),
        # Phase 2.1: contrast_harmony now accepts palette_ctx
        'contrast_score': rules.contrast_harmony(analyses, area_ratios=area_ratios, palette_ctx=palette_ctx),
    }
    
    # Phase 2.3: Modifiers now receive palette_ctx for CCPA-aware Modifier A
    rule_scores, _ = perception.adjust(rule_scores, analyses, area_ratios, mono,
                                       palette_ctx=palette_ctx)
    
    # Phase 2.6: Graduation bonus (before aggregation)
    if palette_ctx and not palette_ctx.get('confusion_triggered', False):
        grad_bonus = 0.06 * palette_ctx.get('graduation_score', 0)
        rule_scores['lightness_score'] = min(
            0.88, rule_scores['lightness_score'] + grad_bonus)
    
    result = aggregator.compute(rule_scores, mean_quality=1.0)
    return result

VALIDATION_CASES = [
    {
        'id': 'case_01',
        'name': 'Canonical Soft Elegant Earth',
        'items': [
            ((91, 9, 83), 0.35),   # Cream top
            ((73, 16, 76), 0.40),  # Beige jacket
            ((52, 22, 98), 0.25),  # Olive trousers
        ],
        'expected': (78, 86),
        'category': 'soft_elegant',
    },
    {
        'id': 'case_02',
        'name': 'Boring Gray Monotone',
        'items': [
            ((74, 2, 210), 0.40),  # Light gray shirt
            ((60, 2, 210), 0.60),  # Medium gray pants
        ],
        'expected': (50, 62),
        'category': 'boring_washed',
    },
    {
        'id': 'case_03',
        'name': 'High Contrast Neutral Elegant',
        'items': [
            ((95, 2, 90), 0.30),   # White shirt
            ((26, 3, 250), 0.45),  # Charcoal jacket
            ((28, 28, 260), 0.25), # Navy trousers
        ],
        'expected': (80, 87),
        'category': 'bold_regression',
    },
    {
        'id': 'case_04',
        'name': 'Saturation Chaos',
        'items': [
            ((55, 68, 350), 0.35), # Hot pink top
            ((82, 72, 87), 0.40),  # Electric yellow pants
            ((62, 62, 45), 0.25),  # Bright orange jacket
        ],
        'expected': (28, 45),
        'category': 'bold_regression',
    },
    {
        'id': 'case_05',
        'name': 'Tonal Gradient',
        'items': [
            ((93, 6, 88), 0.30),   # Ivory top
            ((87, 8, 85), 0.35),   # Warm white blazer
            ((72, 18, 73), 0.25),  # Light camel trousers
            ((68, 16, 74), 0.10),  # Beige shoes
        ],
        'expected': (75, 83),
        'category': 'soft_elegant',
    },
    {
        'id': 'case_06',
        'name': 'Bold Intentional Complementary',
        'items': [
            ((42, 58, 260), 0.40), # Cobalt blazer
            ((95, 2, 90), 0.30),   # White shirt
            ((48, 42, 30), 0.30),  # Burnt orange trousers
        ],
        'expected': (72, 81),
        'category': 'bold_regression',
    },
    {
        'id': 'case_07',
        'name': 'Temperature Chaos',
        'items': [
            ((60, 44, 20), 0.35),  # Coral top
            ((42, 55, 260), 0.40), # Cobalt jacket
            ((58, 18, 118), 0.25), # Sage trousers
        ],
        'expected': (38, 54),
        'category': 'boring_washed',
    },
    {
        'id': 'case_08',
        'name': 'Monochrome Elegant',
        'items': [
            ((96, 2, 0), 0.30),    # White shirt
            ((72, 2, 0), 0.30),    # Light gray trousers
            ((28, 3, 250), 0.30),  # Charcoal blazer
            ((10, 2, 0), 0.10),    # Black shoes
        ],
        'expected': (80, 87),
        'category': 'monochrome',
    },
    {
        'id': 'case_09',
        'name': 'Washed Pastel Scatter',
        'items': [
            ((84, 12, 15), 0.35),  # Baby pink top
            ((79, 14, 295), 0.40), # Lavender pants
            ((80, 13, 158), 0.25), # Dusty mint jacket
        ],
        'expected': (40, 55),
        'category': 'adversarial_trap',
    },
    {
        'id': 'case_10',
        'name': 'Earthy Warm Editorial',
        'items': [
            ((40, 38, 28), 0.40),  # Dark rust jacket
            ((93, 6, 88), 0.30),   # Ivory shirt
            ((50, 25, 95), 0.30),  # Olive cargo pants
        ],
        'expected': (74, 82),
        'category': 'soft_elegant',
    },
    {
        'id': 'case_11',
        'name': 'Classic Statement Piece',
        'items': [
            ((28, 28, 260), 0.40), # Navy blazer
            ((95, 2, 90), 0.30),   # White shirt
            ((35, 3, 240), 0.30),  # Dark gray trousers
        ],
        'expected': (80, 87),
        'category': 'statement_piece',
    },
    {
        'id': 'case_12',
        'name': 'Near-Boundary Cliff Test',
        'items': [
            ((58, 24, 98), 0.35),  # Dusty olive top
            ((64, 18, 80), 0.40),  # Warm taupe pants
            ((70, 20, 74), 0.25),  # Tan shoes
        ],
        'expected': (70, 79),
        'category': 'boundary_cliff',
    },
    {
        'id': 'case_13',
        'name': 'Identical Khaki Trap',
        'items': [
            ((65, 20, 85), 0.35),  # Khaki top
            ((63, 19, 84), 0.40),  # Khaki pants
            ((67, 21, 86), 0.25),  # Khaki shoes
        ],
        'expected': (38, 52),
        'category': 'adversarial_trap',
    },
    {
        'id': 'case_14',
        'name': 'Vivid Monochrome Red',
        'items': [
            ((35, 45, 18), 0.40),  # Dark red blazer
            ((52, 48, 28), 0.30),  # Red-orange top
            ((42, 52, 22), 0.30),  # Vivid red trousers
        ],
        'expected': (69, 77),
        'category': 'boundary_cliff',
    },
    {
        'id': 'case_15',
        'name': 'Complementary Clash',
        'items': [
            ((58, 55, 148), 0.50), # Bright green top
            ((45, 52, 22), 0.50),  # Bright red pants
        ],
        'expected': (30, 46),
        'category': 'bold_regression',
    },
    {
        'id': 'case_16',
        'name': 'Temperature Split Mixed Signal',
        'items': [
            ((78, 35, 82), 0.35),  # Light mustard top
            ((45, 22, 255), 0.40), # Stone-washed navy pants
            ((90, 5, 88), 0.25),   # Off-white shoes
        ],
        'expected': (48, 62),
        'category': 'boundary_cliff',
    },
    {
        'id': 'case_17',
        'name': 'Dark Academia Editorial',
        'items': [
            ((32, 28, 12), 0.40),  # Dark burgundy jacket
            ((10, 2, 0), 0.30),    # Black turtleneck
            ((26, 3, 250), 0.20),  # Dark charcoal trousers
            ((28, 25, 15), 0.10),  # Dark oxblood shoes
        ],
        'expected': (68, 77),
        'category': 'soft_elegant',
    },
    {
        'id': 'case_18',
        'name': 'Recommendation Worst-Item Test',
        'items': [
            ((91, 9, 83), 0.35),   # Cream top
            ((88, 7, 85), 0.40),   # Ivory pants
            ((42, 58, 260), 0.25), # Cobalt shoes
        ],
        'expected': (48, 60),
        'category': 'recommendation_test',
    },
    {
        'id': 'case_19',
        'name': 'Style Identity Preservation Test',
        'items': [
            ((60, 18, 118), 0.35), # Dusty sage top
            ((70, 15, 80), 0.40),  # Warm stone pants
            ((91, 8, 85), 0.25),   # Cream shoes
        ],
        'expected': (78, 86),
        'category': 'recommendation_test',
    },
    {
        'id': 'case_20',
        'name': 'Busy Beige False Neutral',
        'items': [
            ((80, 12, 78), 0.35),  # Beige top
            ((76, 14, 82), 0.40),  # Slightly warmer beige pants
            ((78, 13, 74), 0.25),  # Slightly cooler beige jacket
        ],
        'expected': (40, 55),
        'category': 'adversarial_trap',
    },
    {
        'id': 'case_21',
        'name': 'Muted Temperature-Incoherent',
        'items': [
            ((67, 22, 15), 0.35),  # Dusty rose top
            ((52, 20, 245), 0.40), # Slate blue pants
            ((70, 12, 78), 0.25),  # Warm stone jacket
        ],
        'expected': (45, 58),
        'category': 'adversarial_trap',
    },
    {
        'id': 'case_22',
        'name': 'Tonal Dark Elegant',
        'items': [
            ((30, 3, 250), 0.40),  # Charcoal blazer
            ((28, 22, 260), 0.35), # Dark navy trousers
            ((10, 2, 0), 0.10),    # Black shoes
            ((42, 3, 240), 0.15),  # Dark gray shirt
        ],
        'expected': (70, 78),
        'category': 'monochrome',
    },
    {
        'id': 'case_23',
        'name': 'Recommendation Family Constraint Test',
        'items': [
            ((52, 38, 30), 0.35),  # Warm terracotta top
            ((91, 8, 85), 0.40),   # Cream pants
            ((65, 28, 70), 0.25),  # Camel shoes
        ],
        'expected': (72, 80),
        'category': 'recommendation_test',
    },
]

DISCRIMINATION_GAPS = [
    ('case_01', 'case_02', 14.0, 'Elegant vs Boring'),
    ('case_01', 'case_09', 18.0, 'Elegant vs Washed Pastel'),
    ('case_01', 'case_20', 23.0, 'Elegant vs Identical Blob'),
    ('case_01', 'case_21', 20.0, 'Elegant vs Temp-Incoherent'),
]

def perturbation_test(case_id):
    """Tests the stability of a case against LCH perturbations (+/- 3 units)."""
    case = next(c for c in VALIDATION_CASES if c['id'] == case_id)
    base_lch_list = [item[0] for item in case['items']]
    area_ratios = [item[1] for item in case['items']]
    
    base_score = score_lch_outfit(base_lch_list, area_ratios)['final_score_percent']
    
    shifts = [-3, 3]
    max_diff = 0
    
    for item_idx in range(len(base_lch_list)):
        for channel_idx in range(3):
            for shift in shifts:
                test_lch = list(base_lch_list[item_idx])
                test_lch[channel_idx] = max(0, test_lch[channel_idx] + shift) # simplistic, H handles 360 later if needed
                
                test_lch_list = list(base_lch_list)
                test_lch_list[item_idx] = tuple(test_lch)
                
                test_score = score_lch_outfit(test_lch_list, area_ratios)['final_score_percent']
                diff = abs(test_score - base_score)
                if diff > max_diff:
                    max_diff = diff
                    
    passed = max_diff <= 4.0
    status = '✅ PASS' if passed else '❌ FAIL'
    print(f"  {status}  PERTURBATION {case_id}: Max diff {max_diff:.1f} pts (limit 4.0)")
    return passed

def run_validation_suite():
    """Executes the full benchmark and displays baseline results."""
    print("\n" + "="*70)
    print(" COLOR-MATE V9 VALIDATION HARNESS (BASELINE)")
    print("="*70)
    
    results = []
    for case in VALIDATION_CASES:
        lch_list = [item[0] for item in case['items']]
        area_ratios = [item[1] for item in case['items']]
        result = score_lch_outfit(lch_list, area_ratios)
        score = result['final_score_percent']
        lo, hi = case['expected']
        
        # When establishing baseline, passing is not strict since it is v8 logic.
        passed = lo <= score <= hi
        
        results.append({
            'id': case['id'], 'name': case['name'],
            'score': score, 'expected': case['expected'],
            'passed': passed,
        })
        
        # Soft validation for baseline purposes (we just want to see the score)
        status = '✅ PASS' if passed else '⚠️ WARN' 
        print(f"  {status}  {case['id']:>8s}  {score:5.1f}  [{lo}-{hi}]  {case['name']}")
    
    print("\n  -- DISCRIMINATION GAPS --")
    score_map = {r['id']: r['score'] for r in results}
    for id_a, id_b, min_gap, label in DISCRIMINATION_GAPS:
        gap = score_map[id_a] - score_map[id_b]
        passed = gap >= min_gap
        status = '✅ PASS' if passed else '❌ FAIL'
        print(f"  {status}  GAP {label}: {gap:.1f} pts (need >= {min_gap})")
        
    print("\n  -- PERTURBATION TESTS --")
    perturbation_test('case_12')
    perturbation_test('case_14')
    perturbation_test('case_15')
    print("="*70 + "\n")


# =============================================================================
# ENTRY POINT
# =============================================================================

if __name__ == "__main__":

   print("ColorMate v10 backend module.")
   print("Import this module from your backend application.")

""" 
    ColorMate v10 - Clothing Color Harmony Analyzer

    This module is intended to be imported and used by a backend
    application (FastAPI, Flask, Django, etc.).

    Example:

        from clothing_color_harmony_v10_yolo import ClothingColorHarmonyAnalyzer

        analyzer = ClothingColorHarmonyAnalyzer(
            model_path="OutfitHarmony_HF_SafeRebuild_v1.pt"
        )

        result = analyzer.analyze(image_input)

    Supported image_input types:
        - str (image file path)
        - numpy.ndarray (decoded image)

    Required files:
        - clothing_color_harmony_v10_yolo.py
        - OutfitHarmony_HF_SafeRebuild_v1.pt

    Notes:
        - Works fully offline
        - Uses local segmentation model
        - No HuggingFace downloads
        - No automatic model downloads
        - Designed for local backend deployment
  """

    # from google.colab import drive; drive.mount('/content/drive')

    # IMAGE_PATH = "/content/drive/MyDrive/outfit.jpg"   # ← CHANGE THIS

    # analyzer = ClothingColorHarmonyAnalyzer(n_colors_per_item=3)
    # result   = analyzer.analyze(IMAGE_PATH, save_figure=True, save_debug=True,
    #                             save_recommendations=True)

    # print("\n── Harmony Score ──────────────────────────────────────────────────")
    # print(f"  Score:   {result['score']}%  ({result['interpretation']})")
    # print(f"  Quality: {result['mean_quality']*100:.0f}%")

    # print("\n── Recommendations ────────────────────────────────────────────────")
    # rec = result["recommendations"]
    # print(f"  Feedback level: {rec['feedback_level'].upper()}")
    # for r in rec["recommendations"]:
    #     print(f"\n  #{r['rank']} [{r['urgency']}] {r['category']}")
    #     print(f"     {r['text']}")
    #     print(f"     Why: {r['reason']}")
    # if rec["palette_suggestions"]:
    #     print("\n  Palette Suggestions:")
    #     for p in rec["palette_suggestions"]:
    #         print(f"     {p['name']:15s}  {p['hex']}  — {p['role']}")

    # print("\n── Full JSON Output ────────────────────────────────────────────────")
    # print(json.dumps(result, indent=2, default=str))

    # ── Batch example ─────────────────────────────────────────────────────────
    # results = analyzer.analyze_batch([
    #     "/content/drive/MyDrive/outfit_1.jpg",
    #     "/content/drive/MyDrive/outfit_2.jpg",
    # ])
