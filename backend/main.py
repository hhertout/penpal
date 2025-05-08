from dotenv import load_dotenv
load_dotenv()

from fastapi import FastAPI
from controller import router as controller_router
from repository.user_repository import insert_admin_user

# INSERT ADMIN ACCOUNT
insert_admin_user()

# Launch API
app = FastAPI()
app.include_router(controller_router)