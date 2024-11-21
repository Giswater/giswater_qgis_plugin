from .. import SwmmInput
from .. import SEC
from .macros import nodes_dict, links_dict


def print_summary(inp):
    """
    Print basic summary of the inp-data.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
    """
    if SEC.OPTIONS in inp and "ROUTING_STEP" in inp.OPTIONS:
        print(f'ROUTING_STEP: {inp.OPTIONS["ROUTING_STEP"]}')
    print(f'NODES: {len(nodes_dict(inp)):_d}')
    print(f'   JUNCTIONS: {len(inp[SEC.JUNCTIONS])}')
    print(f'   STORAGE: {len(inp[SEC.STORAGE])}')
    print(f'   OUTFALLS: {len(inp[SEC.OUTFALLS])}')
    print(f'LINKS: {len(links_dict(inp)):_d}')
    print(f'   CONDUITS: {len(inp[SEC.CONDUITS])}')
    print(f'   WEIRS: {len(inp[SEC.WEIRS])}')
    print(f'   OUTLETS: {len(inp[SEC.OUTLETS])}')
    print(f'   ORIFICES: {len(inp[SEC.ORIFICES])}')
    if SEC.SUBAREAS in inp:
        print(f'SUBCATCHMENTS: {len(inp.SUBAREAS.keys()):_d}')
    if SEC.POLLUTANTS in inp:
        print(f'POLLUTANTS: {len(inp.POLLUTANTS.keys()):_d}')


def short_status(inp):
    for section in inp:
        print(f'{section}: {len(inp[section])}')