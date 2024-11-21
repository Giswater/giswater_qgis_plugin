import warnings
from collections import ChainMap

from .collection import links_dict, nodes_dict
from ._helpers import get_used_curves, verbose_logging, logger, SwmmApiInputMacrosWarning
from ..section_labels import *
from ..misc.curve_simplification import ramer_douglas
from ..sections import Control, EvaporationSection, ReportSection, ControlVariable, ControlExpression
from ... import SwmmInput


def reduce_curves(inp):
    """
    Remove unused curves.

    Only keep used CURVES from the sections [STORAGE, OUTFALLS, OUTLETS, PUMPS and XSECTIONS].

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    .. Important::
        works inplace
    """
    if CURVES not in inp:
        return inp
    used_curves = get_used_curves(inp)
    inp[CURVES] = inp[CURVES].slice_section(used_curves)


def reduce_pattern(inp):
    used_pattern = set()
    if EVAPORATION in inp:
        #  optional monthly time pattern of multipliers for infiltration recovery rates during dry periods
        if 'RECOVERY' in inp[EVAPORATION]:
            used_pattern.add(inp[EVAPORATION]['RECOVERY'])

    if AQUIFERS in inp:
        #  optional monthly time pattern used to adjust the upper zone evaporation fraction
        used_pattern |= set(inp[AQUIFERS].frame['Epat'].dropna().values)

    if INFLOWS in inp:
        #  optional time pattern used to adjust the baseline value on a periodic basis
        used_pattern |= set(inp[INFLOWS].frame['pattern'].dropna().values)

    if DWF in inp:
        for i in range(1, 5):
            used_pattern |= set(inp[DWF].frame[f'pattern{i}'].dropna().values)

    if PATTERNS in inp:
        inp[PATTERNS] = inp[PATTERNS].slice_section(used_pattern)


