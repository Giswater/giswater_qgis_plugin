__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"

import pandas as pd

"""SWMM5 User Manual: Section 11.4 Climate Files
A user-prepared climate file where each line contains a recording station name, the year, month, day, 
maximum temperature, minimum temperature, and optionally, evaporation rate, and wind speed. 
If no data are available for any of these items on a given date, then an asterisk should be entered as its value

For a user-prepared climate file, the data must be in the same units as the project being
analyzed. 

For US units, 
    temperature is in degrees F, 
    evaporation is in inches/day, and
    wind speed is in miles/hour. 

For metric units, 
    temperature is in degrees C, 
    evaporation is in mm/day, and 
    wind speed is in km/hour.
"""


class COLUMNS:
    STATION = 'station name'
    MAX_TEMPERATURE = 'maximum temperature'
    MIN_TEMPERATURE = 'minimum temperature'
    EVAPORATION = 'evaporation rate'
    WIND_SPEED = 'wind speed'

    YEAR = 'year'
    MONTH = 'month'
    DAY = 'day'

    FOR_FRAME = [STATION, MAX_TEMPERATURE, MIN_TEMPERATURE, EVAPORATION, WIND_SPEED]
    FOR_FILE = [STATION, YEAR, MONTH, DAY, MAX_TEMPERATURE, MIN_TEMPERATURE, EVAPORATION, WIND_SPEED]


def read_climate_dat_file(filename):
    """
    read climate .dat-file

    Args:
        filename (str): path and filename of the file to be read

    Returns:
        pandas.DataFrame: climate dataframe
    """
    df = pd.read_csv(filename, sep=' ', decimal='.', parse_dates={'date': [1, 2, 3]},
                     keep_date_col=False, header=None, index_col=['date'], na_values='*')
    df.columns = COLUMNS.FOR_FRAME
    return df


def write_climate_dat_file(df, filename):
    """
    write climate .dat-file for SWMM

    Args:
        df (pandas.DataFrame): climate dataframe:
        filename (str): path and filename for the new file
    """
    df[COLUMNS.YEAR] = df.index.year
    df[COLUMNS.MONTH] = df.index.strftime('%m')
    df[COLUMNS.DAY] = df.index.strftime('%d')

    df[[c for c in COLUMNS.FOR_FILE if c in df]].to_csv(filename, sep=' ', header=None, index=None, na_rep='*')
