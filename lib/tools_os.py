# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import os
import sys
import subprocess
import time
import webbrowser

from qgis.PyQt.QtWidgets import QFileDialog


def open_file(file_path):

    try:
        # Check if file exist
        if os.path.exists(file_path):
            # Open file
            if sys.platform == "win32":
                os.startfile(file_path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, file_path])
        else:
            webbrowser.open(file_path)
    except Exception:
        return False
    finally:
        return True


def set_filename(prefix_name='log', tstamp_format='%Y%m%d'):

    tstamp = str(time.strftime(tstamp_format))
    name = prefix_name + "_" + tstamp + ".log"
    return name


def get_relative_path(filepath, levels=1):

    common = filepath
    for i in range(levels + 1):
        common = os.path.dirname(common)

    return os.path.relpath(filepath, common)


def get_values_from_dictionary(dictionary):
    """ Return values from @dictionary """

    list_values = iter(dictionary.values())
    return list_values


def open_url(widget):

    path = widget.text()
    # Check if file exist
    if os.path.exists(path):
        # Open the document
        if sys.platform == "win32":
            os.startfile(path)
        else:
            opener = "open" if sys.platform == "darwin" else "xdg-open"
            subprocess.call([opener, path])
    else:
        webbrowser.open(path)


def cast_boolean(param):
    """ Receives a string and returns a bool
    :param param: String to cast
    :return: Boolean value, True if param not in bool_dict
    """

    bool_dict = {"True": True, "true": True, "False": False, "false": False}

    return bool_dict.get(param, True)


def open_file_path(msg="Select file", filter_="All (*.*)"):
    """ Open QFileDialog """

    path, filter_ = QFileDialog.getOpenFileName(None, msg, "", filter_)
    return path, filter_

