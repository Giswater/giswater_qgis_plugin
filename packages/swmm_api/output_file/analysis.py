import pandas as pd


def _expanding_time_max(array):
    """
    calculate the expanding max of a series with datetime data

    Args:
        array (numpy.ndarray): datetime data

    Returns:
        numpy.ndarray: datetime data
    """
    new_array = []
    for a in array:
        if new_array and (a < new_array[-1]):
            new_array.append(new_array[-1])
        else:
            new_array.append(a)
    return new_array


def agg_events(events, series, agg='sum'):
    """
    aggregate the series data over the single events

    Args:
        events (pandas.DataFrame): table of events with 'start' and 'end' times
        series (pandas.Series): data
        agg (str | function): aggregation of timeseries

    Returns:
        pandas.Series: result of function of every event
    """

    def _agg_event(event):
        return series[event['start']:event['end']].agg(agg)

    if events.empty:
        return pd.Series(dtype=object)

    return events.apply(_agg_event, axis=1)


def get_event_table(span_bool, delta_separation=pd.Timedelta(hours=6)):
    """
    Create an events-table for time-spans with consistent ``True``-values.

    combine narrow (less than <delta_separation>) respectively overlapping events in table


    Args:
        span_bool (pandas.Series[bool]): "True"=Event
        delta_separation (pandas.Timedelta): minimum duration between events - otherwise they get combined

    Returns:
        pandas.DataFrame: with the columns:
            'start' = start-time,
            'end' = end-time,
    """
    freq = span_bool.index.freq

    # pandas.Series with DatetimeIndex as index AND data
    # only with rows where an event occurs
    temp = span_bool.index[span_bool].to_series()

    # When the duration to previous event value is greater than `min_span` than an event starts.

    # first value in diff will default to NaN
    # fill value is set to double the value of the greater than operation = fixed true value

    # start_bool = temp.diff().gt(freq, fill_value=freq * 2)  # not working for monthly or yearly frequency
    start_bool = temp > (temp.shift(fill_value=temp.index[0] - 2 * freq) + freq)

    end_bool = start_bool.shift(-1, fill_value=True)

    events = pd.DataFrame()
    events['start'] = temp[start_bool].to_list()
    events['end'] = temp[end_bool].to_list()

    if events.empty:
        return events

    events['new_end'] = _expanding_time_max(events['end'])
    events['new_index'] = (events['start'] - events['new_end'].shift()) > delta_separation
    del events['new_end']
    events['new_index'] = events['new_index'].cumsum() + 1
    events = events.groupby('new_index').agg({'start': 'min', 'end': 'max'})
    events.reset_index(drop=True, inplace=True)

    events['duration'] = events['end'] - events['start']

    return events


# report > statistics
# out series
# event time period = event-dependent, daily, monthly, annual
# statistics: total, mean, peak, duration, inter-event-time

# event thresholds:
# value (intensity, flow, ...)
# event volume
# separation time in hours

# with node depth and pollutant only mean and peak and no event volume possible

# start date, duration in hours, total, exceedance frequency in %, return period in month
# histogram (percent of total, event total)
# frequency plot (log exceedance frequency in %, event total)

"""
  S U M M A R Y   S T A T I S T I C S
  ===================================
  Object  .............. System 
  Variable ............. Precipitation  (in/hr)
  Event Period ......... Variable
  Event Statistic ...... Total (in)
  Event Threshold ...... Precipitation > 0.0000  (in/hr)
  Event Threshold ...... Event Volume > 0.0000 (in)
  Event Threshold ...... Separation Time >= 6.0  (hr)
  Period of Record ..... 01/01/1998 to 01/02/2000

  Number of Events ..... 213
  Event Frequency*...... 0.076
  Minimum Value ........ 0.010
  Maximum Value ........ 3.350
  Mean Value ........... 0.309
  Std. Deviation ....... 0.449
  Skewness Coeff. ...... 3.161

  *Fraction of all reporting periods belonging to an event.
"""