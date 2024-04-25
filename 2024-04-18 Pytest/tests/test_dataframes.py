from datetime import datetime as dt

import pandas as pd
import pytest

from src.dataframes import (
    drop_column,
    get_initial,
    correct_dtypes,
    load_and_clean_data_from_csv,
)


# create_df = pd.DataFrame(
#     {
#         "name": ["Alice", "Bob", "Charlie", "david"],
#         "age": ["20", 40, 32, 74.0],
#         "dob": ["2004-01-01", "1984-10-31", "2024-04-25", "1949-12-25"],
#         "city": ["London", "London", "Leeds", "Newcastle"],
#     }
# )


@pytest.fixture
def create_df():
    df = pd.DataFrame(
        {
            "name": ["Alice", "Bob", "Charlie", "david"],
            "age": ["20", 40, 32, 74.0],
            "dob": ["2004-01-01", "1984-10-31", "2024-04-25", "1949-12-25"],
            "city": ["London", "London", "Leeds", "Newcastle"],
        }
    )
    return df


def test_drop_columns(create_df):
    df = create_df
    drop_column(df, "city")
    expected_output_cols = ["name", "age", "dob"]
    assert (
        list(df.columns) == expected_output_cols
    ), f"After dropping the 'city' column, we should only have name, age and dob columns. We got {expected_output_cols}"


def test_get_initial(create_df):
    df = create_df
    name_initials = df["name"].apply(get_initial)
    name_initials_list = list(name_initials)
    city_initials = df["city"].apply(get_initial)
    city_initials_list = list(city_initials)

    assert isinstance(
        name_initials, pd.Series
    ), f"Applying `get_initial()` to a Series should return a Series. The type returned was {type(name_initials)}"
    assert isinstance(
        city_initials, pd.Series
    ), f"Applying `get_initial()` to a Series should return a Series. The type returned was {type(city_initials)}"
    assert name_initials_list == [
        "A",
        "B",
        "C",
        "D",
    ], f"The initials of the column Alice, Bob, Charlie, david should be ABCD. The output was actually {name_initials_list}"
    assert city_initials_list == [
        "L",
        "L",
        "L",
        "N",
    ], f"The initials of London, London, Leeds, Newcastle should be LLLN. The output was actually {city_initials_list}"


def test_correct_dtypes(create_df):
    df = create_df
    output = correct_dtypes(df)
    assert isinstance(
        output, pd.DataFrame
    ), f"The output of a `correct_dtypes()` call should be a pandas DataFrame. It is a {type(output)}"
    assert output.dtypes.equals(
        pd.Series(
            {
                "name": "object",
                "age": "int32",
                "dob": "datetime64[ns]",
                "city": "object",
            }
        )
    )


@pytest.fixture
def create_clean_df():
    df = pd.DataFrame(
        {
            "name": ["Alice", "Bob", "Charlie", "david"],
            "age": [20, 40, 32, 74],
            "dob": [
                dt(2004, 1, 1),
                dt(1984, 10, 31),
                dt(2024, 4, 25),
                dt(1949, 12, 25),
            ],
            "initial": ["A", "B", "C", "D"],
        }
    )
    df["age"] = df["age"].astype(int)
    df["dob"] = pd.to_datetime(df["dob"])
    return df


def test_load_and_clean_data_from_csv(mocker, create_df, create_clean_df):
    df = create_df
    expected = create_clean_df

    mocker.patch("pandas.read_csv", return_value=df)
    output = load_and_clean_data_from_csv("")

    assert output.dtypes.equals(
        expected.dtypes
    ), f"Expect dtypes to be\n{expected.dtypes}\n They were\n{output.dtypes}"
    assert output.equals(expected), f"Expect:\n{expected}\nnot\n{output}"
