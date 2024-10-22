from generator import Generator
from datetime import datetime

t0 = datetime.strptime("2020-11-29", "%Y-%m-%d")
t1 = datetime.strptime("2024-01-10", "%Y-%m-%d")
t2 = datetime.strptime("2025-02-11", "%Y-%m-%d")
client_count = [40000, 10000]
card_count = [80000, 20000]
transaction_count = [160000, 40000]
pass_count = [320000, 80000]
ride_count = [640000, 160000]
slope_count = [5, 6]

available_passes = [
    [
        (10, 10),
        (25, 20),
        (50, 35),
        (100, 60),
        (200, 100),
    ],
    [
        (10, 10),
        (25, 20),
        (50, 35),
        (100, 60),
        (200, 100),
    ],
]


def main():
    generator = Generator(0)
    state = generator.generate(
        t0,
        t1,
        client_count[0],
        card_count[0],
        transaction_count[0],
        pass_count[0],
        ride_count[0],
        available_passes[0],
        slope_count[0],
    )

    state = generator.generate(
        t1,
        t2,
        client_count[1],
        card_count[1],
        transaction_count[1],
        pass_count[1],
        ride_count[1],
        available_passes[1],
        slope_count[1],
    )


if __name__ == "__main__":
    main()
