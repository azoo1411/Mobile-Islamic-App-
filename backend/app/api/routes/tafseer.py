from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.services.tafseer_service import TafseerService

router = APIRouter()

VALID_SOURCES = {"ibn_katheer", "saadi"}


@router.get("/{surah}/{ayah}")
async def get_tafseer(
    surah: int,
    ayah: int,
    source: str = Query("ibn_katheer", pattern="^(ibn_katheer|saadi)$"),
    db: AsyncSession = Depends(get_db),
):
    """
    جلب تفسير آية كريمة
    - source: ibn_katheer | saadi
    """
    service = TafseerService(db)
    return await service.get_tafseer(surah, ayah, source)