@verbose_logging
def reduce_controls(inp, verbose=False):
    """
    Remove unused controls.

    Only keep used CONTROLS the sections [CONDUIT, ORIFICE, WEIR, OUTLET / NODE, LINK, CONDUIT, PUMP, ORIFICE, WEIR, OUTLET]

    If an unavailable object is in the condition: remove whole rule.
    If an unavailable object is in an action: remove only this action.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    .. Important::
        works inplace
    """
    if CONTROLS not in inp:
        return

    links = links_dict(inp)
    nodes = nodes_dict(inp)

    def element_exists(obj: (ControlVariable | Control._Condition), inp: SwmmInput):
        if (obj.object_kind.upper() + 'S') in inp:  # CONDUIT PUMP ORIFICE WEIR OUTLET
            return obj.label in inp[obj.object_kind + 'S']
        elif obj.object_kind.upper() == Control.OBJECTS.NODE:
            return obj.label in nodes
        elif obj.object_kind.upper() == Control.OBJECTS.LINK:
            return obj.label in links
        elif obj.object_kind.upper() == Control.OBJECTS.GAGE:
            return (RAINGAGES in inp) and (obj.label in inp.RAINGAGES)
        elif obj.object_kind.upper() == Control.OBJECTS.SIMULATION:
            return True
        elif ((obj.object_kind.upper() + 'S') in inp._converter) and ((obj.object_kind.upper() + 'S') not in inp):
            return False
        else:
            msg = f'NotImplemented: Could not check if VARIABLE or object ("{obj.object_kind.upper()}") exists for function `reduce_controls`.'
            if verbose:
                logger.warning(msg)
            else:
                warnings.warn(msg, SwmmApiInputMacrosWarning)
            return True

    # filter and remove variables based on availability of objects - same as conditions
    di_variables = {label_variable: variable for label_variable, variable in inp.CONTROLS.items() if isinstance(variable, ControlVariable) and element_exists(variable, inp)}

    # filter and remove expressions based on availability of variables
    di_expressions = {label_expression: expression for label_expression, expression in inp.CONTROLS.items() if isinstance(expression, ControlExpression) and all([label_variable in di_variables for label_variable in expression.get_variables_involved()])}

    di_variables_or_expression = ChainMap(di_variables, di_expressions)

    for label in list(inp.CONTROLS.keys()):
        control = inp.CONTROLS[label]

        if isinstance(control, (ControlVariable, ControlExpression)):
            if control.name not in di_variables_or_expression:
                logger.debug(f'delete {control}: not in {list(di_variables_or_expression)=}')
                del inp.CONTROLS[label]

            # if verbose:
            #     logging.warning('The reduction of Variables and Expressions in the CONTROL section is not yet implemented.')
            # else:
            #     print_warning('The reduction of Variables and Expressions in the CONTROL section is not yet implemented.')
            continue

        # if unavailable object in condition: remove whole rule
        for condition in control.conditions:  # type: Control._Condition

            if condition.involves_variable_or_expression():
                # if verbose:
                #     logging.warning('The reduction of Variables and Expressions as a condition in a CONTROL rule is not yet implemented.')
                # else:
                #     print_warning('The reduction of Variables and Expressions as a condition in a CONTROL rule is not yet implemented.')
                if condition.label not in di_variables_or_expression:
                    # expression or variable not available or deleted -> delete rule
                    logger.debug(f'{condition} not in {list(di_variables_or_expression)=} -> delete CONTROL-rule "{label}"')
                    del inp.CONTROLS[label]
                    break
            elif not element_exists(condition, inp):
                logger.debug(f'{condition.object_kind} {condition.label} does not exist in inp-data -> delete CONTROL-rule "{label}"')
                del inp.CONTROLS[label]
                break

        if label not in inp.CONTROLS:
            # if the control rule is already deleted because some objects used in the conditions are missing
            continue

        def _delete_action(_label, _action):
            if _action in inp.CONTROLS[_label].actions_if:
                # i = control.actions_if.index(_action)
                # inp.CONTROLS[_label].actions_if.remove(i)
                inp.CONTROLS[_label].actions_if.remove(_action)
            if _action in inp.CONTROLS[_label].actions_else:
                # i = control.actions_else.index(_action)
                # inp.CONTROLS[_label].actions_else.remove(i)
                inp.CONTROLS[_label].actions_else.remove(_action)

        # if unavailable object in action: remove only this action
        for action in list(control.actions_if) + list(control.actions_else):  # type: Control._Action
            section_label = action.kind.upper() + 'S'
            if section_label in inp:
                # CONDUIT PUMP ORIFICE WEIR OUTLET
                if action.label not in inp[section_label]:
                    # delete only this action
                    _delete_action(label, action)
            elif section_label in inp._converter and section_label not in inp:
                # if section not in inp-file -> not objects in model -> delete action
                _delete_action(label, action)

            elif action.kind == Control.OBJECTS.NODE:  # not possible?!
                if action.label not in nodes:
                    # delete only this action
                    _delete_action(label, action)
            elif action.kind == Control.OBJECTS.LINK:  # not possible?!
                if action.label not in links:
                    # delete only this action
                    _delete_action(label, action)

        # if no actions left
        if not control.actions_if:
            del inp.CONTROLS[label]


def simplify_curves(curve_section, dist=0.001):
    """
    Simplify curves with the algorithm by Ramer and Douglas.

    Args:
        curve_section (InpSection[Curve]): old section
        dist (float): maximum Ramer-Douglas distance

    Returns:
        InpSection[Curve]: new section
    """
    # new = Curve.create_section()
    # for label, curve in curve_section.items():
    #     new[label] = Curve(curve.Name, curve.Type, points=ramer_douglas(curve_section[label].points, dist=dist))
    # return new
    for curve in curve_section.values():  # type: Curve
        curve.points = ramer_douglas(curve.points, dist=dist)
    return curve_section


def reduce_raingages(inp):
    """
    Set used ``RAINGAGES`` from ``SUBCATCHMENTS`` and keep only used rain-gages in the section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    .. Important::
        works inplace
    """
    needed_raingages = set()
    if (SUBCATCHMENTS in inp) and (RAINGAGES in inp):
        needed_raingages = {inp[SUBCATCHMENTS][s].rain_gage for s in inp[SUBCATCHMENTS]}

    inp[RAINGAGES] = inp[RAINGAGES].slice_section(needed_raingages)


def reduce_hydrographs(inp):
    """
    Set used ``HYDROGRAPHS`` from ``RDII`` and keep only used hydrographs in the section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    .. Important::
        works inplace
    """
    needed_hydrographs = set()
    if (HYDROGRAPHS in inp) and (RDII in inp):
        needed_hydrographs = {inp.RDII[s].hydrograph for s in inp.RDII}

    inp[HYDROGRAPHS] = inp[HYDROGRAPHS].slice_section(needed_hydrographs)


