from datetime import datetime


def get_season(date: datetime):
    if date.month >= 10:
        return date.year

    if date.month <= 3:
        return date.year - 1

    raise ValueError("Invalid date")
