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
    except Exception as e:
        return False
    finally:
        return True


def manage_tstamp(prefix_name='log', tstamp_format='%Y%m%d', extension='.log'):

    tstamp = str(time.strftime(tstamp_format))
    name = prefix_name + "_" + tstamp + ".log"
    return name


def get_file_with_parents(filepath, levels=1):

    common = filepath
    for i in range(levels + 1):
        common = os.path.dirname(common)

    return os.path.relpath(filepath, common)

