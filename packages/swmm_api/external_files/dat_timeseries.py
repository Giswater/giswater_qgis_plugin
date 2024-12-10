__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"

from pathlib import Path

import pandas as pd
from swmm_api.external_files.following_values import remove_following_zeros
from swmm_api.input_file._type_converter import str_to_datetime


def write_swmm_timeseries_data(series, filename, drop_zeros=True):
    """
    external files in swmm ie. timeseries. (often with the `.dat`-extension)

    Args:
        series (pandas.Series): time-series-data
        filename (pathlib.Path | str): path and filename for the new file
        drop_zeros (bool): remove all 0 (zero, null) entries in timeseries (SWMM will understand for precipitation)
    """
    if drop_zeros:
        ts = remove_following_zeros(series).dropna()
    else:
        ts = series.dropna()

    if isinstance(filename, Path):
        filename = filename.with_suffix('.dat')
    else:
        if not filename.endswith('.dat'):
            filename += '.dat'

    with open(filename, 'w') as file:
        file.write(';;EPA SWMM Time Series Data\n')
        ts.index.name = ';date      time'
        ts.to_csv(file, sep='\t', index=True, header=True, date_format='%m/%d/%Y %H:%M', lineterminator='\n')


def read_swmm_timeseries_data(filename):
    """
    read text-file of exported timeseries from the EPA-SWMM-GUI

    Args:
        filename (str): path and filename of the file to be read

    Returns:
        pandas.Series: time-series-data
    """
    sep = r'\s+'  # space or tab
    df = pd.read_csv(filename, comment=';', header=None, sep=sep, names=['date', 'time', 'values'])
    df.index = pd.to_datetime(df.pop('date') + ' ' + df.pop('time'))
    return df['values'].copy()


def peek_swmm_timeseries_data(filename, indices):
    """
    take a peek in a text-file of exported timeseries from the EPA-SWMM-GUI

    Args:
        filename (str): path and filename of the file to be read
        indices (list[int]): list of indices to return

    Returns:
        pandas.Series: time-series-data
    """
    df = pd.read_csv(filename, comment=';', header=None, sep=r'\s+', names=['date', 'time', 'values'])
    try:
        df = df.iloc[indices]
    except:
        pass
    df.index = pd.to_datetime(df.pop('date') + ' ' + df.pop('time'))
    return df['values'].copy()


def read_swmm_rainfall_file(filename):
    """
    read text-file of exported timeseries from the EPA-SWMM-GUI

    SWMM 5.1 User Manual | 11.3 Rainfall Files | S. 165

    Args:
        filename (str): path and filename of the file to be read

    Returns:
        pandas.Series: time-series-data with a mulitindex (Datetime, Station)
    """
    sep = r'\s+'  # space or tab
    df = pd.read_csv(filename, comment=';', header=None, sep=sep,
                     names=['station', 'year', 'month', 'day', 'hour', 'minute', 'values'],
                     )
    df.index = pd.to_datetime(df[['year', 'month', 'day', 'hour', 'minute']])
    return df.set_index('station', append=True)['values'].copy()


def read_swmm_tsf(filename, sep='\t'):
    """
    Read a swmm .tsf-file (TimeSeriesFile).

    An ASCII-file used in PCSWMM to compare simulations results with measured data, or to export simulation results.

    Args:
        filename (str): path and filename of the file to be read
        sep (str): separator of the columns in the file

    Returns:
        pandas.DataFrame: time-series-data-frame
    """
    df = pd.read_csv(filename, comment=';', header=[0, 1, 2], sep=sep, index_col=0)
    # 5/24/2019 12:00:00 AM
    df.index = pd.to_datetime(df.index, format='%m/%d/%Y %I:%M:%S %p')
    df.columns = ['|'.join(c) for c in df.columns]
    return df


def write_calibration_file(df, filename, decimal=3):
    """
    Calibration Files contain measurements of variables at one or more locations that can be compared with simulated values in Time Series Plots.

    Separate files can be used for each of the following:
        - Subcatchment Runoff
        - Subcatchment Groundwater Flow
        - Subcatchment Groundwater Elevation
        - Subcatchment Snow Pack Depth
        - Subcatchment Pollutant Washoff
        - Node Depth
        - Node Lateral Inflow
        - Node Flooding
        - Node Water Quality
        - Link Flow
        - Link Velocity
        - Link Depth

    Calibration files are registered to a project by selecting Project >> Calibration Data from the  Main Menu (see Registering Calibration Data).

    The format of the file is as follows:
        1. The name of the first object with calibration data is entered on a single line.
        2. Subsequent lines contain the following recorded measurements for the object:
            - measurement date (month/day/year, e.g., 6/21/2004) or number of whole days since the start of the simulation
            - measurement time (hours:minutes) on the measurement date or relative to the number of elapsed days
            - measurement value (for pollutants, a value is required for each pollutant).
        3. Follow the same sequence for any additional objects.

    Examples:
        An excerpt from an example calibration file is shown below.
        It contains flow values for two conduits: 1030 and 1602.
        Note that a semicolon can be used to begin a comment.
        In this example, elapsed time rather than the actual measurement date was used.

        ::

            ;Flows for Selected Conduits
            ;Conduit  Days        Time  Flow
            ;-----------------------------
            1030
                       0     0:15  0
                       0     0:30  0
                       0     0:45  23.88
                       0     1:00  94.58
                       0     1:15  115.37
            1602
                       0     0:15  5.76
                       0     0:30  38.51
                       0     1:00  67.93
                       0     1:15  68.01

    Args:
        df (pandas.DataFrame): data
        filename (str | Path): Filename for the calibration file.
        decimal (int): Number of decimal places.
    """
    if isinstance(filename, str):
        filename = Path(filename)

    if filename.suffix != '.dat':
        filename = filename.with_suffix('.dat')

    df_ = df.copy().round(decimal)
    df_.index.name = ';date      time'

    with open(filename, 'w') as f:
        f.write(';;EPA SWMM Calibration Data')

        for col in df.columns:
            f.write('\n\n' + '_'*20 + f'\n{col}\n')

            df_[col].to_csv(f, sep='\t', index=True, header=True, date_format='%m/%d/%Y %H:%M', lineterminator='\n')


def write_calibration_files(*args, **kwargs):
    raise NotImplementedError('Function rename to write_calibration_file (without the `s`)')


def read_calibration_file(filename):
    """
    Read calibration data from file.

    Args:
        filename (str | Path): Filename of the calibration file.

    Returns:
        pandas.DataFrame: time-series-data-frame.
    """
    di_ts = {}
    with open(filename, 'r') as f:
        current_label = None
        for line in f:
            args = line.split()
            if len(args) == 1:
                current_label = args[0]
                di_ts[current_label] = {}
            elif len(args) == 3:
                date_time = tuple(args[:-1])
                if date_time[0].isdecimal() and date_time[1].count(':') > 1:
                    td = pd.Timedelta(days=int(date_time[0]))
                    if date_time[1].count(':') == 1:
                        h, m = date_time[1].split(':')
                        td += pd.Timedelta(hours=int(h), minutes=int(m))
                    elif date_time[1].count(':') == 2:
                        h, m, s = date_time[1].split(':')
                        td += pd.Timedelta(hours=int(h), minutes=int(m), seconds=int(s))
                    date_time = td
                else:
                    date_time = str_to_datetime(date_time[0], date_time[1])
                # relative to start days and HH:MM:SS
                # absolute
                value = float(args[-1])
                di_ts[current_label][date_time] = value
            else:
                print('UNKOWN')
    return pd.DataFrame(di_ts)
