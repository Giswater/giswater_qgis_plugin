# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

__author__ = 'Luigi Pirelli'
__date__ = 'January 2018'
__copyright__ = '(C) 2018, Luigi Pirelli'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

from giswater.dao.table import Table, GenericDescriptor


class OmVisitEvent(Table):
    """ Class to serialize table 'om_visit_event' """

    id = GenericDescriptor(-1)
    event_code = GenericDescriptor(None)
    visit_id = GenericDescriptor(None)
    position_id = GenericDescriptor(None)
    position_value = GenericDescriptor(None)
    parameter_id = GenericDescriptor(None)
    value = GenericDescriptor(None)
    value1 = GenericDescriptor(None)
    value2 = GenericDescriptor(None)
    geom1 = GenericDescriptor(None)
    geom2 = GenericDescriptor(None)
    geom3 = GenericDescriptor(None)
    xcoord = GenericDescriptor(None)
    ycoord = GenericDescriptor(None)
    compass = GenericDescriptor(None)
    tstamp = GenericDescriptor(None)
    text = GenericDescriptor(None)
    index_val = GenericDescriptor(None)
    is_last = GenericDescriptor(None)

    def __init__(self, controller):
        """ Class constructor """  
        Table.__init__(self, controller, 'om_visit_event', 'id')
        
