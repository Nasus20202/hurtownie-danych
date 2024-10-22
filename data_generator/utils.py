from datetime import datetime
import faker


def get_season(date: datetime) -> int:
    if date.month >= 10:
        return date.year

    if date.month <= 3:
        return date.year - 1

    if date == get_season_end(date.year - 1):
        return date.year - 1

    raise ValueError("Invalid date")


def get_season_start_from_date(date: datetime) -> datetime:
    return get_season_start(get_season(date))


def get_season_start(season: int) -> datetime:
    return datetime(season, 10, 1)


def get_season_end_from_date(date: datetime) -> datetime:
    return get_season_end(get_season(date))


def get_season_end(season: int) -> datetime:
    return datetime(season + 1, 4, 1)
