from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.services.hadith_service import HadithService

router = APIRouter()

VALID_BOOKS = {"bukhari", "muslim", "abudawud", "tirmidhi"}


@router.get("/books")
async def list_books():
    """قائمة كتب الحديث المتاحة"""
    return [
        {"id": "bukhari", "name": "صحيح البخاري", "total": 7563},
        {"id": "muslim", "name": "صحيح مسلم", "total": 3033},
        {"id": "abudawud", "name": "سنن أبي داود", "total": 5274},
        {"id": "tirmidhi", "name": "جامع الترمذي", "total": 3956},
    ]


@router.get("/{book_id}/chapters")
async def list_chapters(
    book_id: str,
    db: AsyncSession = Depends(get_db),
):
    """أبواب كتاب الحديث"""
    if book_id not in VALID_BOOKS:
        raise HTTPException(status_code=404, detail="الكتاب غير موجود")
    service = HadithService(db)
    return await service.get_chapters(book_id)


@router.get("/{book_id}/chapter/{chapter_id}")
async def get_chapter_hadiths(
    book_id: str,
    chapter_id: int,
    db: AsyncSession = Depends(get_db),
):
    """أحاديث باب معين"""
    if book_id not in VALID_BOOKS:
        raise HTTPException(status_code=404, detail="الكتاب غير موجود")
    service = HadithService(db)
    return await service.get_hadiths_by_chapter(book_id, chapter_id)


@router.get("/search")
async def search_hadiths(
    q: str = Query(..., min_length=3),
    book: str = Query(None),
    limit: int = Query(20, ge=1, le=100),
    db: AsyncSession = Depends(get_db),
):
    """بحث في الأحاديث النبوية"""
    if book and book not in VALID_BOOKS:
        raise HTTPException(status_code=400, detail="معرف الكتاب غير صحيح")
    service = HadithService(db)
    return await service.search(q, book_id=book, limit=limit)
