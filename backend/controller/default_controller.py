from fastapi import APIRouter

router = APIRouter()

@router.get("/health")
def health_check():
    return {"status": "up"}

@router.get("/ready")
def ready_check():
    return {"status": "up"}