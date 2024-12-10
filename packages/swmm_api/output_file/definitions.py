class OBJECTS:
    """
    All different types of objects in .out-file

    Attributes:
        SUBCATCHMENT (str): "subcatchment"
        NODE (str): "node"
        LINK (str): "link"
        POLLUTANT (str): "pollutant"
        SYSTEM (str): "system"
        LIST_ (list[str]): list of all objects
    """
    SUBCATCHMENT = "subcatchment"
    NODE = "node"
    LINK = "link"
    POLLUTANT = "pollutant"
    SYSTEM = "system"

    LIST_ = [SUBCATCHMENT, NODE, LINK, POLLUTANT, SYSTEM]


class SUBCATCHMENT_VARIABLES:
    """
    All variable names for sub-catchments

    Attributes:
        RAINFALL (str): "rainfall" - Rainfall (Precipitation) intensity [mm/hr]
        SNOW_DEPTH (str): "snow_depth" - snow depth [mm]
        EVAPORATION (str): "evaporation" - Evaporation loss [mm/day]
        INFILTRATION (str): "infiltration" - Infiltration loss [mm/h]
        RUNOFF (str): "runoff" - runoff flow rate [flow units in simulation options]
        GW_OUTFLOW (str): "groundwater_outflow" - Groundwater flow into the drainage network (to node)
        GW_ELEVATION (str): "groundwater_elevation" - elevation of saturated gw table [m]
        SOIL_MOISTURE (str): "soil_moisture" - Soil moisture in the unsaturated groundwater zone [fraction]
        LIST_ (list[str]): list of all variables
    """
    RAINFALL = "rainfall"  # rainfall intensity | Rainfall rate [mm/hr] | Precipitation
    SNOW_DEPTH = "snow_depth"  # SNOWDEPTH | snow depth [mm]
    EVAPORATION = "evaporation"  # EVAP | evap loss [mm/day] | Evaporation
    INFILTRATION = "infiltration"  # INFIL | infil loss [mm/h] | Infiltration
    RUNOFF = "runoff"  # RUNOFF | runoff flow rate [flow units in simulation options]
    GW_OUTFLOW = "groundwater_outflow"  # GW_FLOW | groundwater flow rate to node | Groundwater flow into the drainage network
    GW_ELEVATION = "groundwater_elevation"  # GW_ELEV | elevation of saturated gw table [m]
    SOIL_MOISTURE = "soil_moisture"  # SOIL_MOIST | Soil moisture in the unsaturated groundwater zone [fraction]
    # Concentration (mass/volume) Washoff concentration of each pollutant. | TSS

    LIST_ = [RAINFALL, SNOW_DEPTH, EVAPORATION, INFILTRATION, RUNOFF, GW_OUTFLOW, GW_ELEVATION, SOIL_MOISTURE]


class NODE_VARIABLES:
    """
    All variable names for nodes

    Attributes:
        DEPTH (str): 'depth'
        HEAD (str): 'head'
        VOLUME (str): 'volume'
        LATERAL_INFLOW (str): 'lateral_inflow'
        TOTAL_INFLOW (str): 'total_inflow'
        FLOODING (str): 'flooding'
        LIST_ (list[str]): list of all variables
    """
    DEPTH = 'depth'  # DEPTH | water depth above invert | Water depth above the node invert elevation [m]
    HEAD = 'head'  # HEAD | hydraulic head | Absolute elevation per vertical datum [m]
    VOLUME = 'volume'  # VOLUME | volume stored & ponded | Stored water volume including ponded water [m³]
    LATERAL_INFLOW = 'lateral_inflow'  # LATFLOW | lateral inflow rate | Runoff + all other external (DW+GW+I&I+User) inflows
    TOTAL_INFLOW = 'total_inflow'  # INFLOW | total inflow rate | Lateral inflow + upstream inflows
    FLOODING = 'flooding'  # OVERFLOW | overflow rate | Flooding | Surface flooding; excess overflow when the node is at full depth
    # CONCENTRATION [mass/volume] Concentration of each pollutant after any treatment. | TSS

    LIST_ = [DEPTH, HEAD, VOLUME, LATERAL_INFLOW, TOTAL_INFLOW, FLOODING]


class LINK_VARIABLES:
    """
    All variable names for links

    Attributes:
        FLOW (str): 'flow'
        DEPTH (str): 'depth'
        VELOCITY (str): 'velocity'
        VOLUME (str): 'volume'
        CAPACITY (str): 'capacity'
        LIST_ (list[str]): list of all variables
    """
    FLOW = 'flow'  # FLOW | flow rate
    DEPTH = 'depth'  # DEPTH | flow depth | Average water depth [m]
    VELOCITY = 'velocity'  # VELOCITY | flow velocity
    VOLUME = 'volume'  # VOLUME | link volume |Volume of water in the conduit; this is based on the midpoint depth and midpoint cross sectional area [m³]
    CAPACITY = 'capacity'  # CAPACITY | ratio of area to full area |Fraction of full area filled by flow for conduits; control setting for pumps and regulators.
    # Concentration (mass/volume) Concentration of each pollutant. | TSS

    LIST_ = [FLOW, DEPTH, VELOCITY, VOLUME, CAPACITY]


