"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ...libs import tools_os, tools_qgis


def create_mpl_canvas(parent=None, width=5, height=4, dpi=100):
    """Factory function that creates a matplotlib FigureCanvasQTAgg widget.

    Returns the canvas widget with an ``axes`` attribute, or ``None`` if
    matplotlib is not installed.
    """
    try:
        matplotlib = tools_os.get_dep("matplotlib")
        matplotlib.use('Qt5Agg')
        backend_qt5agg = tools_os.get_dep("matplotlib.backends.backend_qt5agg")
        figure_module = tools_os.get_dep("matplotlib.figure")
        FigureCanvasQTAgg = backend_qt5agg.FigureCanvasQTAgg
        Figure = figure_module.Figure
    except ImportError:
        tools_qgis.show_critical(
            "Python package 'matplotlib' is not installed. "
            "Please install it using pip or the 'qpip' QGIS plugin."
        )
        return None

    fig = Figure(figsize=(width, height), dpi=dpi)
    canvas = FigureCanvasQTAgg(fig)
    canvas.axes = fig.add_subplot(111)
    return canvas
