import pkgutil
import importlib
from fastapi import APIRouter

router = APIRouter()

for _, module_name, _, in pkgutil.iter_modules(__path__):
    if module_name.endswith("_controller"):
        module = importlib.import_module(f"{__name__}.{module_name}")
        if hasattr(module, "router"):
            router.include_router(module.router)