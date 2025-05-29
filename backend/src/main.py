from dotenv import load_dotenv
load_dotenv()

from fastapi import FastAPI
from src.controller import router as controller_router
from src.repository.user_repository import insert_admin_user
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from fastapi.middleware.cors import CORSMiddleware
# import instrumentation

# INSERT ADMIN ACCOUNT
insert_admin_user()

# Launch API
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to your frontend's origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {"status": "up"}

@app.get("/ready")
def ready_check():
    return {"status": "ready"}

app.include_router(controller_router)
FastAPIInstrumentor.instrument_app(app)