from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.services.content_service import ContentService

router = APIRouter()


@router.get("/verse-of-day")
async def verse_of_day(db: AsyncSession = Depends(get_db)):
    """آية اليوم — تتغير يومياً"""
    service = ContentService(db)
    return await service.get_verse_of_day()


@router.get("/hadith-of-day")
async def hadith_of_day(db: AsyncSession = Depends(get_db)):
    """حديث اليوم"""
    service = ContentService(db)
    return await service.get_hadith_of_day()


@router.get("/poetry")
async def list_poetry(
    category: str = Query(None),
    db: AsyncSession = Depends(get_db),
):
    """قائمة القصائد مع فلترة اختيارية حسب الفئة"""
    service = ContentService(db)
    return await service.get_poetry(category_id=category)
