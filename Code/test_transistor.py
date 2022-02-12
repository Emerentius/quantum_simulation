from transistor import Transistor


def test_create_transistor() -> None:
    t = Transistor(0.5, 0.7, 3, 3, 0.5)
    t.poisson()
