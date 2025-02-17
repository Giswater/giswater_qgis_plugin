import warnings
from pathlib import Path
from statistics import mean

import pandas as pd

from ._helpers import SwmmApiInputMacrosWarning
from .collection import nodes_dict, links_dict
from .graph import links_connected
from .tags import get_subcatchment_tags, get_node_tags
from .. import SEC
from ..inp import SwmmInput
from ..section_labels import *
from ..section_lists import LINK_SECTIONS, NODE_SECTIONS
from ..sections import TimeseriesFile, TemperatureSection
from ..sections.link import _Link, Conduit, Weir, Outlet, Orifice
from ..sections.link_component import CrossSection

"""
a collection of macros to manipulate an inp-file

use this file as an example for the usage of this package
"""


########################################################################################################################
def find_node(inp: SwmmInput, label):
    """
    find node in inp-file data

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str): node Name/label

    Returns:
        _Node | Junction | swmm_api.input_file.sections.node.Storage | Outfall: searched node (if not found None)
    """
    return nodes_dict(inp).get(label, None)


def find_link(inp: SwmmInput, label):
    """
    find link in inp-file data

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str): link Name/label

    Returns:
        _Link | Conduit | Weir | Outlet | Orifice | Pump: searched link (if not found None)
    """
    return links_dict(inp).get(label, None)


########################################################################################################################
def calc_slope(inp: SwmmInput, conduit):
    """
    calculate the slop of a conduit

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        conduit (Conduit): link

    Returns:
        float: slop of the link
    """
    nodes = nodes_dict(inp)
    return (nodes[conduit.from_node].elevation + conduit.offset_upstream - (
            nodes[conduit.to_node].elevation + conduit.offset_downstream)) / conduit.length


def conduit_slopes(inp: SwmmInput):
    """
    get the slope of all conduits

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        pandas.Series: slopes
    """
    slopes = {}
    for conduit in inp.CONDUITS.values():
        slopes[conduit.name] = calc_slope(inp, conduit)
    return pd.Series(slopes)


########################################################################################################################
def _rel_diff(a, b):
    m = mean([a + b])
    if m == 0:
        return abs(a - b)
    return abs(a - b) / m


def _rel_slope_diff(inp: SwmmInput, l0, l1):
    nodes = nodes_dict(inp)
    slope_res = (nodes[l0.from_node].elevation + l0.offset_upstream
                 - (nodes[l1.to_node].elevation + l1.offset_downstream)
                 ) / (l0.length + l1.length)
    return _rel_diff(calc_slope(inp, l0), slope_res)


########################################################################################################################
def conduits_are_equal(inp: SwmmInput, link0, link1, diff_roughness=0.1, diff_slope=0.1, diff_height=0.1):
    """
    check if the links (with all there components) are equal

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        link0 (Conduit | Weir | Outlet | Orifice | Pump | _Link): first link
        link1 (Conduit | Weir | Outlet | Orifice | Pump | _Link): second link
        diff_roughness (float | None): difference from which it is considered different.
        diff_slope (float | None): difference from which it is considered different.
        diff_height (float | None): difference from which it is considered different.

    Returns:
        bool: if the links are equal
    """
    all_checks_out = True

    if type(link0) != type(link1):
        return False

    # Roughness values match within a specified percent tolerance
    # only conduits
    if (diff_roughness is not None) and isinstance(link0, Conduit) and isinstance(link1, Conduit):
        all_checks_out &= _rel_diff(link0.roughness, link1.roughness) < diff_roughness

    xs0 = inp[XSECTIONS][link0.name]  # type: CrossSection
    xs1 = inp[XSECTIONS][link1.name]  # type: CrossSection

    # Diameter values match within a specified percent tolerance (1 %)
    if diff_height is not None:
        all_checks_out &= _rel_diff(xs0.height, xs1.height) < diff_height

    # Cross-section shapes must match exactly
    all_checks_out &= xs0.shape == xs1.shape

    # Shape curves must match exactly
    if xs0.shape == CrossSection.SHAPES.CUSTOM:
        all_checks_out &= xs0.curve_name == xs1.curve_name

    # Transects must match exactly
    elif xs0.shape == CrossSection.SHAPES.IRREGULAR:
        all_checks_out &= xs0.transect == xs1.transect

    # Slope values match within a specified tolerance
    # only conduits
    if (diff_slope is not None) and isinstance(link0, Conduit) and isinstance(link1, Conduit):
        rel_slope_diff = _rel_diff(calc_slope(inp, link0), calc_slope(inp, link1))

        # if rel_slope_diff < 0:
        #     nodes = nodes_dict(inp)
        #     print(nodes[link0.FromNode].Elevation, link0.InOffset, nodes[link0.ToNode].Elevation, link0.OutOffset)
        #     print(nodes[link1.FromNode].Elevation, link1.InOffset, nodes[link1.ToNode].Elevation, link1.OutOffset)
        #     print('rel_slope_diff < 0', link0, link1)
        all_checks_out &= rel_slope_diff < diff_slope

    return all_checks_out


def update_no_duplicates(inp_base, inp_update) -> SwmmInput:
    inp_new = inp_base.copy()
    inp_new.update(inp_update)

    for node in nodes_dict(inp_new):
        if sum((node in inp_new[s] for s in NODE_SECTIONS + [SUBCATCHMENTS] if s in inp_new)) != 1:
            for s in NODE_SECTIONS + [SUBCATCHMENTS]:
                if (s in inp_new) and (node in inp_new[s]) and (node not in inp_update[s]):
                    del inp_new[s][node]

    for link in links_dict(inp_new):
        if sum((link in inp_new[s] for s in LINK_SECTIONS if s in inp_new)) != 1:
            for s in LINK_SECTIONS:
                if (s in inp_new) and (link in inp_new[s]) and (link not in inp_update[s]):
                    del inp_new[s][link]

    return inp_new


