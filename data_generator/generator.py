from state_manager import StateManager
from models import *
import faker
from datetime import datetime
import random


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
    ):
        for _ in range(client_count):
            self.create_client(start_date, end_date)

        for _ in range(card_count):
            client = random.choice(self.manager.clients)
            self.create_card(start_date, end_date, client)

        for _ in range(transaction_count):
            user = random.choice(self.manager.clients)
            self.create_transaction(start_date, end_date, user)

    def create_client(self, start_date: datetime, end_date: datetime):
        name = self.fake.first_name()
        surname = self.fake.last_name()

        self.manager.add_client(
            name,
            surname,
            f"{name.lower()}.{surname.lower()}@{self.fake.free_email_domain()}",
            self.fake.phone_number(),
            self.fake.date_time_between_dates(start_date, end_date),
        )

    def create_card(self, start_date: datetime, end_date: datetime, client: Client):
        self.manager.add_card(
            client,
            self.fake.uuid4(),
            self.fake.date_time_between_dates(client.registered, end_date),
        )

    def create_transaction(self, _: datetime, end_date: datetime, client: Client):
        if not client.cards:
            self.create_card(_, end_date, client)
        self.manager.add_transaction(
            client,
            random.choice(["online", "offline"]),
            self.fake.date_time_between_dates(client.registered, end_date),
        )
