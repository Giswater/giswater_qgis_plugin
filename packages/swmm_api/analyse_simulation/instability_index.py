from matplotlib import pyplot as plt

from ..output_file.definitions import OBJECTS, VARIABLES, di_flow_unit_label


def plot_time_series_instabile_links(inp, rpt, out):
    """
    Plot time series of link flow with the highest instability index.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        rpt (swmm_api.SwmmReport): report data
        out (swmm_api.SwmmOutput): output data

    Returns:
        (plt.Figure, plt.Axes): figure with subplots of all link flows
    """
    di_index = rpt.highest_flow_instability_indexes
    link_labels = list(di_index)
    n = len(link_labels)

    df = out.get_part(OBJECTS.LINK, label=link_labels, variable=VARIABLES.LINK.FLOW)

    unit = di_flow_unit_label[out.flow_unit]

    fig, axes = plt.subplots(n, sharex=True)
    for i, (ax, link_label) in enumerate(zip(axes, link_labels)):
        df[link_label].plot(ax=ax, color=f'C{i}')
        ax.set_title(f'{link_label}\nflow instability index = {di_index[link_label]}/150')
        ax.set_ylabel(f'flow in {unit}')
        ax.axhline(0, ls='--', color='lightgrey')

    fig.set_size_inches(8, 9)
    return fig, axes
