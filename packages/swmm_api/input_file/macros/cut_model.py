from pathlib import Path

import pandas as pd

from .graph import inp_to_graph
from .graph import _previous_links_labels
from .collection import nodes_dict
from ...external_files.dat_timeseries import write_swmm_timeseries_data
from ..sections import Inflow, TimeseriesFile
from ...output_file import OBJECTS, VARIABLES


def create_cut_model(inp_base, inp_sub, out_base, working_dir):
    """
    Create a new model where on every border-node with cut inflow-links, a timeseries as inflow is added.

    For each inflow a new dat-file is created.

    Caution:
        only for FLOW right now!

    Args:
        inp_base (swmm_api.SwmmInput):
        inp_sub (swmm_api.SwmmInput):
        out_base (swmm_api.SwmmOutput):
        working_dir (str | pathlib.Path): the directory to save the inp and dat files
    """
    nodes_sub = nodes_dict(inp_sub)
    graph_base = inp_to_graph(inp_base)
    graph_sub = inp_to_graph(inp_sub)
    inp_sub.check_for_section(Inflow)

    working_dir = Path(working_dir)
    working_dir.mkdir(parents=True, exist_ok=True)

    for node in nodes_sub:
        links_connects_base = set(_previous_links_labels(graph_base, node))
        links_connects_sub = set(_previous_links_labels(graph_sub, node))
        inflows_to_add = links_connects_base - links_connects_sub
        if inflows_to_add:
            ts = out_base.get_part(OBJECTS.LINK, list(inflows_to_add), VARIABLES.LINK.FLOW)
            if isinstance(ts, pd.DataFrame):
                ts = ts.sum(axis=1)
            if (node, Inflow.TYPES.FLOW) in inp_sub.INFLOWS:
                print(f'inflow in node {node} will be overwritten!')

            if ts.round(1).lt(0).any():
                print(f'inflow in node {node} is negative! Backflow is not good! ts_min = {ts.min():0.1f} L/s')

            label_ts = f'CUT_TS_{node}'
            fn_ts = f'CUT_TS_{node}.dat'
            inp_sub.TIMESERIES.add_obj(
                TimeseriesFile(label_ts, fn_ts)
            )
            inp_sub.INFLOWS.add_obj(
                Inflow(node, time_series=label_ts)
            )
            write_swmm_timeseries_data(ts.round(1), working_dir/fn_ts)

    return inp_sub
