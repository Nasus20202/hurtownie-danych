from models import *
from datetime import datetime
from utils import get_season


class StateManager:
    clients: list[Client] = []
    cards: list[Card] = []
    transactions: list[Transaction] = []
    passes: list[Pass] = []
    rides: list[Ride] = []

    def add_client(
        self, name: str, surname: str, email: str, phone: str, registered: datetime
    ) -> Client:
        client = Client(name, surname, email, phone, registered, [], [])

        self.clients.append(client)

        return client

    def add_card(self, client: Client, card_code: str, registered: datetime) -> Card:
        if registered < client.registered:
            raise ValueError(
                "Card registration date cannot be earlier than client registration date"
            )

        card = Card(client, card_code, registered, [])

        self.cards.append(card)
        client.cards.append(card)

        return card

    def add_transaction(self, client: Client, type: str, date: datetime) -> Transaction:
        if date < client.registered:
            raise ValueError(
                "Transaction date cannot be earlier than client registration date"
            )

        if client.cards == []:
            raise ValueError("Client must have a card to make a transaction")

        transaction = Transaction(client, 0, type, date, [])
        self.transactions.append(transaction)

        client.transactions.append(transaction)

        return transaction

    def add_pass(
        self,
        transaction: Transaction,
        card: Card,
        price: float,
        total_rides: int,
        valid_until: datetime,
    ) -> Pass:
        if valid_until < transaction.date:
            raise ValueError(
                "Pass valid_until date cannot be earlier than transaction date"
            )

        if transaction.date < card.registered:
            raise ValueError(
                "Transaction date cannot be earlier than card registration date"
            )

        if get_season(valid_until) != get_season(transaction.date):
            raise ValueError(
                "Pass valid_until date must be in the same season as transaction date"
            )

        skipass = Pass(transaction, card, price, total_rides, 0, valid_until, [])
        self.passes.append(skipass)

        transaction.passes.append(skipass)
        transaction.total_price += price
        card.passes.append(skipass)

        return skipass

    def add_ride(self, skipass: Pass, slope: int, data: datetime) -> Ride:
        if skipass.used_rides < skipass.total_rides:
            ride = Ride(skipass, slope, data, True)

            skipass.rides.append(ride)
            skipass.used_rides += 1

        else:
            ride = Ride(None, slope, data, False)

        self.rides.append(ride)
        return ride
