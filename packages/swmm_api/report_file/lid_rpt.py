import datetime
import re
from pathlib import Path

import pandas as pd
from pandas._libs import OutOfBoundsDatetime


def read_lid_report(fn):
    """
    Read the LID Report file for one LID usage.

    Args:
        fn (str | Path): path to the LID report text file.

    Returns:
        pandas.DataFrame: index is reported time-steps and columns are hydrological results of LID
    """
    if not Path(fn).is_file():
        raise FileNotFoundError(f"No such file or directory: '{fn}'")
    df = pd.read_csv(fn, sep='\t', skiprows=5, header=[0, 1, 2, 3], skipinitialspace=True, index_col=0)
    # drop 4th header row (only ---------...)
    df.columns = ['_'.join(c) for c in df.columns.droplevel(3)]

    # convert index to DateTime
    try:
        df.index = pd.to_datetime(df.index, format='%m/%d/%Y %H:%M:%S')
    except OutOfBoundsDatetime:  # if year is > 3000 -> future projections
        df.index = [datetime.datetime.strptime(i, '%m/%d/%Y %H:%M:%S') for i in df.index]

    # read 4th line (with LID unit name and subcatchment name)
    with Path(fn).open() as f:
        for line in f:
            if 'LID Unit: ' in line:
                # Use re.search() to find the pattern in the input string
                match = re.search(r"LID Unit: (\w+) in Subcatchment (\w+)", line)
                break

    if match:
        df.attrs = {
            'lid_unit': match.group(1),
            'subcatchment': match.group(2)
        }
    return df
