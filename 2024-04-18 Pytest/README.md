# Pytest workshop

Example code to demonstrate some useful features in Pytest.

Users will need to install the `pytest` *and* `pytest-mock` packages from `conda`/ `pip`. 

To ensure the same versions of packages are being run, open Bash in this directory, and run `conda env create -f environment.yml`. This will create a conda environment, `pytest-env`.

All tests can be run with the command `pytest tests/`.

Alternatively `pytest tests/file_name.py` will run all the tests in `file_name.py` only.

`pytest tests/file_name.py -k TestClass` or `pytest tests/file_name.py -k test_function` will only run a specific test/ group of tests.

[Useful resource](https://realpython.com/pytest-python-testing/)