from fastapi import FastAPI
from dotenv import load_dotenv
from controller import router as controller_router
from repository.user import insert_admin_user

load_dotenv()

# INSERT ADMIN ACCOUNT
insert_admin_user()

# Launch API
app = FastAPI()
app.include_router(controller_router)