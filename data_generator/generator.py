from state_manager import StateManager
from models import *
from utils import *
import faker
from datetime import datetime, timedelta
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
        created_cards = 0
        for client in filter(lambda x: x.cards == [], self.manager.clients):
            self.create_card(start_date, end_date, client)
            created_cards += 1

        for i in range(card_count - created_cards):
            if i % 1000 == 0:
                print(f"Generating card {i}/{card_count}")
            client = random.choice(self.manager.clients)
            self.create_card(start_date, end_date, client)

        self.manager.cards.sort(key=lambda x: x.registered)

        # Transactions
        created_transactions = 0
        for user in filter(lambda x: x.transactions == [], self.manager.clients):
            self.create_transaction(start_date, end_date, user)
            created_transactions += 1

        # Make sure that there is at least one transaction after card registration
        for card in self.manager.cards:
            if card.passes:
                continue
            transactions_after = [
                transaction
                for transaction in card.client.transactions
                if transaction.date > card.registered and transaction.date > start_date
            ]
            if not transactions_after:
                self.create_transaction(
                    max(start_date, card.registered), end_date, card.client
                )
                created_transactions += 1

        for i in range(transaction_count - created_transactions):
            if i % 1000 == 0:
                print(f"Generating transaction {i}/{transaction_count}")
            user = random.choice(self.manager.clients)
            self.create_transaction(start_date, end_date, user)

        self.manager.transactions.sort(key=lambda x: x.date)

        # Passes
        created_passes = 0
        for transaction in filter(lambda x: x.passes == [], self.manager.transactions):
            self.create_pass(start_date, end_date, transaction, pass_types)
            created_passes += 1

        # Make sure that there is at least one pass connect to the card
        for card in self.manager.cards:
            if card.passes:
                continue
            transactions_after = [
                transaction
                for transaction in card.client.transactions
                if transaction.date > card.registered and transaction.date > start_date
            ]
            if not transactions_after:
                raise ValueError("No transactions after card registration")
            self.create_pass(
                max(start_date, card.registered),
                end_date,
                transactions_after[0],
                pass_types,
            )
            created_passes += 1

        for i in range(pass_count - created_passes):
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
            self.create_ride(start_date, end_date, slope_count)

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
            ride.pass_id = ride.skipass.pass_id if ride.skipass else 0

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
            (
                self.get_random_date_in_season(
                    max(client.registered, start_date), end_date
                )
                if client.cards
                else client.registered
            ),
        )

    def create_transaction(
        self, start_date: datetime, end_date: datetime, client: Client
    ):
        if not client.cards:
            raise ValueError("Client must have a card to make a transaction")

        first_card_registered = min(card.registered for card in client.cards)

        # Prioritize cards with no transactions
        empty_cards = [card for card in client.cards if not card.passes]
        if empty_cards:
            first_card_registered = min(card.registered for card in empty_cards)

        self.manager.add_transaction(
            client,
            random.choice(["online", "offline"]),
            (
                self.get_random_date_in_season(
                    max(first_card_registered, start_date), end_date
                )
                if client.transactions
                else client.registered
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

        # Prioritize cards with no passes
        empty_cards = [card for card in possible_cards if not card.passes]
        if empty_cards:
            possible_cards = empty_cards

        if not possible_cards:
            raise ValueError("No card available")

        card = random.choice(possible_cards)

        self.manager.add_pass(transaction, card, price, total_rides, valid_until)

    def create_ride(self, start_time: datetime, end_time: datetime, slope_count: int):
        slope = random.randint(1, slope_count)

        selected_skipasses = random.sample(
            self.manager.passes, min(100, len(self.manager.passes))
        )

        active_passes = [
            skipass
            for skipass in selected_skipasses
            if skipass.valid_until >= start_time
            and skipass.transaction.date <= end_time
            and skipass.used_rides < skipass.total_rides
        ]

        if not active_passes:
            self.manager.add_invalid_ride(
                slope, self.get_random_date_in_season(start_time, end_time)
            )
            return

        skipass = random.choice(active_passes)

        time = self.fake.date_time_between_dates(
            max(start_time, skipass.transaction.date),
            min(end_time, skipass.valid_until),
        )

        # check if there are no rides on the same skipass in the same minute
        while any(
            ride
            for ride in skipass.rides
            if ride.slope == slope
            and ride.date - timedelta(minutes=1)
            <= time
            <= ride.date + timedelta(minutes=1)
        ):
            time += timedelta(minutes=1)

        self.manager.add_ride(skipass, slope, time)

    def get_random_date_in_season(
        self, start_date: datetime, end_date: datetime
    ) -> datetime:
        get_season(start_date)
        get_season(end_date)

        date = self.fake.date_time_between_dates(start_date, end_date)
        while date.month in range(4, 10) or date.hour not in range(6, 22):
            date = self.fake.date_time_between_dates(start_date, end_date)
        return date.replace(microsecond=0)