class SYSTEM_VARIABLES:
    """
    All variable names system-wide values

    Attributes:
        AIR_TEMPERATURE (str): 'air_temperature' - [°C]
        RAINFALL (str): 'rainfall' - Total rainfall (Precipitation) intensity [mm/hr]
        SNOW_DEPTH (str): 'snow_depth' - Total snow depth [mm]
        INFILTRATION (str): 'infiltration' - sum in infiltration of all sub-catchments (weighted by the sc-area) [mm/hr]
        RUNOFF (str): 'runoff' - Total runoff flow [flow units in simulation options]
        DW_INFLOW (str): 'dry_weather_inflow' - Total dry weather inflow [flow units in simulation options]
        GW_INFLOW (str): 'groundwater_inflow' - Total groundwater inflow [flow units in simulation options]
        RDII_INFLOW (str): 'RDII_inflow' - Total rainfall derived infiltration and inflow [flow units in simulation options]
        DIRECT_INFLOW (str): 'direct_inflow' - inflow directly defined in section [INFLOWS] and assigned to node [flow units in simulation options]
        LATERAL_INFLOW (str): 'lateral_inflow' - Total Inflow # INFLOW = RUNOFF + DWFLOW + GWFLOW + IIFLOW + EXFLOW [flow units in simulation options]
        FLOODING (str): 'flooding' - Total external flooding [flow units in simulation options]
        OUTFLOW (str): 'outflow' - Total outflow from outfalls [flow units in simulation options]
        VOLUME (str): 'volume' - Total nodal storage volume in the system [m³]
        EVAPORATION (str): 'evaporation' - Actual evaporation [mm/day]
        PET (str): 'PET' - Potential evaporation [mm/day]
        LIST_ (list[str]): list of all variables
    """
    # somewhere are Losses by Exfiltration in STORAGES ??

    AIR_TEMPERATURE = 'air_temperature'  # TEMPERATURE | air temperature [°C]
    RAINFALL = 'rainfall'  # RAINFALL | rainfall intensity | Total rainfall [mm/hr] | Precipitation
    SNOW_DEPTH = 'snow_depth'  # SNOWDEPTH | snow depth | Total snow depth [mm]
    INFILTRATION = 'infiltration'  # INFIL | infil | Average system losses [mm/hr] | Infiltration # sum in infiltration of all sub-catchments (weighted by the sc-area)
    RUNOFF = 'runoff'  # RUNOFF | runoff flow | Total runoff flow [*flow unit*]
    DW_INFLOW = 'dry_weather_inflow'  # DWFLOW | dry weather inflow | Total dry weather inflow | DW Inflow
    GW_INFLOW = 'groundwater_inflow'  # GWFLOW | ground water inflow | Total groundwater inflow | GW Inflow
    RDII_INFLOW = 'RDII_inflow'  # IIFLOW | RDII inflow | Total rainfall derived infiltration and inflow (RDII). | I&I Inflow
    DIRECT_INFLOW = 'direct_inflow'  # EXFLOW | external inflow | Total direct inflow | Direct Inflow # inflow directly defined in section [INFLOWS] and assigned to node
    LATERAL_INFLOW = 'lateral_inflow'  # INFLOW | total lateral inflow | total external inflow | Total Inflow # INFLOW = RUNOFF + DWFLOW + GWFLOW + IIFLOW + EXFLOW
    FLOODING = 'flooding'  # FLOODING | flooding outflow | Total external flooding
    OUTFLOW = 'outflow'  # OUTFLOW | outfall outflow | Total outflow from outfalls
    VOLUME = 'volume'  # STORAGE | storage volume | Total nodal storage volume in the system [m³]
    EVAPORATION = 'evaporation'  # EVAP | evaporation | Actual evaporation [mm/day]
    PET = 'PET'  # PET | potential ET | Potential evaporation [mm/day]

    LIST_ = [AIR_TEMPERATURE, RAINFALL, SNOW_DEPTH, INFILTRATION, RUNOFF, DW_INFLOW,
             GW_INFLOW, RDII_INFLOW, DIRECT_INFLOW, LATERAL_INFLOW, FLOODING,
             OUTFLOW, VOLUME, EVAPORATION, PET]


# from swmmtoolbox | swmm source | swmm gui | swmm manual
# https://support.chiwater.com/77882/swmm5-output-file
class VARIABLES:
    """
    All different variables of the objects in the .out-file

    Attributes:
        SUBCATCHMENT (swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES): All variable-names for subcatchments
        NODE (swmm_api.output_file.definitions.NODE_VARIABLES): All variable-names for nodes
        LINK (swmm_api.output_file.definitions.LINK_VARIABLES): All variable-names for links
        SYSTEM (swmm_api.output_file.definitions.SYSTEM_VARIABLES): All variable-names for system values
    """
    SUBCATCHMENT = SUBCATCHMENT_VARIABLES
    NODE = NODE_VARIABLES
    LINK = LINK_VARIABLES
    SYSTEM = SYSTEM_VARIABLES


di_flow_unit_label = {
    'CMS': 'm3/s',
    'LPS': 'L/s',
    'MLD': '10^6*L/d',
}
