from itertools import groupby

import pandas as pd
import numpy as np

from ..inp import SwmmInput
from ..sections import Pattern, DryWeatherFlow


def get_pattern_time_frame(index, pattern_section):
    """
    Get pattern values as timeseries.

    Args:
        index (pd.DatetimeIndex): datetime-index of the resulting timeseries
        pattern_section (swmm_api.input_file.helpers.InpSection): pattern-section of inp-file

    Returns:
        pd.DataFrame: index=index, columns=pattern.names
    """
    df = pd.DataFrame(index=index)
    temp = pd.DataFrame(index=index)
    i = {}
    CYCLE = Pattern.CYCLES
    for p in pattern_section.values():  # type: Pattern
        if p.cycle not in temp:
            if p.cycle == CYCLE.MONTHLY:
                temp[CYCLE.MONTHLY] = index.month
                i[p.cycle] = range(1, len(p.factors))
            elif p.cycle == CYCLE.DAILY:
                temp[CYCLE.DAILY] = index.dayofweek
                # pandas: 0=Monday & 6=Sunday
                # SWMM: 0=Sunday & 6=Saturday
                i[p.cycle] = [6, 0, 1, 2, 3, 4, 5]
            elif p.cycle == CYCLE.HOURLY:
                temp[CYCLE.HOURLY] = index.hour
                i[p.cycle] = range(len(p.factors))
            elif p.cycle == CYCLE.WEEKEND:
                i[p.cycle] = range(len(p.factors))
                temp[CYCLE.WEEKEND] = index.hour
                weekend = index.dayofweek.isin([5, 6])
                temp.loc[~weekend, CYCLE.WEEKEND] = np.nan

        df[p.name] = temp[p.cycle].map(dict(zip(i[p.cycle], p.factors))).fillna(
            1).round(3)
    return df


def get_pattern_series_prod(df_pattern, group, patterns_section,
                            weekend_index_bool):
    """
    get the time-series product of all needed patterns

    Args:
        df_pattern (pd.DataFrame): frame with patterns as Series
        group (tuple[str]): list of patterns tu multiply
        patterns_section (swmm_api.input_file.helpers.InpSection): pattern-section of inp-file
        weekend_index_bool (pd.Series[bool]): bool-series to show weekends

    Returns:
        pd.Series: index=index, dtype=Float
    """
    group = [g for g in group if isinstance(g, str)]
    df_pattern_ = df_pattern.loc[:, group].copy()
    if any(patterns_section[p].cycle == Pattern.CYCLES.WEEKEND for p in group):
        weekday_pattern = [p for p in group if
                           patterns_section[p].cycle == Pattern.CYCLES.HOURLY]
        df_pattern_.loc[weekend_index_bool, weekday_pattern] = 1
    return df_pattern_.prod('columns')


def get_weekend_bool_series(index):
    """
    get bool-series to show weekends

    Args:
        index (pd.DatetimeIndex): datetime-index of the resulting timeseries

    Returns:
        pd.Series[bool]: bool-series to show weekends
    """
    return index.dayofweek.isin([5, 6])


def get_dwf_node_series(inp, dwf: DryWeatherFlow, index):
    pattern_time_frame = get_pattern_time_frame(index, inp.PATTERNS)
    weekend = get_weekend_bool_series(pattern_time_frame.index)
    ts_pattern_prod = get_pattern_series_prod(pattern_time_frame,
                                              dwf.get_pattern_list(),
                                              inp.PATTERNS, weekend)
    return dwf.base_value * ts_pattern_prod


def prep_factors(values: list, dec=3, even_out=False):
    n = len(values)

    values_round = list(np.round(values, dec))

    if even_out:
        delta = round(np.sum(values_round) - n, dec)
        # kann maximal 0.0049*n sein? vielleicht
        # d = 10**(-dec)

        if delta > 0:  # zu viel = bei Minimum wegnehmen
            i = np.argmin(values)
        elif delta < 0:  # zu wenig = zu Maximum hinzufügen
            i = np.argmax(values)

        if delta != 0:
            values_round[i] = round(values_round[i] - delta, dec)

    return values_round


