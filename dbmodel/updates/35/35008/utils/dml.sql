/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/04
UPDATE config_toolbox SET functionparams = '{"featureType":["arc"]}' WHERE id = 2496;

-- 2021/06/07
INSERT INTO config_param_system (parameter, value, descript, project_type) VALUES(
'edit_element_widgets_to_hiden',  '{}', 
'Variable to customize widgets from element form. Available widggets:
["element_id", "code", "element_type", "elementcat_id", "num_elements", "state", "state_type", "expl_id", "ownercat_id", "location_type", "buildercat_id", "builtdate", "workcat_id", "workcat_id_end", "comment", "observ", "link", "verified", "rotation", "undelete", "btn_add_geom"]',
'ws')
ON CONFLICT (parameter) DO NOTHING;
