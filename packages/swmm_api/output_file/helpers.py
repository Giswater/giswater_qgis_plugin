import pandas as pd


def drop_useless_column_levels(df):
    """
    Drop Levels in a MultiIndex if only one single value occurs.

    Works inplace.

    Args:
        df (pd.DataFrame): data-frame
    """
    if isinstance(df.columns, pd.MultiIndex):
        df.columns = df.columns.droplevel([i for i, l in enumerate(df.columns.levshape) if l == 1])