class MARKER:
    YEAR = 'Y'
    MONTH = Pattern.CYCLES.MONTHLY
    DAY = Pattern.CYCLES.DAILY
    HOURLY = Pattern.CYCLES.HOURLY
    WEEKEND = Pattern.CYCLES.WEEKEND

    SEP = '__'


class PatternRegression:
    def __init__(self, ts, set_cycles=None, with_year=True):
        self.ts = ts.rename('values')

        # --------------------------------------------------------------
        # create additive function
        """Zeitreihe in Jahres-, Monats-, Tages- und Stunden-Parameter zerlegen
        Q = Jahr + Monat + Wochentag + Stunde + Wochenend-Stunde"""
        d = self.ts.to_frame()
        cols = []

        if set_cycles is None:
            set_cycles = {Pattern.CYCLES.MONTHLY, Pattern.CYCLES.DAILY,
                          Pattern.CYCLES.HOURLY, Pattern.CYCLES.WEEKEND}

        is_weekend = d.index.weekday >= 5

        levels = []

        if Pattern.CYCLES.MONTHLY in set_cycles:
            levels.append(f'{MARKER.MONTH}{MARKER.SEP}%m_%b')
        if Pattern.CYCLES.DAILY in set_cycles:
            levels.append(f'{MARKER.DAY}{MARKER.SEP}%w_%a')
        if Pattern.CYCLES.HOURLY in set_cycles:
            levels.append(f'{MARKER.HOURLY}{MARKER.SEP}%H')
        if Pattern.CYCLES.WEEKEND in set_cycles:
            levels.append(f'{MARKER.WEEKEND}{MARKER.SEP}%H')

        if with_year:
            levels.append(f'{MARKER.YEAR}{MARKER.SEP}%Y')

        for fmt in levels:
            col_values = d.index.strftime(fmt)
            for col in col_values.unique():
                cols.append(col)
                if MARKER.HOURLY in fmt:
                    d[col] = ((col_values == col) & ~is_weekend).astype(float)
                elif MARKER.WEEKEND in fmt:
                    d[col] = ((col_values == col) & is_weekend).astype(float)
                else:
                    d[col] = (col_values == col).astype(float)

        self.orig_exog = d
        self.exog = self.orig_exog.copy()
        self.exog.columns = self.convert_index(self.exog.columns)

        import statsmodels.formula.api as smf
        self.ols = smf.ols(f'{self.ts.name} ~ 0 + ' + ' + '.join(cols),
                           data=d).fit()

        parameters_add = self.ols.params.rename('params_ADD').sort_index()
        parameters_add.index = self.convert_index(parameters_add.index)
        self.parameters_add = parameters_add

        # --------------------------------------------------------------
        # additive function to multiplicative function
        self.average_value = 0
        parameters_mul = pd.Series(index=parameters_add.index,
                                   name='params_MUL', dtype=float)

        # ---
        # TODO wenn nur eine liste von Cycles gegeben

        if MARKER.DAY in parameters_add.index.levels[0]:
            days_list = parameters_add.xs(MARKER.DAY, level=0).index.values
            # index_wd = ['1_Mon', '2_Tue', '3_Wed', '4_Thu', '5_Fri']
            # index_we = ['0_Sun', '6_Sat']
            index_wd, index_we = ([list(g) for k, g in groupby(sorted(days_list, key=lambda i: i[0] in '06'), key=lambda i: i[0] in '06')])

            day_wd = parameters_add.xs(MARKER.DAY, level=0).loc[index_wd].mean()
            day_we = parameters_add.xs(MARKER.DAY, level=0).loc[index_we].mean()
        else:
            day_wd = 0
            day_we = 0
        if MARKER.WEEKEND in parameters_add.index.levels[0]:
            hour_we = parameters_add.xs(MARKER.WEEKEND, level=0).mean()
        if MARKER.HOURLY in parameters_add.index.levels[0]:
            hour_wd = parameters_add.xs(MARKER.HOURLY, level=0).mean()

        for g in (MARKER.WEEKEND, MARKER.HOURLY, MARKER.DAY, MARKER.MONTH, MARKER.YEAR):
            if g in parameters_add.index.levels[0]:
                g_values = parameters_add.xs(g, level=0).copy()
                if g == MARKER.DAY:
                    g_values.loc[index_wd] += hour_wd
                    g_values.loc[index_we] += hour_we
                elif g == MARKER.WEEKEND:
                    g_values += day_we
                    g_base = hour_we + day_we
                elif g == MARKER.HOURLY:
                    g_values += day_wd
                    g_base = hour_wd + day_wd
                else:
                    g_base = g_values.mean()

                parameters_mul.loc[(g, g_values.index)] = (g_values - g_base).values
                if g in (MARKER.DAY, MARKER.MONTH, MARKER.YEAR):
                    self.average_value += g_base
        if (MARKER.DAY not in parameters_add.index.levels[0]) and (MARKER.MONTH not in parameters_add.index.levels[0]):
            self.average_value = hour_wd

        self.parameters_mul = (parameters_mul + self.average_value) / self.average_value

        # == validation ==
        # print(ts.sum())
        #
        # inp = self.resulting_inp_data()
        # ts2 = get_dwf_node_series(self.resulting_inp_data(), inp.DWF[('node', DryWeatherFlow.TYPES.FLOW)], index=ts.index)
        # print(ts2.sum())
        #
        # from statsmodels.tools.eval_measures import rmse
        # print(f'{rmse(ts, ts2)=}')


    def _get_pattern(self, pattern_type, even_out=False):
        factors = prep_factors(
            self.parameters_mul.loc[pattern_type].sort_index(),
            even_out=even_out)
        return Pattern(f'{label}_DW_{pattern_type}', pattern_type,
                       factors=factors)

    def get_daily_pattern(self):
        return self._get_pattern(Pattern.CYCLES.DAILY)

    def get_monthly_pattern(self):
        return self._get_pattern(Pattern.CYCLES.MONTHLY)

    def get_hourly_pattern(self):
        return self._get_pattern(Pattern.CYCLES.HOURLY)

    def get_weekend_pattern(self):
        return self._get_pattern(Pattern.CYCLES.WEEKEND)

    def new_inp_objects(self, node_label='node', constituent=DryWeatherFlow.TYPES.FLOW):
        # pattern_types = (Pattern.CYCLES.WEEKEND, Pattern.CYCLES.HOURLY,
        #                  Pattern.CYCLES.DAILY, Pattern.CYCLES.MONTHLY)
        pattern_types = set(self.parameters_mul.index.levels[0])
        return (
            *(Pattern(f'{node_label}_DW_{constituent}_{pattern_type}', pattern_type, factors=prep_factors(self.parameters_mul.loc[pattern_type].sort_index()))
                for pattern_type in pattern_types),
            DryWeatherFlow(node_label, constituent, self.average_value,
                           *(f'{node_label}_DW_{constituent}_{pattern_type}' for pattern_type
                             in pattern_types))
        )

    def resulting_inp_data(self):
        inp = SwmmInput()
        inp.add_multiple(*self.new_inp_objects())
        return inp

    @staticmethod
    def convert_index(index):
        return pd.MultiIndex.from_tuples(i.split(MARKER.SEP) for i in index)

    def get_additive_predict(self):
        return self.ols.predict(self.orig_exog)

    def get_multiplicative_predict(self, no_year=False):
        multi_frame = self.parameters_mul.replace(0, 1)
        if no_year:
            multi_frame = multi_frame.loc[[MARKER.DAY, MARKER.MONTH], :].copy()
        return (self.exog * multi_frame).replace(0, 1).prod(
            axis=1) * self.average_value

    # def get_confidence_interval(self):
    #     # additive
    #     conf_int_ADD = self.ols.conf_int().copy()
    #     conf_int_ADD.index = self.convert_index(conf_int_ADD.index)
    #     return conf_int_ADD
    # 
    # def plot_pattern_conf_int(self):
    #     ADD = 'params_ADD'
    #     MUL = 'params_MUL'
    # 
    #     params = pd.concat([self.parameters_add, self.parameters_mul], axis=1)
    #     params['conf_int_ADD'] = self.get_confidence_interval().diff(axis=1)[1] / 2
    #     params['conf_int_MUL'] = params['conf_int_ADD'] / self.average_value
    #     from matplotlib import pyplot as plt
    #     from matplotlib.patches import Rectangle
    #     for pattern_type in [Pattern.CYCLES.DAILY, Pattern.CYCLES.MONTHLY]:
    #         if pattern_type not in params.index:
    #             continue
    #         params_i = params.loc[pattern_type, :]
    # 
    #         pattern = self._get_pattern(pattern_type)
    #         # print(pattern)
    # 
    #         fig, ax = plt.subplots(figsize=(6, 4), dpi=120)
    #         patter_lines(ax, pattern, add_value=True)
    # 
    #         ax.set_ylim(
    #             (params_i[MUL] - params_i['conf_int_MUL']).min(),
    #             (params_i[MUL] + params_i['conf_int_MUL']).max()
    #         )
    # 
    #         format_pattern_axes(ax, pattern_type, make_striped_background=True)
    # 
    #         error_boxes = []
    #         for k, (m, i) in enumerate(zip(params_i[MUL].sort_index().round(3).values,
    #                                        params_i['conf_int_MUL'].sort_index().round(3).values)):
    #             error_boxes.append(Rectangle((k - 0.5, m - i), 1, i * 2))
    #             # ax.plot([k, k], [m - i, m + i], color='black', lw=0.5)
    #         from matplotlib.collections import PatchCollection
    #         pc = PatchCollection(error_boxes, facecolor=PATTERN_COLORS[pattern.cycle], alpha=0.2)
    # 
    #         # Add collection to axes
    #         ax.add_collection(pc)
    # 
    #         fig.tight_layout()
    #         # fig.show()
    #         # fig.clear()
    #         yield fig, ax, pattern_type


