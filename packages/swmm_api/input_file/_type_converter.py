import datetime
import re
import locale
# from collections import UserString

import numpy as np
import pandas as pd
from pandas.tseries.frequencies import to_offset

from .._io_helpers import CONFIG


def to_bool(x):
    if isinstance(x, bool):
        return x
    elif isinstance(x, str):
        if x.upper() == 'YES':
            return True
        elif x.upper() == 'NO':
            return False
        else:
            raise NotImplemented(f'x not a "YES" or "NO" but "{x}"')
    else:
        raise NotImplemented(f'x not a bool: "{x}" | type={type(x)}')


def infer_type(x):
    """
    Infer generic type of inp-file-string

    Args:
        x (str | list[str]):

    Returns:
        object: object depending on string
    """
    if isinstance(x, (list, np.ndarray)):
        return [infer_type(i) for i in x]
    elif not isinstance(x, str):
        return x
    elif x.upper() == 'YES':
        return True
    elif x.upper() == 'NO':
        return False
    elif x.upper() == 'NONE':
        return None
    elif x.replace('-', '').isdecimal():
        return int(x)
    elif ('.' in x) and (x.lower().replace('.', '').replace('-', '').replace('e', '').isdecimal()):
        return float(x)
    elif x.count('/') == 2:
        return datetime.datetime.strptime(x, '%m/%d/%Y').date()
    # elif x.count('/') == 1:
    #     return to_datetime(x, format='%m/%d').date()
    elif (x.count(':') == 2) and (len(x) == 8):
        return datetime.datetime.strptime(x, '%H:%M:%S').time()
    elif (x.count(':') == 1) and (len(x) == 5):
        return datetime.datetime.strptime(x, '%H:%M').time()
    else:
        return x


def infer_offset_elevation(x):
    """
    Convert string to float.

    Used for link offset parameter.
    "*" if the option in SWMM is set to "offset measured as elevation" and no offset for this link is set.
    Otherwise, the input is always a float.

    Args:
        x (str | float): input from object creation

    Returns:
        float | str: converted output
    """
    if is_placeholder(x):
        return x
    else:
        return float(x)


def str_to_datetime(date=None, time=None, str_only=False):
    if date:
        if '-' in date:
            date = date.replace('-', '/')

        month = date.split('/')[0]
        if len(month) <= 2:
            month_format = '%m'
        elif len(month) == 3:
            month_format = '%b'
        else:
            raise NotImplementedError(date)

        if date.count('/') == 2:
            date_format2 = '/%d/%Y'
        else:
            raise NotImplementedError(date)
    else:
        date = ''
        month_format = ''
        date_format2 = ''

    if time:
        if date == '':
            parts = time.split(':')
            if len(parts) == 1:
                return float(parts[0])
            elif len(parts) == 2:
                return float(parts[0]) + float(parts[1])/60
            elif len(parts) == 3:
                return float(parts[0]) + float(parts[1])/60 + float(parts[2])/60/60
        else:
            time_format = '%H:%M:%S'
            if time.count(':') == 1:
                # time_format = '%H:%M'
                time += ':00'
            elif time.count(':') == 2:
                # if len(time) == 7:
                #     time = '0'+ time
                pass
                # time_format = '%H:%M:%S'
            elif time.count(':') == 0:
                hours = float(time)
                h = int(hours)
                minutes = (hours - h)*60
                m = int(minutes)
                s = int((minutes - m)*60)
                time = f'{h:02d}:{m:02d}:{s:02d}'

            else:
                raise NotImplementedError(time)

    else:
        time = ''
        time_format = ''

    if str_only:
        return f'{date} {time}'
    else:
        try:
            dt = datetime.datetime.strptime(f'{date} {time}', f'{month_format}{date_format2} {time_format}')
        except ValueError:  # ValueError: time data 'May/01/2020 0:00:10' does not match format '%b/%d/%Y %H:%M:%S'
            loc = locale.getlocale()
            locale.setlocale(locale.LC_TIME, 'en_US.utf8')  # use default locale for SWMM dates
            dt = datetime.datetime.strptime(f'{date} {time}', f'{month_format}{date_format2} {time_format}')
            locale.setlocale(locale.LC_TIME, loc)  # restore saved locale
        return dt


