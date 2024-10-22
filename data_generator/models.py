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


class ClientEntity(Client):
    client_id: int


@dataclass
class Card:
    client: Client
    card_code: str
    registered: datetime

    passes: list[Pass]


class CardEntity(Card):
    card_id: int
    client_id: int


@dataclass
class Transaction:
    client: Client

    total_price: float
    type: str
    date: datetime

    passes: list[Pass]


class TransactionEntity(Transaction):
    transaction_id: int
    client_id: int


@dataclass
class Pass:
    transaction: Transaction
    card: Card

    price: float
    total_rides: int
    used_rides: int
    valid_until: datetime

    rides: list[Ride]


class PassEntity(Pass):
    pass_id: int
    transaction_id: int
    card_id: int


@dataclass
class Ride:
    skipass: Pass
    slope: int
    date: datetime
    success: bool


class RideEntity(Ride):
    pass_id: int
