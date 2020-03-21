/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/18
UPDATE audit_cat_table SET isdeprecated = true 
WHERE id IN ('v_arc_dattrib','v_node_dattrib','vi_parent_node','v_connec_dattrib','v_gully_dattrib', 
'vp_epa_node','vp_epa_arc', 'v_node_x_arc', 'v_arc_x_node');

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('v_connec', 'GIS feature', 'Auxiliar view for connecs', 'role_basic', 0, 'role_basic', false);

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('v_gully', 'GIS feature', 'Auxiliar view for gully', 'role_basic', 0, 'role_basic', false);

update audit_cat_table set isdeprecated = true where id like '%v_inp%';
update audit_cat_table set id = 'vi_subcatch2node' WHERE id = 'v_inp_subcatch2node';
update audit_cat_table set id = 'vi_subcatchcentroid' WHERE id = 'v_inp_subcatchcentroid';