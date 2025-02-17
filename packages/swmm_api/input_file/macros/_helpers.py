import warnings
import logging
from functools import wraps

from .._type_converter import is_placeholder
from ..section_labels import STORAGE, OUTFALLS, OUTLETS, PUMPS, XSECTIONS, POLLUTANTS
from ..sections import Inflow


def get_used_curves(inp):
    """
    Get the used curves from the sections [STORAGE, OUTFALLS, OUTLETS, PUMPS and XSECTIONS].

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        set[str]: set of names of used curves
    """
    used_curves = set()
    for section in [STORAGE, OUTFALLS, OUTLETS, PUMPS, XSECTIONS]:
        if section in inp:
            for name in inp[section]:
                if isinstance(inp[section][name].curve_name, str):
                    if (section == PUMPS) and is_placeholder(inp[section][name].curve_name):
                        continue
                    used_curves.add(inp[section][name].curve_name)
    return used_curves


def get_constituents(inp):
    """
    Get constituents (FLOW + Pollutens) from inp-data.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        list: list of constituents (FLOW + Pollutens)
    """
    constituents = [Inflow.TYPES.FLOW]
    if POLLUTANTS in inp:
        constituents += list(inp.POLLUTANTS)
    return constituents


class SwmmApiInputMacrosWarning(UserWarning): ...


def equals_case_insensitive(string1, string2):
    return string1.lower() == string2.lower()


# Set up a global logger for swmm-api macros
logger = logging.getLogger('swmm_api.input_file.macros')


def verbose_logging(func):
    @wraps(func)
    def wrapper(*args, verbose=False, **kwargs):
        # If verbose is True, set up logging
        if verbose:
            logger.setLevel(logging.DEBUG)
            handler = logging.StreamHandler()
            # formatter = logging.Formatter('%(pathname)s:%(lineno)03d [%(levelname)5s] %(asctime)s | %(funcName)s() | %(message)s')
            formatter = logging.Formatter('%(name)s.%(module)s.%(funcName)s() [%(levelname)5s] %(message)s')
            handler.setFormatter(formatter)
            logger.addHandler(handler)

        # Call the actual function
        result = func(*args, **kwargs)

        # Remove handlers if verbose was set
        if verbose:
            logger.handlers.clear()

        return result

    return wrapper