def reduce_snowpacks(inp):
    """
    Set used ``SNOWPACKS`` from ``SUBCATCHMENTS`` and keep only used snow-packs in the section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    .. Important::
        works inplace
    """
    needed_snowpacks = set()
    if (SUBCATCHMENTS in inp) and (SNOWPACKS in inp):
        needed_snowpacks = {inp.SUBCATCHMENTS[s].snow_pack for s in inp[SUBCATCHMENTS]}

    inp[SNOWPACKS] = inp[SNOWPACKS].slice_section(needed_snowpacks)


def remove_empty_sections(inp):
    """
    Remove empty inp-file data sections.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        SwmmInput: cleaned inp-file data
    """
    for section in list(inp.keys()):
        if not inp._data[section]:
            del inp[section]


def reduce_timeseries(inp):
    if TIMESERIES not in inp:
        return

    needed_timeseries = set()
    key = EvaporationSection.KEYS.TIMESERIES  # TemperatureSection.KEYS.TIMESERIES, ...

    if RAINGAGES in inp:
        f = inp[RAINGAGES].frame
        # type: swmm_api.input_file.sections.RainGage
        if not f.empty:
            needed_timeseries |= set(f.loc[f['source'].str.upper() == key, 'timeseries'])

    if EVAPORATION in inp:
        if key in inp[EVAPORATION]:
            needed_timeseries.add(inp[EVAPORATION][key])

    if TEMPERATURE in inp:
        if key in inp[TEMPERATURE]:
            needed_timeseries.add(inp[TEMPERATURE][key])

    if OUTFALLS in inp:
        f = inp[OUTFALLS].frame
        needed_timeseries |= set(f.loc[f['kind'].str.upper() == key, 'data'])

    if INFLOWS in inp:
        f = inp[INFLOWS].frame
        needed_timeseries |= set(f['time_series'])

    inp[TIMESERIES] = inp[TIMESERIES].slice_section(needed_timeseries)


def reduce_report_objects(inp):
    """
    Remove lost objects in report section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
    """
    T = ReportSection.KEYS

    if T.SUBCATCHMENTS in inp.REPORT:
        # none all or list
        value = inp.REPORT[T.SUBCATCHMENTS]
        if value is None:
            pass  # Do nothing -> looks like a placeholder / could be deleted
        elif isinstance(value, str) and value.upper() == 'ALL':
            pass  # Do nothing -> looks like a placeholder / could be deleted if no subcatchments are in the input data
        else:  # list of SC
            if SUBCATCHMENTS in inp:
                # keep only SC in SUBCATCHMENTS section
                inp.REPORT[T.SUBCATCHMENTS] = list(set(inp.SUBCATCHMENTS) & set(value))
            else:
                del inp.REPORT[T.SUBCATCHMENTS]

    # ---
    if T.LINKS in inp.REPORT:
        # none all or list
        value = inp.REPORT[T.LINKS]
        if value is None:
            pass  # Do nothing -> looks like a placeholder / could be deleted
        elif isinstance(value, str) and value.upper() == 'ALL':
            pass  # Do nothing -> looks like a placeholder / could be deleted if no subcatchments are in the input data
        else:  # list of links
            avail_objects = set(links_dict(inp))  # set of strings
            if avail_objects:
                # keep only links which are in link-sections
                inp.REPORT[T.LINKS] = list(avail_objects & set(value))
            else:
                del inp.REPORT[T.LINKS]

    # ---
    if T.NODES in inp.REPORT:
        # none all or list
        value = inp.REPORT[T.NODES]
        if value is None:
            pass  # Do nothing -> looks like a placeholder / could be deleted
        elif isinstance(value, str) and value.upper() == 'ALL':
            pass  # Do nothing -> looks like a placeholder / could be deleted if no subcatchments are in the input data
        else:  # list of links
            avail_objects = set(nodes_dict(inp))  # set of strings
            if avail_objects:
                # keep only links which are in link-sections
                inp.REPORT[T.NODES] = list(avail_objects & set(value))
            else:
                del inp.REPORT[T.NODES]