########################################################################################################################
def increase_max_node_depth(inp, node_label):
    # swmm raises maximum node depth to surrounding xsection height
    previous_, next_ = links_connected(inp, node_label)
    node = nodes_dict(inp)[node_label]
    max_height = node.MaxDepth
    for link in previous_ + next_:
        max_height = max((max_height, inp[XSECTIONS][link.name].height))
    print(f'MaxDepth increased for node "{node_label}" from {node.MaxDepth} to {max_height}')
    node.MaxDepth = max_height


def set_times(inp, start, end, head=None, tail=None):
    """
    set start and end time of the inp-file

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        start (datetime.datetime): start time of the simulation and the reporting
        end (datetime.datetime): end time of the simulation
        head (datetime.timedelta): brings start time forward
        tail (datetime.timedelta): brings end time backward

    Returns:
        SwmmInput: changed inp data
    """
    if head is None:
        sim_start = start
    else:
        sim_start = start - head

    if tail is not None:
        end += tail

    report_start = start

    inp.OPTIONS.set_start(sim_start)
    inp.OPTIONS.set_report_start(report_start)
    inp.OPTIONS.set_end(end)
    # inp[OPTIONS]['START_DATE'] = sim_start.date()
    # inp[OPTIONS]['START_TIME'] = sim_start.time()
    # inp[OPTIONS]['REPORT_START_DATE'] = report_start.date()
    # inp[OPTIONS]['REPORT_START_TIME'] = report_start.time()
    # inp[OPTIONS]['END_DATE'] = end.date()
    # inp[OPTIONS]['END_TIME'] = end.time()
    return inp


def combined_subcatchment_frame(inp: SwmmInput):
    """
    combine all information of the subcatchment data-frames

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        pandas.DataFrame: combined subcatchment data
    """
    df = inp[SUBCATCHMENTS].frame.join(inp[SUBAREAS].frame).join(inp[INFILTRATION].frame)
    df = df.join(get_subcatchment_tags(inp))
    return df


def combined_nodes_frame(inp: SwmmInput):
    pass  # TODO


def nodes_data_frame(inp, label_sep='.'):
    nodes_tags = get_node_tags(inp)
    res = None
    for s, _ in inp.iter_avail_sections(NODE_SECTIONS):
        df = inp[s].frame.rename(columns=lambda c: f'{label_sep}{c}')

        if s == STORAGE:
            df[f'{STORAGE}{label_sep}data'] = df[f'{STORAGE}{label_sep}data'].astype(str)

        for sub_sec in [DWF, INFLOWS]:
            if sub_sec in inp:
                x = inp[sub_sec].frame.unstack(1)
                x.columns = [f'{label_sep}'.join([sub_sec, c[1], c[0]]) for c in x.columns]
                df = df.join(x)

        df = df.join(inp[COORDINATES].frame).join(nodes_tags)

        if res is None:
            res = df
        else:
            res = res.append(df)
    return res


def iter_sections(inp: SwmmInput, section_list: (list, tuple, set)):
    inp.iter_avail_sections(section_list)


def delete_sections(inp: SwmmInput, section_list: (list, tuple, set)):
    inp.delete_sections(section_list)


def set_absolute_file_paths(inp, path_data_base):
    """
    Change the paths in the input file to absolute paths.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        path_data_base (str | pathlib.Path): absolute path where the files are stored.
    """
    path_data_base = Path(path_data_base)

    if FILES in inp:
        warnings.warn('set_absolute_file_paths for FILES not implemented.', SwmmApiInputMacrosWarning)

    if RAINGAGES in inp:
        for rg in inp.RAINGAGES.values():
            if isinstance(rg.filename, str):
                rg.filename = path_data_base / rg.filename

    if TEMPERATURE in inp:
        if TemperatureSection.KEYS.FILE in inp.TEMPERATURE:
            inp.TEMPERATURE[TemperatureSection.KEYS.FILE] = path_data_base / inp.TEMPERATURE[TemperatureSection.KEYS.FILE]

    if TIMESERIES in inp:
        for ts in inp.TIMESERIES.values():
            if isinstance(ts, TimeseriesFile):
                ts.filename = path_data_base / ts.filename


def convert_cms_to_lps(inp: SwmmInput):
    # TODO Testing
    #   not tested: CONTROLS, DIVIDERS(CUTOFF), WEIRS(discharge coefficient), INLET_USAGE(Q_max)

    if SEC.CONDUITS in inp:
        for c in inp.CONDUITS.values():
            c.flow_max *= 1000
            c.flow_initial *= 1000

    if SEC.CURVES in inp:
        for c in inp.CURVES.values():
            from ..sections import Curve
            if c.kind in {Curve.TYPES.DIVERSION, Curve.TYPES.PUMP1, Curve.TYPES.PUMP2, Curve.TYPES.PUMP3, Curve.TYPES.PUMP4, Curve.TYPES.RATING}:
                for row in range(len(c.points)):
                    c.points[row][1] *= 1000

    if SEC.DWF in inp:
        for d in inp.DWF.values():
            if d.constituent == d.TYPES.FLOW:
                d.base_value *= 1000

    if SEC.INFLOWS in inp:
        for i in inp.INFLOWS.values():
            if i.constituent == i.TYPES.FLOW:
                i.scale_factor *= 1000
                i.base_value *= 1000

    if SEC.OPTIONS in inp:
        inp.OPTIONS['FLOW_UNITS'] = 'LPS'

    warnings.warn('convert_cms_to_lps(inp): Not every section is converted.', SwmmApiInputMacrosWarning)
