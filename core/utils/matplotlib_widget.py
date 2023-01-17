"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import subprocess
from ...lib import tools_qt

try:
    import matplotlib
    from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg
    from matplotlib.figure import Figure

    matplotlib.use('Qt5Agg')

except ImportError:
    matplotlib = None
    FigureCanvasQTAgg = None
    Figure = None
    if tools_qt.show_question("Matplotlib Python package not found. Do you want to install Matplotlib?"):
        subprocess.run(["python", "-m", "ensurepip"])
        install_matplotlib = subprocess.run(['python', '-m', 'pip', 'install', '-U', 'matplotlib'])
        if install_matplotlib.returncode:
            tools_qt.show_info_box(
                "Matplotlib cannot be installed automatically. Please install Matplotlib manually."
            )
        else:
            tools_qt.show_info_box("Matplotlib installed successfully. Please restart QGIS.")



class MplCanvas(FigureCanvasQTAgg):

    def __init__(self, parent=None, width=5, height=4, dpi=100):
        if not Figure:
            return
        fig = Figure(figsize=(width, height), dpi=dpi)
        self.axes = fig.add_subplot(111)
        super(MplCanvas, self).__init__(fig)
