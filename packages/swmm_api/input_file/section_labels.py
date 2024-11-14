"""Predefined input file section header to prevent typos"""

TITLE = 'TITLE'  # project title
OPTIONS = 'OPTIONS'  # analysis options
REPORT = 'REPORT'  # output reporting instructions
FILES = 'FILES'  # interface file options
RAINGAGES = 'RAINGAGES'  # rain gage information
EVAPORATION = 'EVAPORATION'  # evaporation data
TEMPERATURE = 'TEMPERATURE'  # air temperature and snow melt data
ADJUSTMENTS = 'ADJUSTMENTS'  # monthly adjustments applied to climate variables

SUBCATCHMENTS = 'SUBCATCHMENTS'  # basic subcatchment information
SUBAREAS = 'SUBAREAS'  # subcatchment impervious/pervious sub-area data
INFILTRATION = 'INFILTRATION'  # subcatchment infiltration parameters
LID_CONTROLS = 'LID_CONTROLS'  # low impact development control information
LID_USAGE = 'LID_USAGE'  # assignment of LID controls to subcatchments
AQUIFERS = 'AQUIFERS'  # groundwater aquifer parameters
GROUNDWATER = 'GROUNDWATER'  # subcatchment groundwater parameters
GWF = 'GWF'  # groundwater flow expressions
SNOWPACKS = 'SNOWPACKS'  # subcatchment snow pack parameters

JUNCTIONS = 'JUNCTIONS'  # junction node information
OUTFALLS = 'OUTFALLS'  # outfall node information
DIVIDERS = 'DIVIDERS'  # flow divider node information
STORAGE = 'STORAGE'  # storage node information

CONDUITS = 'CONDUITS'  # conduit link information
PUMPS = 'PUMPS'  # pump link information
ORIFICES = 'ORIFICES'  # orifice link information
WEIRS = 'WEIRS'  # weir link information
OUTLETS = 'OUTLETS'  # outlet link information

XSECTIONS = 'XSECTIONS'  # conduit, orifice, and weir cross-section geometry
TRANSECTS = 'TRANSECTS'  # transect geometry for conduits with irregular cross-sections
LOSSES = 'LOSSES'  # conduit entrance/exit losses and flap valves

CONTROLS = 'CONTROLS'  # rules that control pump and regulator operation

POLLUTANTS = 'POLLUTANTS'  # pollutant information
LANDUSES = 'LANDUSES'  # land use categories
COVERAGES = 'COVERAGES'  # assignment of land uses to subcatchments
LOADINGS = 'LOADINGS'  # initial pollutant loads on subcatchments
BUILDUP = 'BUILDUP'  # buildup functions for pollutants and land uses
WASHOFF = 'WASHOFF'  # washoff functions for pollutants and land uses

TREATMENT = 'TREATMENT'  # pollutant removal functions at conveyance system nodes
INFLOWS = 'INFLOWS'  # external hydrograph/pollutograph inflow at nodes
DWF = 'DWF'  # baseline dry weather sanitary inflow at nodes
RDII = 'RDII'  # rainfall-dependent I/I information at nodes

HYDROGRAPHS = 'HYDROGRAPHS'  # unit hydrograph data used to construct RDII inflows
CURVES = 'CURVES'  # x-y tabular data referenced in other sections
TIMESERIES = 'TIMESERIES'  # time series data referenced in other sections
PATTERNS = 'PATTERNS'  # periodic multipliers referenced in other sections
STREETS = 'STREETS'  # cross-section geometry for street conduits | new in SWMM 5.2
INLETS = 'INLETS'  # design data for storm drain inlets | new in SWMM 5.2
INLET_USAGE = 'INLET_USAGE'  # assignment of inlets to street and channel conduits | new in SWMM 5.2
# ___________________________
# NOT IN SWMM DOCU

TAGS = 'TAGS'

COORDINATES = 'COORDINATES'  # node  # X,Y coordinates for nodes
VERTICES = 'VERTICES'  # link  # X,Y coordinates for each interior vertex of polyline links
POLYGONS = 'POLYGONS'  # catchment  # X,Y coordinates for each vertex of subcatchment polygons

MAP = 'MAP'  # view  # X,Y coordinates of the map’s bounding rectangle
LABELS = 'LABELS'  # free text  # X,Y coordinates and text of labels
SYMBOLS = 'SYMBOLS'  # rain gauge  # X,Y coordinates for rain gages
BACKDROP = 'BACKDROP'  # background pic # X,Y coordinates of the bounding rectangle and file name of the backdrop image.

PROFILES = 'PROFILES'  # Profile plot nodes
