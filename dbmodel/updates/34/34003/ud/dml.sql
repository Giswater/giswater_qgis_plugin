/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/13

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, qgis_criticity, qgis_message, isdeprecated)
VALUES ('v_anl_flow_gully', 'Analysis', 'View with the result of flow trace and flow exit results (gully)','role_om',0,'role_om',2,
'Cannot view the results of flowtrace analytics tool related to gullies', false);

-- 2020/03/12
UPDATE audit_cat_table  SET isdeprecated=TRUE WHERE id = 'anl_flow_arc' OR id = 'anl_flow_node';

-- 2020/03/13
UPDATE audit_cat_param_user SET layout_order = 31 where layout_order = 68 and layoutname = 'grl_general_1';
UPDATE audit_cat_param_user SET formname = 'epaoptions', label = 'Default value q0 on Conduit:', layoutname = 'grl_general_1', 
layout_order = 32, epaversion = '{"from":"5.0.022", "to":null,"language":"english"}' WHERE id = 'epa_conduit_q0_vdefault';
UPDATE audit_cat_param_user SET formname = 'epaoptions', label = 'Default value q0 on Junction:', layoutname = 'grl_general_1', layout_order = 33,
epaversion = '{"from":"5.0.022", "to":null,"language":"english"}' WHERE id = 'epa_junction_y0_vdefault';

UPDATE audit_cat_param_user SET layout_order = 15 where layout_order = 90 and layoutname = 'grl_general_2';
UPDATE audit_cat_param_user SET formname = 'epaoptions',  label = 'Default value for Outfall type:', layoutname = 'grl_general_2', layout_order = 16,
epaversion = '{"from":"5.0.022", "to":null,"language":"english"}' WHERE id = 'epa_outfall_type_vdefault';
UPDATE audit_cat_param_user SET formname = 'epaoptions',  label = 'Default value for Rgage SCF:', layoutname = 'grl_general_2', layout_order = 17, 
epaversion = '{"from":"5.0.022", "to":null,"language":"english"}' WHERE id = 'epa_rgage_scf_vdefault';
