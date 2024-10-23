from dataclasses import dataclass
from datetime import datetime
from dataclasses import field


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

    cards: list[Card] = field(default_factory=list)
    transactions: list[Transaction] = field(default_factory=list)

    client_id: int = 0

    def to_bulk(self) -> str:
        return f"{self.client_id};{self.name};{self.surname};{self.email};{self.phone};{self.registered.strftime('%Y-%m-%d %H:%M:%S')}"


@dataclass
class Card:
    client: Client
    card_code: str
    registered: datetime

    passes: list[Pass] = field(default_factory=list)

    card_id: int = 0
    client_id: int = 0

    def to_bulk(self) -> str:
        return f"{self.card_id};{self.card_code};{self.registered.strftime('%Y-%m-%d %H:%M:%S')};{self.client_id}"


@dataclass
class Transaction:
    client: Client

    total_price: float
    type: str
    date: datetime

    passes: list[Pass] = field(default_factory=list)

    transaction_id: int = 0
    client_id: int = 0

    def to_bulk(self) -> str:
        return f"{self.transaction_id};{self.total_price};{self.type};{self.date.strftime('%Y-%m-%d %H:%M:%S')};{self.client_id}"


@dataclass
class Pass:
    transaction: Transaction
    card: Card

    price: float
    total_rides: int
    used_rides: int
    valid_until: datetime

    rides: list[Ride] = field(default_factory=list)

    pass_id: int = 0
    transaction_id: int = 0
    card_id: int = 0

    def to_bulk(self) -> str:
        return f"{self.pass_id};{self.price};{self.total_rides};{self.used_rides};{self.valid_until.strftime('%Y-%m-%d %H:%M:%S')};{self.transaction_id};{self.card_id}"


@dataclass
class Ride:
    skipass: Pass
    slope: int
    date: datetime
    success: bool

    pass_id: int = 0
