# -*- coding: utf-8 -*-
"""
Pytest unit tests for `src/simple_functions.py`.

Introduces 
"""

from src.simple_functions import (
    add,
    wait_then_add,
    wait_1000_seconds_then_multiply,
)
import pytest
import time
import warnings


class TestAdd:
    @pytest.mark.parametrize(
        "test_x, test_y, expected_output",
        [(1, 2, 3), (2, 1, 3), (0, 9, 9), (-100, 100, 0)],
    )
    def test_add(self, test_x, test_y, expected_output):
        assert (
            add(x=test_x, y=test_y) == expected_output
        ), f"add({test_x}, {test_y}) should return {expected_output}"

    @pytest.mark.parametrize(
        "x, y",
        [
            (0.0, 1),
            (0, 1.5),
            (1.5, 0),
            (2.3, 1.2),
            (-0.1, 1),
            ("s", 1),
            ("1", "2"),
        ],
    )
    def test_errors(self, x, y):
        """
        add() should only run if both arguments are integers, and throw a
        ValueError if either argument is not an integer. We test this as so:
        """
        with pytest.raises(ValueError):
            add(x, y)


class TestWait1000SecondsThenMultiply:
    def test_wait_1000_seconds_then_multiply(self, mocker):
        """
        wait_1000_seconds_then_multiply() has a dependency of time.sleep(), which
        takes a very long time to run. Rather than having to wait 1000 seconds
        every time we run the test, we can "patch" the time.sleep() function, so
        that it doesn't do anything. Then our test only focuses on the part of the
        code that we care about.
        """
        mocker.patch("time.sleep", return_value=None)
        assert wait_1000_seconds_then_multiply(4, 10) == 40


class TestWaitThenAdd:
    @pytest.mark.parametrize("t", [0, 1, 3])
    def test_wait_then_add(self, mocker, t):
        # wait_then_add() depends on the add() function. We can patch the add()
        # function so that it always returns 2 (no matter what). This allows us to
        # only test the parts exclusive to wait_then_add - namely, how long it
        # takes to run.
        mocker.patch("src.simple_functions.add", return_value=2)
        start_time = time.perf_counter()
        s = wait_then_add(x=0, y=0, t=t)
        time_taken = time.perf_counter() - start_time
        assert s == 2
        assert 0 <= time_taken - t <= 0.01

    def test_wait_then_add_warnings(self, mocker, recwarn):
        mocker.patch("src.simple_functions.add", return_value=2)
        mocker.patch("time.sleep", return_value=None)
        assert len(recwarn) == 0
        wait_then_add(x=0, y=0, t=120)
        assert (
            len(recwarn) == 1
        ), "A warning should have been raised as we will wait too long"


# def test_floating_point_error():
#     assert (
#         0.1 + 0.2 == 0.3
#     ), f"0.1 + 0.2 should equal 0.3 exactly, not {0.1+0.2}"
#     # assert 0.1 + 0.2 == pytest.approx(0.3)
