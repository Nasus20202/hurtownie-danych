from generator import Generator
from datetime import datetime


def main():
    generator = Generator(0)
    generator.generate(
        start_date=datetime.strptime("2021-01-01", "%Y-%m-%d"),
        end_date=datetime.strptime("2021-01-10", "%Y-%m-%d"),
        client_count=2,
        card_count=4,
        transaction_count=8,
        pass_count=16,
        ride_count=32,
    )
    print("Users:")
    for client in generator.manager.clients:
        print(client.name, client.surname, client.registered)

    print("\nCards:")
    for card in generator.manager.cards:
        print(card.client.name, card.client.surname, card.registered, card.card_code)

    print("\nTransactions:")
    for transaction in generator.manager.transactions:
        print(
            transaction.client.name,
            transaction.client.surname,
            transaction.date,
            transaction.type,
        )


if __name__ == "__main__":
    main()
