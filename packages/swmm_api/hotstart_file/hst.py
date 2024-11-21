from io import SEEK_SET

import pandas as pd

from .._io_helpers._read_bin import BinaryReader
from ..input_file import SEC
from ..output_file.extract import _FLOW_UNITS

_FILESTAMP = "SWMM5-HOTSTART4"


class SwmmHotstart(BinaryReader):
    """
    SWMM-hotstart-file class.

    Attributes:
        columns_link (list[str]): columns_link
        columns_node (list[str]): columns_node
        columns_storage (list[str]): columns_storage
        columns_subcatchment (list[str]): columns_subcatchment
        links (list[tuple]): links
        nodes (list[tuple]): nodes
        storages (list[tuple]): storages
        subcatchments (list[tuple]): subcatchments
        unit (str): unit
        filename (str): Path to the hotstart-file (.hst).
    """
    def __init__(self, filename,  inp):
        """
        Read the SWMM-created binary hotstart file (___.hst).

        Args:
            filename (str): Path to the hotstart-file.
            inp (swmm_api.SwmmInput): SWMM input-file data.
        """
        super().__init__(filename)
        self.fp.seek(0, SEEK_SET)

        # openHotstartFile2
        _file_stamp = self._next(len(_FILESTAMP), 's')
        n_subcatchments = self._next()
        n_landuse = self._next()
        n_nodes = self._next()
        n_links = self._next()
        n_pollutants = self._next()
        i_flow_unit = self._next()
        self.unit = _FLOW_UNITS[i_flow_unit]

        # ---------
        # get inp-file-data information
        pollutants = list(inp.POLLUTANTS.keys()) if inp.POLLUTANTS else []
        landuses = list(inp.LANDUSES.keys()) if inp.LANDUSES else []
        labels_subcatchments = list(inp.SUBCATCHMENTS.keys()) if inp.SUBCATCHMENTS else []

        kind_nodes = []
        node_labels = []

        for sec in inp._original_section_order:
            if sec in [SEC.JUNCTIONS, SEC.OUTFALLS, SEC.STORAGE, SEC.DIVIDERS] and sec in inp:
                kind_nodes += [sec] * len(inp[sec].keys())
                node_labels += list(inp[sec].keys())

        kind_links = []
        links_labels = []
        for sec in inp._original_section_order:
            if sec in [SEC.CONDUITS, SEC.ORIFICES, SEC.PUMPS, SEC.WEIRS, SEC. OUTLETS] and sec in inp:
                kind_links += [sec] * len(inp[sec].keys())
                links_labels += list(inp[sec].keys())

        # ---------------------------------------------------------------------------
        # Runoff

        subareas = ['imperv_zero', 'imperv', 'perv']
        self.columns_subcatchment = ['label', *[f'depth_{s}' for s in subareas], 'runoff']
        # Infiltration
        self.columns_subcatchment += [f'Infiltration_{i}' for i in range(6)]

        if SEC.GROUNDWATER in inp:
            self.columns_subcatchment += ['theta', 'bottomElev+lowerDepth', 'newFlow', 'maxInfilVol']

        if SEC.SNOWPACKS in inp:
            for s in subareas:
                for v in ['depth_snow', 'depth_free_water_snow', 'cold_content', 'antecedent_temperature', 'initial_AWESI']:
                    self.columns_subcatchment.append(f'{s}_{v}')

        if n_pollutants:
            for v in ['runoff', 'ponded']:
                for i_pollutant in range(n_pollutants):
                    self.columns_subcatchment.append(f'{v}_{pollutants[i_pollutant]}')

            for i_landuse in range(n_landuse):
                self.columns_subcatchment += [f'{landuses[i_landuse]}_{pollutants[i_pollutant]}_buildup' for i_pollutant in range(n_pollutants)]
                self.columns_subcatchment += [f'{landuses[i_landuse]}_lastSwept']

        self.subcatchments = []
        for i_sc in range(n_subcatchments):
            subcatchment = [labels_subcatchments[i_sc]]
            # Ponded depths for each sub-area & total runoff (4 elements)
            #   impervious w/o depression storage
            #   impervious w/ depression storage
            #   pervious
            subcatchment += self._next_doubles(4)

            # Infiltration state (max. of 6 elements)
            # immer 6 elemente, aber nur die ersten belegt

            #   HORTON:
            #       tp present time on infiltration curve (sec)
            #       Fe cumulative infiltration (ft)
            #   GREEN_AMPT:
            #       IMD current initial soil moisture deficit
            #       F   current cumulative infiltrated volume (ft)
            #       Fu  current upper zone infiltrated volume (ft)
            #       Sat saturation flag
            #       T   time until start of next rain event (sec)
            #   CURVE_NUMBER:
            #       S   current infiltration capacity (ft)
            #       P   current cumulative precipitation (ft)
            #       F   current cumulative infiltration (ft)
            #       T   current inter-event time (sec)
            #       Se  current event infiltration capacity (ft)
            #       f   previous infiltration rate (ft/sec)

            subcatchment += self._next_doubles(6)

            # Groundwater state (4 elements)
            if SEC.GROUNDWATER in inp:
                if labels_subcatchments[i_sc] in inp[SEC.GROUNDWATER]:
                    # theta
                    # bottomElev + lowerDepth
                    # newFlow
                    # maxInfilVol
                    subcatchment += self._next_doubles(4)
                else:
                    subcatchment += [None] * 4

            # Snowpack state (5 elements for each of 3 snow surfaces)
            if SEC.SNOWPACKS in inp:
                if labels_subcatchments[i_sc] in inp[SEC.SNOWPACKS]:
                    for i_snow_surface in range(3):
                        # depth_snow depth of snow pack (ft)
                        # depth_free_water_snow    depth of free water in snow pack (ft)
                        # cold_content cold content of snow pack
                        # antecedent_temperature   antecedent temperature index (deg F)
                        # initial_AWESI   initial AWESI of linear ADC
                        subcatchment += self._next_doubles(5)
                else:
                    subcatchment += [None] * 3*5

            if n_pollutants:
                # Water quality
                #   Runoff quality
                #   Ponded quality
                #   Buildup and when streets were last swept
                subcatchment += self._next_doubles(2*n_pollutants)

                for i_landuse in range(n_landuse):
                    subcatchment += self._next_doubles(n_pollutants + 1)

            self.subcatchments.append(subcatchment)

        # ---------------------------------------------------------------------------
        # Routing
        self.columns_node = ['label', 'kind', 'depth', 'lateral_flow'] + pollutants
        self.columns_storage = ['label', 'kind', 'depth', 'lateral_flow', 'hydraulic_residence_time'] + pollutants

        self.nodes = []
        self.storages = []

        for i_node in range(n_nodes):
            if kind_nodes[i_node] == SEC.STORAGE:
                # if is storage
                # read 3 Parameters
                #   depth
                #   lateral_flow
                #   hydraulic_residence_time
                # + Pollutants
                self.storages.append((node_labels[i_node], kind_nodes[i_node], *self._next_floats(n_pollutants + 3)))
            else:
                # read 2 Parameters
                #   depth
                #   lateral_flow
                #  + Pollutants
                self.nodes.append((node_labels[i_node], kind_nodes[i_node], *self._next_floats(n_pollutants + 2)))

        self.columns_link = ['label', 'kind', 'flow', 'depth', 'setting'] + pollutants

        self.links = []
        for i_link in range(n_links):
            # read 3 Parameters
            #   flow
            #   depth
            #   setting
            #  + Pollutants
            self.links.append((links_labels[i_link], kind_links[i_link], *self._next_floats(n_pollutants + 3)))

    @property
    def links_frame(self):
        """
        Get a table with the initial values of all links.
        The columns are ['label', 'kind', 'flow', 'depth', 'setting'] + pollutants.

        Returns:
            pandas.DataFrame: table with the initial values of all links.
        """
        df = pd.DataFrame.from_records(self.links)
        df.columns = self.columns_link
        return df

    @property
    def nodes_frame(self):
        """
        Get a table with the initial values of all nodes.
        The columns are ['label', 'kind', 'depth', 'lateral_flow'] + pollutants.

        Returns:
            pandas.DataFrame: table with the initial values of all nodes.
        """
        df = pd.DataFrame.from_records(self.nodes)
        df.columns = self.columns_node
        return df

    @property
    def storages_frame(self):
        """
        Get a table with the initial values of all storages.
        The columns are ['label', 'kind', 'depth', 'lateral_flow', 'hydraulic_residence_time'] + pollutants

        Returns:
            pandas.DataFrame: table with the initial values of all storages
        """
        df = pd.DataFrame.from_records(self.storages)
        df.columns = self.columns_storage
        return df

    @property
    def subcatchments_frame(self):
        """
        Get a table with the initial values of all subcatchments.
        The columns depend on model.

        Returns:
            pandas.DataFrame: table with the initial values of all subcatchments.
        """
        df = pd.DataFrame.from_records(self.subcatchments)
        df.columns = self.columns_subcatchment
        return df


read_hst_file = SwmmHotstart
