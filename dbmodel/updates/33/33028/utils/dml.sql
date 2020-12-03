/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--12/02/2020

UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='municipality_vdefault';
UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='sector_vdefault';
UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='exploitation_vdefault';
UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='dma_vdefault';



INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (112, 'Arc divide', 'edit', 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (113, 'Node interpolate', 'edit', 'ud') ON CONFLICT (id) DO NOTHING;

--13/02/2020

UPDATE audit_cat_param_user SET isparent = False WHERE id = 'state_vdefault';
UPDATE audit_cat_param_user SET label = 'State type (On service):', dv_querytext = 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL AND state = 1 ', dv_parent_id = NULL, dv_querytext_filterc = NULL WHERE id = 'statetype_vdefault';
UPDATE audit_cat_param_user SET label = 'State type (Obsolete):' WHERE id = 'statetype_end_vdefault';
UPDATE audit_cat_param_user SET sys_role_id = 'role_edit', label = 'State type (Planified):', layout_id = 3, layout_order = 4, dv_parent_id = NULL WHERE id = 'statetype_plan_vdefault';
UPDATE audit_cat_param_user SET layout_order = 5 WHERE id = 'workcat_vdefault';
UPDATE audit_cat_param_user SET layout_order = 6 WHERE id = 'builtdate_vdefault';
UPDATE audit_cat_param_user SET layout_order = 7 WHERE id = 'enddate_vdefault';
UPDATE audit_cat_param_user SET layout_order = 8 WHERE id = 'workcat_id_end_vdefault';
UPDATE audit_cat_param_user SET label = 'Enddate' WHERE label = 'End date:';

--17/02/2020

UPDATE arc_type SET active=TRUE WHERE active IS NULL;
UPDATE arc_type SET code_autofill=TRUE WHERE code_autofill IS NULL;


UPDATE connec_type SET active=TRUE WHERE active IS NULL;
UPDATE connec_type SET code_autofill=TRUE WHERE code_autofill IS NULL;

UPDATE node_type SET active=TRUE WHERE active IS NULL;
UPDATE node_type SET code_autofill=TRUE WHERE code_autofill IS NULL;
UPDATE node_type SET choose_hemisphere=TRUE WHERE choose_hemisphere IS NULL;
UPDATE node_type SET isarcdivide=TRUE WHERE isarcdivide IS NULL;


-- 2020/02/13
UPDATE config_api_layer SET is_editable = TRUE WHERE layer_id = ANY(ARRAY['v_edit_arc', 'v_edit_node','v_edit_connec']);

--17/02/2020
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='verified' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='ownercat_id' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='buildercat_id' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='streetaxis_id' AND formtype='feature';
UPDATE config_api_form_fields SET dv_isnullvalue=TRUE WHERE column_id='streetaxis2_id' AND formtype='feature';
