from fastapi import FastAPI
app = FastAPI()
_engine = None

def engine():
    global _engine
    if _engine is None:
        try:
            from rapidocr_onnxruntime import RapidOCR
            _engine = RapidOCR()
        except Exception as e:
            _engine = f"unavailable: {e}"
    return _engine

@app.get("/health")
def health():
    return {"ok": True}

@app.post("/ocr")
async def ocr(payload: dict):
    # payload: {"image_url": "s3://originals/.."} or {"text_hint": ".."}
    # MVP: lazy RapidOCR; falls back to stub so container stays healthy offline.
    eng = engine()
    if isinstance(eng, str):
        return {"ok": True, "engine": "stub", "note": eng, "fields": {}}
    return {"ok": True, "engine": "rapidocr", "fields": {}}
