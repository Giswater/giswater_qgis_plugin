/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/12/14
UPDATE cat_dwf_scenario SET active = TRUE WHERE active IS NULL;
UPDATE cat_hydrology SET active = TRUE WHERE active IS NULL;
UPDATE cat_mat_grate SET active = TRUE WHERE active IS NULL;
UPDATE cat_mat_gully SET active = TRUE WHERE active IS NULL;


UPDATE config_form_fields SET dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE columnname IN ('gratecat_id') AND ( formname ilike 've_gully%' OR formname in ('v_edit_gully'))and dv_querytext is not null;

--2020/12/18
UPDATE sys_param_user SET dv_querytext = 'SELECT id AS id, id AS idval FROM cat_feature_arc JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE'
WHERE id ='edit_arctype_vdefault';

UPDATE sys_param_user SET dv_querytext = 'SELECT id AS id, id AS idval FROM cat_feature_node JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE'
WHERE id ='edit_nodetype_vdefault';

UPDATE sys_param_user SET dv_querytext = 'SELECT id AS id, id AS idval FROM cat_feature_connec JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE'
WHERE id ='edit_connectype_vdefault';

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE id IN ('edit_connecarccat_vdefault','edit_gratecat_vdefault');

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND cat_grate.active IS TRUE ')
FROM cat_feature WHERE upper(cat_feature.id) = upper(replace(replace(sys_param_user.id,'feat_'::text,''::text),'_vdefault',''))
AND feature_type = 'GULLY';
