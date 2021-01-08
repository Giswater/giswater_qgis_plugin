# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

__author__ = 'Luigi Pirelli'
__date__ = 'January 2018'
__copyright__ = '(C) 2018, Luigi Pirelli'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

from .models_manager import GwTable, GwGenericDescriptor


class GwOmVisitEvent(GwTable):
    """ Class to serialize table 'om_visit_event' """

    id = GwGenericDescriptor(-1)
    event_code = GwGenericDescriptor(None)
    visit_id = GwGenericDescriptor(None)
    position_id = GwGenericDescriptor(None)
    position_value = GwGenericDescriptor(None)
    parameter_id = GwGenericDescriptor(None)
    value = GwGenericDescriptor(None)
    value1 = GwGenericDescriptor(None)
    value2 = GwGenericDescriptor(None)
    geom1 = GwGenericDescriptor(None)
    geom2 = GwGenericDescriptor(None)
    geom3 = GwGenericDescriptor(None)
    xcoord = GwGenericDescriptor(None)
    ycoord = GwGenericDescriptor(None)
    compass = GwGenericDescriptor(None)
    tstamp = GwGenericDescriptor(None)
    text = GwGenericDescriptor(None)
    index_val = GwGenericDescriptor(None)
    is_last = GwGenericDescriptor(None)

    def __init__(self):
        """ Class constructor """
        GwTable.__init__(self, 'om_visit_event', 'id')

