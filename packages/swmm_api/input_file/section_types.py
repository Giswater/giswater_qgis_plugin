from .section_labels import *
from .sections import *

"""objects or section class for a section in the inp-file"""
SECTION_TYPES = {
    TITLE        : TitleSection,
    OPTIONS      : OptionSection,
    EVAPORATION  : EvaporationSection,
    TEMPERATURE  : TemperatureSection,
    REPORT       : ReportSection,
    FILES        : FilesSection,
    BACKDROP     : BackdropSection,
    ADJUSTMENTS  : AdjustmentsSection,
    # -----
    # GUI data
    COORDINATES  : Coordinate,
    VERTICES     : Vertices,
    POLYGONS     : Polygon,
    SYMBOLS      : Symbol,
    MAP          : MapSection,
    LABELS       : Label,
    # -----
    # custom section objects
    CONDUITS     : Conduit,
    ORIFICES     : Orifice,
    WEIRS        : Weir,
    PUMPS        : Pump,
    OUTLETS      : Outlet,

    TRANSECTS    : Transect,
    XSECTIONS    : CrossSection,
    LOSSES       : Loss,
    # -----
    JUNCTIONS    : Junction,
    OUTFALLS     : Outfall,
    STORAGE      : Storage,

    DWF          : DryWeatherFlow,
    INFLOWS      : Inflow,
    RDII         : RainfallDependentInfiltrationInflow,
    TREATMENT    : Treatment,
    # -----
    SUBCATCHMENTS: SubCatchment,
    SUBAREAS     : SubArea,
    INFILTRATION : Infiltration,  # multiple possible

    LOADINGS     : Loading,
    WASHOFF      : WashOff,
    BUILDUP      : BuildUp,
    COVERAGES    : Coverage,
    GWF          : GroundwaterFlow,
    GROUNDWATER  : Groundwater,
    SNOWPACKS    : SnowPack,
    # -----
    RAINGAGES    : RainGage,
    PATTERNS     : Pattern,
    POLLUTANTS   : Pollutant,
    CONTROLS     : Control,  # multiple possible
    CURVES       : Curve,
    TIMESERIES   : Timeseries,  # multiple possible
    TAGS         : Tag,
    HYDROGRAPHS  : Hydrograph,
    LANDUSES     : LandUse,
    AQUIFERS     : Aquifer,
    # -----
    LID_CONTROLS : LIDControl,
    LID_USAGE    : LIDUsage,
    # -----
    STREETS      : Street,
    INLETS       : Inlet,  # multiple possible
    INLET_USAGE  : InletUsage,
}
"""objects or section class for a section in the inp-file"""

SECTIONS_MULTI_TYPES = {
    INFILTRATION: (Infiltration, InfiltrationGreenAmpt, InfiltrationHorton, InfiltrationCurveNumber),
    CONTROLS: (Control, ControlVariable, ControlExpression),
    TIMESERIES: (Timeseries, TimeseriesFile, TimeseriesData),
    INLETS: (Inlet, InletGrate, InletCurb, InletSlotted, InletCustom),
}
