from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.database.session import create_tables
from app.api.routes import quran, hadith, tafseer, content

@asynccontextmanager
async def lifespan(app: FastAPI):
    await create_tables()
    yield

app = FastAPI(
    title="Islamic App API",
    description="واجهة برمجية لتطبيق إسلامي عربي متكامل",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET"],
    allow_headers=["*"],
)

app.include_router(quran.router, prefix="/api/v1/quran", tags=["القرآن الكريم"])
app.include_router(hadith.router, prefix="/api/v1/hadith", tags=["الأحاديث"])
app.include_router(tafseer.router, prefix="/api/v1/tafseer", tags=["التفسير"])
app.include_router(content.router, prefix="/api/v1/content", tags=["المحتوى"])


@app.get("/health")
async def health():
    return {"status": "ok", "message": "الحمد لله"}
