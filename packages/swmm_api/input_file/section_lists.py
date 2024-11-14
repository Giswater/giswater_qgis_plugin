from .section_labels import *

GEO_SECTIONS = [COORDINATES, VERTICES, POLYGONS]
GUI_SECTIONS = [MAP, SYMBOLS, LABELS, BACKDROP, PROFILES]

LINK_SECTIONS = [CONDUITS, ORIFICES, OUTLETS, PUMPS, WEIRS]  # only link objects
LINK_SECTIONS_ADD = [XSECTIONS, LOSSES, VERTICES]  # where the link-label is the only identifier.
# only conduits: as part-identifier: INLET_USAGE

NODE_SECTIONS = [JUNCTIONS, OUTFALLS, DIVIDERS, STORAGE]  # only node objects
NODE_SECTIONS_ADD = [COORDINATES, RDII]  # where the node-label is the only identifier.
# as part-identifier: INFLOWS(constituent), DWF(constituent), GROUNDWATER(AQUIFERS, SUBCATCHMENT), INLET_USAGE(CONDUIT, INLETS)
# as parameter: SUBCATCHMENTS

SUBCATCHMENT_SECTIONS = [SUBCATCHMENTS, SUBAREAS, INFILTRATION, POLYGONS, LOADINGS, COVERAGES]  # where the subcatchment-label is the only identifier.
# as parameter:
# as part-identifier: LID_USAGE(LID_CONTROLS), GWF(kind), GROUNDWATER(AQUIFERS, NODE)

POLLUTANT_SECTIONS = [TREATMENT, WASHOFF, BUILDUP, POLLUTANTS]  # where pollutants are defined and used
# as parameter: LID_CONTROLS