from state_manager import StateManager
from models import *
from utils import *
import faker
from datetime import datetime
import random


@dataclass
class State:
    clients: list[Client]
    cards: list[Card]
    transactions: list[Transaction]
    passes: list[Pass]
    rides: list[Ride]


class Generator:
    def __init__(self, seed: int = None):
        self.manager = StateManager()
        self.fake = faker.Faker("pl_PL")

        random.seed(seed)
        self.fake.seed_instance(seed)

    def generate(
        self,
        start_date: datetime,
        end_date: datetime,
        client_count: int,
        card_count: int,
        transaction_count: int,
        pass_count: int,
        ride_count: int,
        pass_types: list[tuple[int, float]],
        slope_count: int,
    ) -> State:
        if card_count < client_count:
            raise ValueError("Card count must be greater than client count")

        if pass_count < transaction_count:
            raise ValueError("Pass count must be greater than transaction count")

        # Clients
        for i in range(client_count):
            if i % 1000 == 0:
                print(f"Generating client {i}/{client_count}")
            self.create_client(start_date, end_date)

        self.manager.clients.sort(key=lambda x: x.registered)

        # Cards
        for client in filter(lambda x: x.cards == [], self.manager.clients):
            self.create_card(start_date, end_date, client)

        for i in range(card_count - client_count):
            if i + 1 % 1000 == 0:
                print(f"Generating card {i}/{card_count}")
            client = random.choice(self.manager.clients)
            self.create_card(start_date, end_date, client)

        self.manager.cards.sort(key=lambda x: x.registered)

        # Transactions
        for i in range(transaction_count):
            if i % 1000 == 0:
                print(f"Generating transaction {i}/{transaction_count}")
            user = random.choice(self.manager.clients)
            self.create_transaction(start_date, end_date, user)

        self.manager.transactions.sort(key=lambda x: x.date)

        # Passes
        for transaction in filter(lambda x: x.passes == [], self.manager.transactions):
            self.create_pass(start_date, end_date, transaction, pass_types)

        for i in range(pass_count - transaction_count):
            if i % 1000 == 0:
                print(f"Generating pass {i}/{pass_count}")
            transaction = random.choice(self.manager.transactions)
            while transaction.date < start_date:
                transaction = random.choice(self.manager.transactions)

            self.create_pass(start_date, end_date, transaction, pass_types)

        self.manager.passes.sort(key=lambda x: x.transaction.date)

        # Rides
        for i in range(ride_count):
            if i % 1000 == 0:
                print(f"Generating ride {i}/{ride_count}")
            card = random.choice(self.manager.cards)
            self.create_ride(start_date, end_date, card, slope_count)

        self.manager.rides.sort(key=lambda x: x.date)

        self.set_ids()

        print("Generation completed")
        return self.get_state()

    def get_state(self) -> State:
        return State(
            self.manager.clients,
            self.manager.cards,
            self.manager.transactions,
            self.manager.passes,
            self.manager.rides,
        )

    def set_ids(self, start_id: int = 1):
        for i, client in enumerate(self.manager.clients, start_id):
            client.client_id = i

        for i, card in enumerate(self.manager.cards, start_id):
            card.card_id = i
            card.client_id = card.client.client_id

        for i, transaction in enumerate(self.manager.transactions, start_id):
            transaction.transaction_id = i
            transaction.client_id = transaction.client.client_id

        for i, skipass in enumerate(self.manager.passes, start_id):
            skipass.pass_id = i
            skipass.transaction_id = skipass.transaction.transaction_id
            skipass.card_id = skipass.card.card_id

        for i, ride in enumerate(self.manager.rides, start_id):
            ride.ride_id = i
            ride.pass_id = ride.skipass.pass_id

    def create_client(self, start_date: datetime, end_date: datetime):
        name = self.fake.first_name()
        surname = self.fake.last_name()

        self.manager.add_client(
            name,
            surname,
            f"{name.lower()}.{surname.lower()}@{self.fake.free_email_domain()}",
            self.fake.phone_number(),
            self.get_random_date_in_season(start_date, end_date),
        )

    def create_card(self, start_date: datetime, end_date: datetime, client: Client):
        self.manager.add_card(
            client,
            self.fake.uuid4(),
            self.get_random_date_in_season(
                max(client.registered, start_date), end_date
            ),
        )

    def create_transaction(
        self, start_date: datetime, end_date: datetime, client: Client
    ):
        if not client.cards:
            raise ValueError("Client must have a card to make a transaction")

        first_card_registered = min(card.registered for card in client.cards)

        self.manager.add_transaction(
            client,
            random.choice(["online", "offline"]),
            self.get_random_date_in_season(
                max(first_card_registered, start_date), end_date
            ),
        )

    def create_pass(
        self,
        start_date: datetime,
        __: datetime,
        transaction: Transaction,
        passes: list[tuple[int, float]],
    ):
        if transaction.date < start_date:
            raise ValueError("Transaction date cannot be earlier than start date")

        valid_until = get_season_end_from_date(transaction.date)
        price, total_rides = random.choice(passes)

        possible_cards = [
            card
            for card in transaction.client.cards
            if card.registered <= transaction.date
        ]
        if not possible_cards:
            raise ValueError("No card available")

        card = random.choice(possible_cards)

        self.manager.add_pass(transaction, card, price, total_rides, valid_until)

    def create_ride(
        self, start_time: datetime, end_time: datetime, cards: Card, slope_count: int
    ):
        time = self.get_random_date_in_season(
            max(cards.registered, start_time), end_time
        )
        slope = random.randint(1, slope_count)

        available_passes = [
            skipass
            for skipass in cards.passes
            if skipass.valid_until >= time
            and get_season(skipass.valid_until) == get_season(time)
            and skipass.used_rides < skipass.total_rides
            and skipass.transaction.date <= time
        ]

        if not available_passes:
            return self.manager.add_invalid_ride(slope, time)

        available_passes.sort(key=lambda x: x.transaction.date)
        skipass = available_passes[0]

        self.manager.add_ride(skipass, slope, time)

    def get_random_date_in_season(
        self, start_date: datetime, end_date: datetime
    ) -> datetime:
        get_season(start_date)
        get_season(end_date)

        date = self.fake.date_time_between_dates(start_date, end_date)
        while date.month in range(4, 10) or date.hour not in range(6, 22):
            date = self.fake.date_time_between_dates(start_date, end_date)
        return date