def datetime_to_str(dt):
    if isinstance(dt, float):
        hours = dt
        h = int(round(hours, 4))
        minutes = (hours - h) * 60
        m = int(round(minutes, 4))
        t = f'{h:02d}:{m:02d}'
        second = (minutes - m) * 60
        s = int(round(second, 4))
        if s:
            t += f':{s:02d}'
        return t
    elif isinstance(dt, int):
        return f'{dt:02d}:00'
    elif isinstance(dt, str):
        return dt
    elif isinstance(dt, datetime.datetime):
        return dt.strftime('%m/%d/%Y %H:%M:%S')


def time2delta(t):
    return datetime.timedelta(hours=t.hour, minutes=t.minute, seconds=t.second)


def delta2time(d):
    return datetime.datetime(2000, 1, 1, d.components.hours, d.components.minutes, d.components.seconds).time()


def delta2offset(d):
    return to_offset(d)


def offset2delta(o):
    return pd.to_timedelta(o)


def delta2str(d):
    """

    Args:
        d (pandas.Timedelta):

    Returns:
        str: HH:MM:SS
    """
    hours, remainder = divmod(d.total_seconds(), 3600)
    minutes, seconds = divmod(remainder, 60)
    return f'{hours:02.0f}:{minutes:02.0f}:{seconds:02.0f}'


def type2str(x):
    """
    Convert any type to a string

    Args:
        x (any):

    Returns:
        str:
    """
    if isinstance(x, str):
        if ' ' in x:
            return f'"{x}"'
        return x
    elif isinstance(x, list):
        return ' '.join([type2str(i) for i in x])
    elif isinstance(x, bool):
        return 'YES' if x else 'NO'
    elif x is None:
        return 'NONE'
    elif isinstance(x, int):
        return str(x)
    elif isinstance(x, float):
        if pd.isna(x):
            return ''
        if x == 0.0:
            return '0'
        return f'{x:0.7G}'  # .rstrip('0').rstrip('.')
    elif isinstance(x, datetime.date):
        return x.strftime('%m/%d/%Y')
    elif isinstance(x, datetime.time):
        return x.strftime('%H:%M:%S')
    elif isinstance(x, (pd.Timedelta, datetime.timedelta)):
        return delta2str(x)
    else:
        return str(x)


def is_nan(x):
    return isinstance(x, float) and np.isnan(x)


def is_placeholder(x):
    return isinstance(x, str) and (x == '*')


def is_not_set(x):
    return is_nan(x) or is_placeholder(x)


def is_set(x):
    return not is_not_set(x)


def get_default_if_not_set(x, default):
    if is_not_set(x):
        return default
    return x


def is_equal(x1, x2, precision=3):
    if is_nan(x1) and is_nan(x2):
        return True
    else:
        if isinstance(x1, float):
            x1 = round(x1, precision)
        if isinstance(x2, float):
            x2 = round(x2, precision)
        return x1 == x2


def convert_string(x) -> str:
    if pd.isna(x):
        return x
    x = str(x)
    s = x.strip(' "')
    if s == '':
        return np.nan
    return s


def convert_args(args):
    # if any arg is a string of a list, tuple or set -> convert type
    args_fix = []
    for a in args:
        if isinstance(a, str) and ((('[' in a) and (']' in a)) or (('(' in a) and (')' in a)) or (('{' in a) and ('}' in a))):
            a = list(eval(a))
            args_fix += a
        else:
            args_fix.append(a)
    return args_fix


def get_gis_inp_decimals():
    return CONFIG.gis_decimals


def format_inp_geo_number(x):
    return f'{x:0.{get_gis_inp_decimals()}f}'


# ignore comments after a semicolon
_SECTION_PATTERN = re.compile(r'^[ \t]*([^;\n]+)[ \t]*;?[^\n]*$', flags=re.M)

# split at whitespace but keep text between "-sign together
_LINE_SPLITTER = re.compile(r'(?:"[^"]*"|\S)+')


def get_line_splitter(section_string):
    if '"' in section_string:
        return lambda l: _LINE_SPLITTER.findall(l)  # split at whitespace but keep text between "-sign together
    else:
        return lambda l: l.split()


def txt_to_lines(content):
    """
    Converts text to multiple line arguments.

    Comments will be ignored:
        ;; section comment
        ; object comment / either inline(at the end of the line) or before the line

    Args:
        content (str): section text
    Yields:
        list[str]: arguments per line in the input file section
    """

    _split_line = get_line_splitter(content)

    for line in _SECTION_PATTERN.finditer(content):
        yield _split_line(line.group())


# class CaseInsensitiveString(UserString):
#     pass


# cistr = CaseInsensitiveString
