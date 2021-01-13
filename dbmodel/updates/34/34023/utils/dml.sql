/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/10/19
UPDATE config_form_fields SET iseditable = true WHERE columnname in ('state_type', 'expl_id') AND formname like 'v_edit_inp%';

UPDATE sys_param_user SET datatype = 'float', widgettype = 'spinbox' where id = 'edit_element_doublegeom';

-- 2020/10/21
UPDATE sys_param_user SET label = 'QGIS initproject set layer propierties' WHERE id = 'qgis_layers_set_propierties';
UPDATE sys_param_user SET label = 'QGIS initproject show guidemap' WHERE id = 'qgis_init_guide_map';
UPDATE sys_param_user SET label = 'QGIS initproject hide check form' WHERE id = 'qgis_form_initproject_hidden';
UPDATE sys_param_user SET label = 'QGIS initproject check database' WHERE id = 'utils_checkproject_database';
