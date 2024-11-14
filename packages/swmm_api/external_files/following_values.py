__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"

import pandas as pd


def _following_numbers_bool_base(series):
    return (series.diff() != 0) | (series.diff(-1) != 0)


def following_numbers_bool(series):
    """mark first and last value of following duplicates BUT no NaN values"""
    return _following_numbers_bool_base(series) & ~series.isna()


def following_nans_bool(series):
    """marks first and last NaN value of following NaN duplicates AND the value before and after NaN values"""
    return _following_numbers_bool_base(series.isna().astype(int))


def remove_following_zeros(series):
    """
    removes all following zeros (null) and NaN
    to reduce the data for plots etc.
    only tested with int/float/NaN

    Args:
        series (pandas.Series): time series

    Returns:
        pandas.Series: reduced time series
    """
    bool_series = ((_following_numbers_bool_base(series) | (series != 0)) & ~series.isna()) | following_nans_bool(series)
    return series.loc[bool_series].copy()


def remove_following_duplicates(data):
    """
    removes all following duplicates
    to reduce the data for plots etc.
    only tested with int/float/NaN
    only first and last following occurrence will stay

    OR:
    remove rows where the value is the sam as in the previous row, BUT keep the last value

    Args:
        data (pandas.DataFrame | pandas.Series):

    Returns:
        pandas.DataFrame | pandas.Series:
    """
    if isinstance(data, pd.DataFrame):
        bool_series = pd.Series(index=data.index, data=False)
        for column in data:
            series = data[column]
            bool_series |= following_numbers_bool(series) | following_nans_bool(series)
    # ________________________________
    elif isinstance(data, pd.Series):
        bool_series = following_numbers_bool(data) | following_nans_bool(data)
    # ________________________________
    else:
        raise NotImplementedError(f'"{type(data)}" not implemented')
    # ________________________________
    return data.loc[bool_series].copy()
