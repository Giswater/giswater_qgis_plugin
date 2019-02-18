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


class OmVisit(Table):
    """ Class to serialize table 'om_visit' """

    id = GenericDescriptor(-1)
    visitcat_id = GenericDescriptor(None)
    ext_code = GenericDescriptor(None)
    startdate = GenericDescriptor(None)
    enddate = GenericDescriptor(None)
    user_name = GenericDescriptor(None)
    webclient_id = GenericDescriptor(None)
    expl_id = GenericDescriptor(None)
    the_geom = GenericDescriptor(None)
    descript = GenericDescriptor(None)
    is_done = GenericDescriptor(None)

    def __init__(self, controller):
        """ Class constructor """
        Table.__init__(self, controller, 'om_visit', 'id')
        
