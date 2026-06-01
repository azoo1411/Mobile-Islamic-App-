from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Optional

from app.database.session import get_db
from app.services.quran_service import QuranService

router = APIRouter()


@router.get("/surahs")
async def list_surahs(db: AsyncSession = Depends(get_db)):
    """جلب قائمة السور الـ ١١٤"""
    service = QuranService(db)
    return await service.get_all_surahs()


@router.get("/surahs/{surah_number}")
async def get_surah(surah_number: int, db: AsyncSession = Depends(get_db)):
    """جلب سورة بكامل آياتها"""
    if not 1 <= surah_number <= 114:
        raise HTTPException(status_code=404, detail="رقم السورة غير صحيح")
    service = QuranService(db)
    return await service.get_surah_with_ayahs(surah_number)


@router.get("/search")
async def search_quran(
    q: str = Query(..., min_length=3, description="نص البحث"),
    limit: int = Query(20, ge=1, le=100),
    db: AsyncSession = Depends(get_db),
):
    """البحث في نص القرآن الكريم"""
    service = QuranService(db)
    return await service.search(q, limit=limit)


@router.get("/ayah/{surah}/{ayah}")
async def get_ayah(
    surah: int,
    ayah: int,
    db: AsyncSession = Depends(get_db),
):
    """جلب آية واحدة"""
    service = QuranService(db)
    result = await service.get_ayah(surah, ayah)
    if not result:
        raise HTTPException(status_code=404, detail="الآية غير موجودة")
    return result
