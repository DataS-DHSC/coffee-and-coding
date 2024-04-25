# -*- coding: utf-8 -*-
"""
Pytest unit tests for `src/simple_functions.py`
"""

from src.simple_functions import (
    add,
    wait_then_add,
)


def test_add():
    assert add(x=1, y=2) == 3
    assert add(x=2, y=1) == 3
    assert add(x=0, y=9) == 9
    assert add(x=-100, y=100) == 0


def test_wait_then_add():
    s1 = wait_then_add(x=5, y=3)
    s2 = wait_then_add(x=0.0, y=1.0)
    assert s1 == 8


def test_bad_test():
    assert add(x=1, y=1) == 2
    assert add(x=4, y=-20) == 24
