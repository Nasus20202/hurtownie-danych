from dataclasses import dataclass
from datetime import datetime


class Card:
    pass


class Transaction:
    pass


class Pass:
    pass


class Ride:
    pass


@dataclass
class Client:
    name: str
    surname: str
    email: str
    phone: str
    registered: datetime

    cards: list[Card]
    transactions: list[Transaction]

    client_id: int = 0


@dataclass
class Card:
    client: Client
    card_code: str
    registered: datetime

    passes: list[Pass]

    card_id: int = 0
    client_id: int = 0


@dataclass
class Transaction:
    client: Client

    total_price: float
    type: str
    date: datetime

    passes: list[Pass]

    transaction_id: int = 0
    client_id: int = 0


@dataclass
class Pass:
    transaction: Transaction
    card: Card

    price: float
    total_rides: int
    used_rides: int
    valid_until: datetime

    rides: list[Ride]

    pass_id: int = 0
    transaction_id: int = 0
    card_id: int = 0


@dataclass
class Ride:
    skipass: Pass
    slope: int
    date: datetime
    success: bool

    pass_id: int = 0
