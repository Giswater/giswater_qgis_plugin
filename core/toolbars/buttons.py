"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

# Basic
from .basic.info_btn import GwInfoButton
from .basic.search_btn import GwSearchButton
from .basic.selector_btn import GwSelectorButton

# Om
from .om.mincut_btn import GwMincutButton
from .om.mincut_manager_btn import GwMincutManagerButton

from .om.flow_trace_btn import GwFlowTraceButton
from .om.flow_exit_btn import GwFlowExitButton

from .om.profile_btn import GwProfileButton
from .om.visit_btn import GwVisitButton
from .om.visit_manager_btn import GwVisitManagerButton
from .om.date_selector_btn import GwDateSelectorButton

# Edit
from .edit.point_add_btn import GwPointAddButton
from .edit.arc_add_btn import GwArcAddButton
from .edit.feature_replace_btn import GwFeatureReplaceButton
from .edit.arc_divide_btn import GwArcDivideButton
from .edit.arc_fusion_btn import GwArcFusionButton
from .edit.nodetype_change_btn import GwNodeTypeChangeButton
from .edit.connect_link_btn import GwConnectLinkButton
from .edit.feature_end_btn import GwFeatureEndButton
from .edit.feature_delete_btn import GwFeatureDeleteButton
from .edit.dimensioning_btn import GwDimensioningButton
from .edit.document_btn import GwDocumentButton
from .edit.document_manager_btn import GwDocumentManagerButton
from .edit.element_btn import GwElementButton
from .edit.element_manager_btn import GwElementManagerButton

# Cad
from .cad.aux_circle_add import GwAuxCircleAddButton
from .cad.aux_point_add import GwAuxPointAddButton

# Epa
from .epa.go2epa_btn import GwGo2EpaButton
from .epa.go2epa_manager_btn import GwGo2EpaManagerButton
from .epa.go2epa_selector_btn import GwGo2EpaSelectorButton

# Plan
from .plan.psector_btn import GwPsectorButton
from .plan.psector_manager_btn import GwPsectorManagerButton
from .plan.price_manager_btn import GwPriceManagerButton

# Utilities
from .utilities.toolbox_btn import GwToolBoxButton
from .utilities.config_btn import GwConfigButton
from .utilities.csv_btn import GwCSVButton
from .utilities.print_btn import GwPrintButton
from .utilities.project_check_btn import GwProjectCheckButton

# ToC
from .toc.add_child_layer_btn import GwAddChildLayerButton
