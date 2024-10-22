from generator import Generator
from datetime import datetime

t0 = datetime.strptime("2021-01-01", "%Y-%m-%d")
t1 = datetime.strptime("2024-01-10", "%Y-%m-%d")
client_count = 20
card_count = 40
transaction_count = 80
pass_count = 160
ride_count = 320

available_passes = [
    (10, 10),
    (25, 20),
    (50, 35),
    (100, 60),
    (200, 100),
]


def main():
    generator = Generator(0)
    generator.generate(
        t0,
        t1,
        client_count,
        card_count,
        transaction_count,
        pass_count,
        ride_count,
        available_passes,
    )

    """for user in generator.manager.clients:
        print(user.email)
        for card in user.cards:
            print(f"{card.card_code} {card.registered}")

        for transaction in user.transactions:
            print(f"{transaction.type} {transaction.date} {transaction.total_price}")

            for skipass in transaction.passes:
                print(
                    f"{skipass.price} {skipass.total_rides} {skipass.valid_until} {skipass.used_rides}"
                )
            print("")

        print("")

    print(len(generator.manager.clients))
    print(len(generator.manager.cards))
    print(len(generator.manager.transactions))
    print(len(generator.manager.passes))
    print(len(generator.manager.rides))"""
    prices = [price.total_price for price in generator.manager.transactions]
    print(prices)


if __name__ == "__main__":
    main()
