# -*- coding: utf-8 -*-
"""
Script of basic functions
"""

import time


def add(x: int, y: int) -> int:
    """
    Add two integers x and y.
    """
    if not (isinstance(x, int) and isinstance(y, int)):
        raise ValueError("Inputs are not integers")

    return x + y


def wait_1000_seconds_then_multiply(x: int, y: int) -> int:
    """
    Waits 1000 seconds then multiplies the integers x and y.
    """
    time.sleep(1000)
    return x * y


def wait_then_add(x: int, y: int, t: int = 5) -> int:
    """
    Wait t seconds, then add two integers x and y.
    """
    time.sleep(t)
    return add(x, y)


def main():
    s1: int = add(5, 9)
    print(s1)
    s2: int = wait_then_add(-4, 17, 3)
    print(s2)


if __name__ == "__main__":
    main()
