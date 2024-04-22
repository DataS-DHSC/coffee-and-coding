import os

# from datetime import datetime as dt

import pandas as pd
import pytest

from src.dataframes import load_and_clean_data_from_csv


@pytest.fixture
def data():
    df = load_and_clean_data_from_csv(
        os.path.realpath(
            os.path.join(os.path.dirname(__file__), "..", "data", "data.csv")
        )
    )
    return df


def test_data_length(data):
    assert (
        len(data) <= 100
    ), f"Our data should have no more than 100 lines. There are {len(data)}"


def test_data_columns(data):
    assert "name" in data.columns, "There should be a name field"
    assert "age" in data.columns, "There should be an age field"
    assert "dob" in data.columns, "There should be a dob field"
    assert "initial" in data.columns, "There should be an initial field"


def test_data_ages(data):
    today = pd.Timestamp("now")
    data["age_based_on_dob"] = data["dob"].apply(
        lambda dob: today.year
        - dob.year
        - ((today.month, today.day) <= (dob.month, dob.day))
    )
    age_dob_not_consistent = data[data["age_based_on_dob"] != data["age"]]
    assert (
        len(age_dob_not_consistent) == 0
    ), f"Some ages are not consistent with dob:\n{age_dob_not_consistent}"
