from generator import Generator
from datetime import datetime

t0 = datetime.strptime("2020-11-29", "%Y-%m-%d")
t1 = datetime.strptime("2024-01-10", "%Y-%m-%d")
t2 = datetime.strptime("2025-02-11", "%Y-%m-%d")
client_count = 4
card_count = 8
transaction_count = 16
pass_count = 32
ride_count = 64
slope_count = 5

available_passes = [
    (10, 10),
    (25, 20),
    (50, 35),
    (100, 60),
    (200, 100),
]


def main():
    generator = Generator(0)
    state = generator.generate(
        t0,
        t1,
        client_count,
        card_count,
        transaction_count,
        pass_count,
        ride_count,
        available_passes,
        slope_count,
    )


if __name__ == "__main__":
    main()
