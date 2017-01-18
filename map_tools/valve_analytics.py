"""
/***************************************************************************
        begin                : 2016-01-05
        copyright            : (C) 2016 by BGEO SL
        email                : vicente.medina@gits.ws
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

"""

# -*- coding: utf-8 -*-
from qgis.core import QgsPoint, QgsMapLayer, QgsVectorLayer, QgsRectangle, QGis
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, QRect, Qt
from PyQt4.QtGui import QApplication, QColor

from map_tools.parent import ParentMapTool


class ValveAnalytics(ParentMapTool):
    ''' Button 20. User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_connect_to_network' '''    

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ValveAnalytics, self).__init__(iface, settings, action, index_action)

        self.dragging = False

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(11)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX)  # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)

        # Rubber band
        self.rubberBand = QgsRubberBand(self.canvas, True)
        mFillColor = QColor(100, 0, 0);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(3)
        mBorderColor = QColor(254, 58, 29)
        self.rubberBand.setBorderColor(mBorderColor)

        # Select rectangle
        self.selectRect = QRect()

