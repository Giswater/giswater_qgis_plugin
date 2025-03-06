"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

# Basic: 01, 02, 03
from .basic.info_btn import GwInfoButton
from .basic.selector_btn import GwSelectorButton
from .basic.search_btn import GwSearchButton

# Om: 11, 12, 13, 14, 15, 16, 17, 18
from .om.mincut_btn import GwMincutButton
from .om.mincut_manager_btn import GwMincutManagerButton
from .om.flow_trace_btn import GwFlowTraceButton
from .om.flow_exit_btn import GwFlowExitButton
from .om.profile_btn import GwProfileButton
from .om.visit_btn import GwVisitButton
from .om.visit_manager_btn import GwVisitManagerButton
from .om.date_selector_btn import GwDateSelectorButton

# Edit: 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36
from .edit.point_add_btn import GwPointAddButton
from .edit.arc_add_btn import GwArcAddButton
from .edit.arc_divide_btn import GwArcDivideButton
from .edit.arc_fusion_btn import GwArcFusionButton
from .edit.featuretype_change_btn import GwFeatureTypeChangeButton
from .edit.feature_replace_btn import GwFeatureReplaceButton
from .edit.connect_link_btn import GwConnectLinkButton
from .edit.feature_end_btn import GwFeatureEndButton
from .edit.feature_delete_btn import GwFeatureDeleteButton
from .edit.dimensioning_btn import GwDimensioningButton
from .edit.document_btn import GwDocumentButton
from .edit.document_manager_btn import GwDocumentManagerButton
from .edit.element_btn import GwElementButton
from .edit.element_manager_btn import GwElementManagerButton
from .edit.aux_circle_add_btn import GwAuxCircleAddButton
from .edit.aux_point_add_btn import GwAuxPointAddButton

# Epa: 41, 42, 43, 44, 45, 46
from .epa.nonvisual_manager_btn import GwNonVisualManagerButton
from .epa.go2epa_btn import GwGo2EpaButton
from .epa.go2epa_manager_btn import GwGo2EpaManagerButton
from .epa.go2epa_selector_btn import GwGo2EpaSelectorButton
from .epa.dscenario_manager_btn import GwDscenarioManagerButton
from .epa.epa_tools_btn import GwEpaTools

# Plan: 51, 52, 53
from .plan.psector_btn import GwPsectorButton
from .plan.psector_manager_btn import GwPsectorManagerButton
from .plan.netscenario_manager_btn import GwNetscenarioManagerButton

# Utilities: 61, 62, 63, 64, 65, 66, 67
from .utilities.utils_manager_btn import GwUtilsManagerButton
from .utilities.config_btn import GwConfigButton
from .utilities.toolbox_btn import GwToolBoxButton
from .utilities.utilities_manager.workspace_manager import GwWorkspaceManagerButton
from .utilities.print_btn import GwPrintButton
from .utilities.csv_btn import GwCSVButton
from .utilities.project_check_btn import GwProjectCheckButton

# ToC: 71, 72
from .toc.add_child_layer_btn import GwAddChildLayerButton
from .toc.layerstyle_change_btn import GwLayerStyleChangeButton

# am: 80, 81, 82, 83
from .am.breakage_btn import GwAmBreakageButton
from .am.priority_btn import GwAmPriorityButton
from .am.result_manager_btn import GwResultManagerButton
from .am.result_selector_btn import GwResultSelectorButton

# cm: 84, 85, 86
from .cm.add_lot2 import GwAddLotButton
from .cm.manager_lot import GwManageLotButton
from .cm.resources_lot import GwLotResourceManagementButton
