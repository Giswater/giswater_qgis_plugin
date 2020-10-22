/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/10/22
UPDATE sys_param_user SET label = 'QGIS composers path' WHERE id = 'qgis_composers_folderpath';
UPDATE sys_param_user SET label = 'QGIS hide buttons on toolbox' WHERE id = 'qgis_toolbar_hidebuttons';
UPDATE sys_param_user SET label = 'Name of polygon virtual layer' WHERE id = 'virtual_polygon_vdefault';
UPDATE sys_param_user SET label = 'Name of point virtual layer' WHERE id = 'virtual_point_vdefault';
UPDATE sys_param_user SET label = 'Name of line virtual layer' WHERE id = 'virtual_line_vdefault';
