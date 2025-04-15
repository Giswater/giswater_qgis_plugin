/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM sys_table WHERE id IN ('vp_basic_arc', 'vp_basic_node', 'vp_basic_connec', 'vp_basic_gully');

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_arc';

INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('SERVCONNECTION', 'LINK', 'UNDEFINED', 'man_servconnection');


DELETE FROM sys_feature_class WHERE id = 'ELEMENT' AND type = 'ELEMENT';
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('FLWREG', 'ELEMENT', 'UNDEFINED', 'man_flwreg');
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('GENELEMENT', 'ELEMENT', 'UNDEFINED', 'man_genelement');


DELETE FROM cat_feature WHERE id = 'LINK';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3286, 'arc_id column cannot be modified when state = 0 on plan_psector %psector_id%.', '', 2, true, 'utils', 'core');

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('PUMP', 'ELEMENT', 'inp_flwreg_pump', NULL, true);

INSERT INTO config_typevalue (typevalue, id, camelstyle, idval, addparam) VALUES('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', NULL, NULL, '{"orderBy":89}'::json);


INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('FRPUMP', 'FLWREG', 'ELEMENT', 'v_edit_element', 've_elem_frpump', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer)
SELECT upper(REPLACE(id, ' ', '_')), 'GENELEMENT', 'ELEMENT', 'v_edit_element', concat('ve_elem_', lower(REPLACE(id, ' ', '_'))) FROM element_type ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3388, 'gw_fct_admin_dynamic_trigger', 'utils', 'function', 'json', 'json', 'Function to insert or update columns dynamically through triggers', 'role_admin', NULL, 'core');

UPDATE config_report SET query_text='SELECT e.name as "Exploitation", vec.connec_id, vec.code, vec.customer_code FROM v_edit_connec vec JOIN exploitation e USING (expl_id) ' WHERE id=101;

-- 10/04/25
ALTER TABLE config_info_layer DROP COLUMN tableparent_id;

UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_arc';

INSERT INTO config_info_layer (layer_id, is_parent, is_editable, formtemplate, headertext, orderby) 
VALUES('v_edit_flwreg', true, true, 'info_generic', 'Flow regulator', 4);


-- config typevalue
update config_typevalue set addparam ='{"orderBy":10}' where id ='{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"POLYGON"}';
update config_typevalue set addparam ='{"orderBy":51}' where id ='{"level_1":"INVENTORY","level_2":"AUXILIAR"}';

insert into config_typevalue values ('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK", "level_3":"FLWREG"}', null, null, '{"orderBy":8}');
insert into config_typevalue values ('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK", "level_3":"GENELEMENT"}', null, null, '{"orderBy":9}');

-- sys table
insert into sys_table values ('v_edit_genelement', 'Parent view for general elements', 'role_basic', null, 
'{"level_1":"INVENTORY","level_2":"NETWORK", "level_3":"GENELEMENT"}', 1, 'Genelement', null, null, null, 'core'); 

insert into sys_table values ('v_edit_flwreg', 'Parent view for flowregulator elements', 'role_basic', null, 
'{"level_1":"INVENTORY","level_2":"NETWORK", "level_3":"FLWREG"}', 1, 'Flowregulator', null, null, null, 'core'); 

update sys_table set context ='{"level_1":"INVENTORY","level_2":"OTHER"}' , orderby = 1 where id = 'v_edit_dimensions';

insert into sys_table values ('v_edit_cat_feature_element', 'Catalog for elements', 'role_edit', null, 
'{"level_1":"INVENTORY","level_2":"CATALOGS"}', 7, 'Element feature catalog', null, null, null, 'core');

