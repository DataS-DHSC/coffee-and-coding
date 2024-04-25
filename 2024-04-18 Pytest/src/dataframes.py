# -*- coding: utf-8 -*-
"""
Script of functions using dataframes
"""

import pandas as pd


def drop_column(df: pd.DataFrame, col: str) -> None:
    """Removes a specified column from a DataFrame.

    Args:
        df (pd.DataFrame): A pandas DataFrame
        col (str): A column to drop from our DataFrame
    """
    df.drop(columns=col, inplace=True)


def get_initial(name: str) -> str:
    """Get first initial of a name.

    Args:
        name (str): _description_

    Returns:
        str: The first character of the name.
    """
    return name[0].upper()


def correct_dtypes(df: pd.DataFrame) -> pd.DataFrame:
    """Convert columns to the correct data types.

    Args:
        df (pd.DataFrame): A pandas DataFrame

    Returns:
        pd.DataFrame: A pandas DataFrame
    """
    return df.astype(
        {"name": str, "age": int, "dob": "datetime64[ns]", "city": str}
    )


def load_and_clean_data_from_csv(file_path: str) -> pd.DataFrame:
    """Load data from a .csv file, and clean it, by:
        * making an initial column;
        * converting the date of birth field to a DateTime field;
        * removing the city column.

    Args:
        file_path (str): File path of the data we want to clean

    Returns:
        pd.DataFrame: A cleaned pandas DataFrame
    """
    messy_df = pd.read_csv(file_path)

    clean_df = correct_dtypes(messy_df)
    clean_df["initial"] = clean_df["name"].apply(get_initial)
    drop_column(clean_df, "city")
    return clean_df


if __name__ == "__main__":
    clean_df = load_and_clean_data_from_csv("data/data.csv")
    print(clean_df)
    print(clean_df.dtypes)
