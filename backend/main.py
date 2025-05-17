from dotenv import load_dotenv
load_dotenv()

from fastapi import FastAPI
from controller import router as controller_router
from repository.user_repository import insert_admin_user
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
# import instrumentation

# INSERT ADMIN ACCOUNT
insert_admin_user()

# Launch API
app = FastAPI()

@app.get("/health")
def health_check():
    return {"status": "up"}

@app.get("/ready")
def ready_check():
    return {"status": "ready"}

app.include_router(controller_router)
FastAPIInstrumentor.instrument_app(app)