from generator import Generator
from datetime import datetime
import os

t0 = datetime.strptime("2020-11-29", "%Y-%m-%d")
t1 = datetime.strptime("2024-01-10", "%Y-%m-%d")
t2 = datetime.strptime("2025-02-11", "%Y-%m-%d")
client_count = [400, 100]
card_count = [800, 200]
transaction_count = [1600, 400]
pass_count = [3200, 800]
ride_count = [128000, 32000]
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


def export_to_bulk(state, suffix="t1"):
    os.makedirs("output", exist_ok=True)
    with open(f"output/clients_{suffix}.csv", "w", encoding="utf-16") as f:
        f.write("\r\n".join(record.to_bulk() for record in state.clients))
    with open(f"output/cards_{suffix}.csv", "w", encoding="utf-16") as f:
        f.write("\r\n".join(record.to_bulk() for record in state.cards))
    with open(f"output/transactions_{suffix}.csv", "w", encoding="utf-16") as f:
        f.write("\r\n".join(record.to_bulk() for record in state.transactions))
    with open(f"output/passes_{suffix}.csv", "w", encoding="utf-16") as f:
        f.write("\r\n".join(record.to_bulk() for record in state.passes))
    with open(f"output/rides_{suffix}.csv", "w", encoding="utf-16") as f:
        f.write("\r\n".join(record.to_bulk() for record in state.rides))


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
    export_to_bulk(state, "t1")

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
    export_to_bulk(state, "t2")


if __name__ == "__main__":
    main()
