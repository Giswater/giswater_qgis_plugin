# -*- coding: utf-8 -*-
"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

__author__ = 'Luigi Pirelli'
__date__ = 'January 2018'
__copyright__ = '(C) 2018, Luigi Pirelli'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

from dao.table import Table, GenericDescriptor


class OmVisitParameter(Table):
    """ Class to serialize table 'om_visit_parameter' """

    id = GenericDescriptor(None)
    code = GenericDescriptor(None)
    parameter_type = GenericDescriptor(None)
    feature_type = GenericDescriptor(None)
    data_type = GenericDescriptor(None)
    criticity = GenericDescriptor(None)
    descript = GenericDescriptor(None)
    form_type = GenericDescriptor(None)
    vdefault = GenericDescriptor(None)

    def __init__(self, controller):
        """ Class constructor """          
        Table.__init__(self, controller, 'om_visit_parameter', 'id')
        