def combine_dwf(inp: SwmmInput, node_to_add, node_base, constituent):
    # dummy index -> no meaning -> must be one year to fit all patterns
    index = pd.date_range('2022-01-01 00:00', '2023-01-01 00:00', freq='h',
                          inclusive='left')

    if isinstance(node_to_add, DryWeatherFlow):
        dwf_to_add = node_to_add
    else:
        dwf_to_add = inp.DWF[(node_to_add, constituent)]

    if isinstance(node_base, DryWeatherFlow):
        dwf_base = node_base
    else:
        dwf_base = inp.DWF[(node_base, constituent)]

    ts = get_dwf_node_series(inp, dwf_to_add, index=index)
    ts2 = get_dwf_node_series(inp, dwf_base, index=index)

    set_cycles = set()
    for p in dwf_base.get_pattern_list() + dwf_to_add.get_pattern_list():
        set_cycles.add(inp.PATTERNS[p].cycle)

    if Pattern.CYCLES.DAILY in set_cycles:
        if Pattern.CYCLES.HOURLY in set_cycles:
            set_cycles.add(Pattern.CYCLES.WEEKEND)
        if Pattern.CYCLES.WEEKEND in set_cycles:
            set_cycles.add(Pattern.CYCLES.HOURLY)

    ts_sum = ts + ts2
    pr = PatternRegression(ts_sum, set_cycles, with_year=False)

    inp.add_multiple(
        *pr.new_inp_objects(node_base, constituent)
    )
