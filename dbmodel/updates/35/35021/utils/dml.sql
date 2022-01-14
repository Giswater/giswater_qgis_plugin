/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
UPDATE sys_param_user SET source = 'core' WHERE source IS NULL;
UPDATE sys_param_user SET source = 'core' WHERE source ='giswater';

UPDATE sys_fprocess SET source = 'core' WHERE source IS NULL;
UPDATE sys_fprocess SET source = 'core' WHERE source ='giswater';

UPDATE sys_function SET source = 'core' WHERE source IS NULL;
UPDATE sys_function SET source = 'core' WHERE source ='giswater';

UPDATE sys_message SET source = 'core' WHERE source IS NULL;
UPDATE sys_message SET source = 'core' WHERE source ='giswater';

UPDATE sys_table SET source = 'core' WHERE source IS NULL;
UPDATE sys_table SET source = 'core' WHERE source ='giswater';

UPDATE config_toolbox SET inputparams = 
'[{"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["DELETE VALUES & COPY FROM", "KEEP VALUES & COPY FROM", "DELETE SCENARIO"], "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":""},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"$userDscenario"}
  ]'
WHERE id = 3042;

--2022/01/03

INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"CATALOG"}', null, '{"orderBy":1}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"MAPZONE"}', null, '{"orderBy":2}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"ARC"}', null, '{"orderBy":3}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"NODE"}', null, '{"orderBy":4}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"CONNEC"}', null, '{"orderBy":5}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"GULLY"}', null, '{"orderBy":6}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"OTHER"}', null, '{"orderBy":7}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"AUXILIAR"}', null, '{"orderBy":8}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"OM","level_2":"MINCUT"}', null, '{"orderBy":9}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"OM","level_2":"PROFILE"}', null, '{"orderBy":10}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"OM","level_2":"VISIT"}', null, '{"orderBy":11}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"EPA", "level_2":"CATALOG"}', null, '{"orderBy":12}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"EPA", "level_2":"INPUT"}', null, '{"orderBy":13}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"EPA", "level_2":"DSCENARIO"}', null, '{"orderBy":14}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"EPA", "level_2":"RESULT"}', null, '{"orderBy":15}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"EPA", "level_2":"COMPARE"}', null, '{"orderBy":16}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"PLAN","level_2":"CATALOG"}', null, '{"orderBy":17}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"PLAN","level_2":"PSECTOR"}', null, '{"orderBy":18}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"PLAN","level_2":"PRICES"}', null, '{"orderBy":19}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"ADMIN","level_2":"MAPZONES"}', null, '{"orderBy":20}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"ADMIN","level_2":"CATALOG"}', null, '{"orderBy":21}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"BASEMAP","level_2":"ADDRESS"}', null, '{"orderBy":22}') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO config_typevalue VALUES ('sys_table_context','{"level_1":"BASEMAP","level_2":"CARTO"}', null, '{"orderBy":22}') ON CONFLICT (typevalue, id) DO NOTHING;


UPDATE sys_table SET context = NULL, alias = NULL, orderby = null;
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Feature catalog' , orderby=1 WHERE id ='cat_feature';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Node feature catalog' , orderby=2 WHERE id ='cat_feature_node';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Node material catalog' , orderby=3 WHERE id ='cat_mat_node';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Node catalog' , orderby=4 WHERE id ='cat_node';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Arc material catalog' , orderby=5 WHERE id ='cat_mat_arc';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Arc catalog' , orderby=6 WHERE id ='cat_arc';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Connec catalog' , orderby=7 WHERE id ='cat_connec';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOG"}', alias = 'Grate catalog' , orderby=8 WHERE id ='cat_grate';

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"MAPZONE"}', alias = 'Exploitation', orderby=1 WHERE id= 'v_edit_exploitation';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"MAPZONE"}', alias = 'Sector', orderby=2 WHERE id= 'v_edit_sector';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"MAPZONE"}', alias = 'DMA' , orderby=3 WHERE id= 'v_edit_dma';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"MAPZONE"}', alias = 'Presszone', orderby=4 WHERE id= 'v_edit_presszone';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"MAPZONE"}', alias = 'DQA' , orderby=5 WHERE id= 'v_edit_dqa';

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"ARC"}', alias = initcap(cat_feature.id) FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'ARC';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"NODE"}', alias = initcap(cat_feature.id) FROM cat_feature  WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'NODE';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CONNEC"}', alias = initcap(cat_feature.id) FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'CONNEC';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"GULLY"}', alias = initcap(cat_feature.id)  FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'GULLY';

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"ARC"}', alias = 'Arc', orderby=1 WHERE id='v_edit_arc';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"NODE"}', alias = 'Node', orderby=1  WHERE id='v_edit_node';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CONNEC"}',alias = 'Connec', orderby=1  WHERE id='v_edit_connec';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"GULLY"}', alias = 'Gully', orderby=1  WHERE id='v_edit_gully';

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"NODE"}', alias = 'Node polygon'  WHERE id='ve_pol_node';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CONNEC"}', alias = 'Connec polygon'  WHERE id='ve_pol_connec';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"GULLY"}', alias = 'Gully polygon'  WHERE id='ve_pol_gully';

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by id)  as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"INVENTORY","level_2":"ARC"}' and orderby IS NULL ) c2
WHERE c2.id = c.id;

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by id) as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"INVENTORY","level_2":"NODE"}' and orderby IS NULL) c2
WHERE c2.id = c.id;

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by id)  as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"INVENTORY","level_2":"CONNEC"}' and orderby IS NULL ) c2
WHERE c2.id = c.id;

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by id)  as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"INVENTORY","level_2":"GULLY"}'  and orderby IS NULL) c2
WHERE c2.id = c.id;

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"OTHER"}', alias = 'Dimensioning' , orderby=1  WHERE id='v_edit_dimensions';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"OTHER"}', alias = 'Element' , orderby=2  WHERE id='v_edit_element';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"OTHER"}', alias = 'Samplepoint' , orderby=3  WHERE id='v_edit_samplepoint';

UPDATE sys_table SET context ='{"level_1":"INVENTORY","level_2":"AUXILIAR"}', alias = 'Point' , orderby=1 WHERE id ='v_edit_cad_auxpoint';
UPDATE sys_table SET context ='{"level_1":"INVENTORY","level_2":"AUXILIAR"}', alias = 'Line' , orderby=2 WHERE id ='v_edit_cad_auxline';
UPDATE sys_table SET context ='{"level_1":"INVENTORY","level_2":"AUXILIAR"}', alias = 'Cirle' , orderby=3 WHERE id ='v_edit_cad_auxcircle';


UPDATE sys_table SET context = '{"level_1":"OM","level_2":"MINCUT"}', alias = 'Mincut init point' , orderby=1 WHERE id ='v_om_mincut';
UPDATE sys_table SET context = '{"level_1":"OM","level_2":"MINCUT"}', alias = 'Mincut result valve' , orderby=2 WHERE id ='v_om_mincut_valve';
UPDATE sys_table SET context = '{"level_1":"OM","level_2":"MINCUT"}', alias = 'Mincut result node' , orderby=3 WHERE id ='v_om_mincut_node';
UPDATE sys_table SET context = '{"level_1":"OM","level_2":"MINCUT"}', alias = 'Mincut result connec' , orderby=4 WHERE id ='v_om_mincut_connec';
UPDATE sys_table SET context = '{"level_1":"OM","level_2":"MINCUT"}', alias = 'Mincut result arc' , orderby=5 WHERE id ='v_om_mincut_arc';

UPDATE sys_table SET context = '{"level_1":"OM","level_2":"PROFILE"}', alias = id WHERE sys_role = 'role_om' and id ILIKE 'profile%';
UPDATE sys_table SET context = '{"level_1":"OM","level_2":"VISIT"}', alias = 'Visit', orderby=1 WHERE id ='v_edit_om_visit';

UPDATE sys_table SET context = '{"level_1":"OM","level_2":"VISIT"}', alias = idval FROM config_visit_class 
WHERE sys_table.sys_role = 'role_om' and sys_table.id=tablename and sys_table.id!='om_visit';

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by id) +1 as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"OM","level_2":"VISIT"}' ) c2
WHERE c2.id = c.id;

UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Dscenario catalog' , orderby=1 WHERE id ='v_edit_cat_dscenario';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Roughness catalog' , orderby=2 WHERE id ='cat_mat_roughness';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Curve catalog' , orderby=3 WHERE id ='v_edit_inp_curve';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Curve' , orderby=4 WHERE id ='v_edit_inp_curve_value';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Pattern catalog' , orderby=5 WHERE id ='v_edit_inp_pattern';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Pattern' , orderby=6 WHERE id ='v_edit_inp_pattern_value';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Timeseries catalog' , orderby=7 WHERE id ='v_edit_inp_timeseries';

UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"INPUT"}' , alias = initcap(s.id) FROM sys_feature_epa_type s WHERE sys_table.id = concat('v_edit_',epa_table);
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"DSCENARIO"}', alias = replace(replace(id,'v_edit_inp_d','D'),'_',' ') WHERE sys_table.id ilike 'v_edit_inp_dscenario%';

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by alias) as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"EPA", "level_2":"INPUT"}' AND orderby IS NULL ) c2
WHERE c2.id = c.id;

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by alias) as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"EPA", "level_2":"DSCENARIO"}' AND orderby IS NULL ) c2
WHERE c2.id = c.id;

UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"RESULT"}', alias = replace(initcap(replace(id,'v_rpt_','')),'_',' ') WHERE id like 'v_rpt%' and id not in (SELECT id FROM sys_table WHERE id like 'v_rpt_comp%');
--UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"COMPARE"}', alias = initcap(replace(id,'v_rpt_','')) WHERE id like 'v_rpt%' and id not in (SELECT id FROM sys_table WHERE id like 'v_rpt_comp%');

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by alias) as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"EPA", "level_2":"RESULT"}' AND orderby IS NULL ) c2
WHERE c2.id = c.id;

UPDATE sys_table SET context = '{"level_1":"PLAN","level_2":"PSECTOR"}' , alias = 'Plan psector', orderby = 1 WHERE id = 'v_edit_plan_psector';
UPDATE sys_table SET context = '{"level_1":"PLAN","level_2":"PSECTOR"}' , alias = 'Plan current psector', orderby = 2 WHERE id = 'v_plan_current_psector';
UPDATE sys_table SET context = '{"level_1":"PLAN","level_2":"PSECTOR"}' , alias = replace(replace(id,'v_p','P'),'_',' ')
WHERE id IN ('v_plan_psector_arc', 'v_plan_psector_node', 'v_plan_psector_link', 'v_plan_psector_connec','v_plan_psector_gully');

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by alias) +2 as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"PLAN","level_2":"PSECTOR"}' AND orderby IS NULL ) c2
WHERE c2.id = c.id;

UPDATE sys_table SET context = '{"level_1":"PLAN","level_2":"CATALOG"}' , alias = 'Arc pavement', orderby = 1 WHERE id = 'plan_arc_x_pavement';

UPDATE sys_table SET context = '{"level_1":"PLAN","level_2":"PRICES"}', alias = 'Prices', orderby=1 WHERE id ='plan_price';
UPDATE sys_table SET context = '{"level_1":"PLAN","level_2":"PRICES"}', alias = 'Compost prices', orderby=2 WHERE id ='plan_price_compost';

UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"MAPZONES"}'::json , alias = initcap(replace(id,'v_edit_',''))  WHERE id ilike 'v_edit_macro%';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"MAPZONES"}'::json , alias = initcap(id)  WHERE id ilike 'macroexploitation';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"MAPZONES"}'::json , alias = initcap(replace(id,'v_',''))  WHERE id ilike 'v_minsector';

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by alias) as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"ADMIN","level_2":"MAPZONES"}' AND orderby IS NULL ) c2
WHERE c2.id = c.id;

UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Element material catalog', orderby=1 WHERE id ='cat_mat_element';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Element catalog', orderby=2 WHERE id ='cat_element';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Owner catalog', orderby=3 WHERE id ='cat_owner';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Soil catalog', orderby=4 WHERE id ='cat_soil';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Pavement catalog', orderby=5 WHERE id ='cat_pavement';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Work catalog', orderby=6 WHERE id ='cat_work';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Builder catalog', orderby=7 WHERE id ='cat_builder';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Brand model catalog', orderby=8 WHERE id ='cat_brand_model';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Brand catalog', orderby=9 WHERE id ='cat_brand';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Users catalog', orderby=10 WHERE id ='cat_users';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Period catalog', orderby=11 WHERE id ='ext_cat_period';
UPDATE sys_table SET context = '{"level_1":"ADMIN","level_2":"CATALOG"}', alias = 'Hydrometer catalog', orderby=12 WHERE id ='ext_cat_hydrometer';

UPDATE sys_table SET context = '{"level_1":"BASEMAP","level_2":"ADDRESS"}'::json , alias = initcap(replace(id,'ext_','')), orderby=1 WHERE id ilike 'ext_municipality';
UPDATE sys_table SET context = '{"level_1":"BASEMAP","level_2":"ADDRESS"}'::json , alias = initcap(replace(id,'v_ext_',''))  WHERE id ilike 'v_ext_%';
UPDATE sys_table SET context = '{"level_1":"BASEMAP","level_2":"CARTO"}'::json , alias = initcap(replace(id,'v_ext_','')), orderby=1   WHERE id ilike 'v_ext_raster_dem';

UPDATE sys_table c SET orderby = c2.seqnum FROM (SELECT c2.id, c2.alias, row_number() over (order by alias) +1 as seqnum
FROM sys_table c2 WHERE context ='{"level_1":"BASEMAP","level_2":"ADDRESS"}' AND orderby IS NULL ) c2
WHERE c2.id = c.id;

INSERT INTO config_form_fields VALUES ('search', 'form_feature', 'main', 'hydro_contains', 'lyt_data_1', NULL, 'string', 'nowidget', 'Use contains', 'Check: allow to search using any of the characters. Unchecked: the search engine only will return results when matching the first characters (useful for short numbers)', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}',NULL,NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_sector','form_feature', 'main', 'parent_id', null, null, 'string', 'combo', 'parent_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ', TRUE, TRUE, NULL, NULL,NULL,
'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}', 
NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE sys_fprocess set project_type='utils' where fid=213;
UPDATE sys_function set project_type='utils' where id=2720;

-- 2022/01/05
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('config_typevalue','sys_table_context','sys_table','context', true);

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3114, 'gw_fct_getaddlayervalues', 'utils', 'function', 'json', 'json', 'Function to manage toc values', 'role_basic', null, null) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3116, 'gw_trg_edit_cat_dscenario', 'utils', 'trigger function', null,null, 'Trigger function for cat dscenario', 'role_epa', null, null) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario','form_feature', 'main', 'parent_id', null, null, 'string', 'combo', 'parent_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id,name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL AND active IS TRUE ', TRUE, TRUE, NULL, NULL,NULL,
'{"setMultiline": false}', 
NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario','form_feature', 'main', 'active', null, null, 'boolean', 'check', 'active', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, TRUE, NULL, NULL,NULL,
'{"setMultiline": false}', NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario','form_feature', 'main', 'expl_id', null, null, 'string', 'combo', 'exploitation', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL ', TRUE, TRUE, NULL, NULL,NULL,
'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}', 
NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario','form_feature', 'main', 'log', null, null, 'string', 'text', 'log', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, TRUE, NULL, NULL,NULL,
'{"setMultiline": false}', NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields
SELECT 'v_edit_cat_dscenario', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields where formname='cat_dscenario' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET widgettype='typeahead' WHERE dv_querytext LIKE '%plan_price WHERE%';

UPDATE sys_fprocess SET isaudit=TRUE WHERE isaudit IS NULL;
UPDATE sys_fprocess SET isaudit = FALSE WHERE fid IN ('349', '350', '351', '352', '353', '302', '347');

INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, source) 
VALUES('v_edit_cat_dscenario', 'Table to manage dynamic scenarios', 'role_epa', '{"level_1":"EPA", "level_2":"CATALOG"}','Dscenario catalog', 2, 'core');

--2022/01/11
UPDATE sys_table SET sys_role='role_basic' WHERE id='selector_sector';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit)
VALUES (433, 'Arc materials not defined in cat_mat_roughness table', 'ws', null, 'core', TRUE) ON CONFLICT (fid) DO NOTHING;

UPDATE sys_fprocess SET fprocess_name='Check if defined nodes and arcs exist in a database' WHERE fid=367;
UPDATE sys_fprocess SET fprocess_name='Mincut conflict scenario result' WHERE fid=131;
UPDATE sys_fprocess SET fprocess_name='Grafanalytics check data' WHERE fid=211;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit)
VALUES (434, 'Backup and restore tables', 'utils', null, 'core', TRUE) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit)
VALUES (435, 'Store hydrometer user selector values', 'utils', null,'core', true) ON CONFLICT (fid) DO NOTHING;

UPDATE sys_fprocess SET fprocess_type='Check admin' WHERE fid IN (303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322);

UPDATE sys_fprocess SET fprocess_type='Check om-data' WHERE fid IN 
( 175,177,187,188,201,202,205,210,252,253,254,256,257,260,261,262,263,264,266,291,302,356,372,406,418,419,421,422,423,424,428);

UPDATE sys_fprocess SET fprocess_type='Check om-topology' WHERE fid IN 
(103,106,196,197,204,223,251,255,259,265,391,417);

UPDATE sys_fprocess SET fprocess_type='Check plan-config' WHERE fid IN 
(252,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,354,355);

UPDATE sys_fprocess SET fprocess_type='Check plan-data' WHERE fid IN (354,355);

UPDATE sys_fprocess SET fprocess_type='Check epa-data' WHERE fid IN 
(153,164,165,169,170,171,175,198,272,273,274,275,276,277,278,279,280,281,284,285,286,287,294,295,368,381,382,395,427);

UPDATE sys_fprocess SET fprocess_type='Check epa-topology' WHERE fid IN 
(106,107,111,113,166,167,229,230,292,293,379,411,412,425);

UPDATE sys_fprocess SET fprocess_type='Check epa-config' WHERE fid IN 
( 142,282,283,371,383,429,430,433);

UPDATE sys_fprocess SET fprocess_type='Check epa-result' WHERE fid IN 
(114,159,172,227,232,290,297,296,373,375,377,396,397,400,402,405,407,413,414,415,416,432);

UPDATE sys_fprocess SET fprocess_type='Check epa-network' WHERE fid IN 
( 227,231,233,228,404,431);

UPDATE sys_fprocess SET fprocess_type='Check graf-data' WHERE fid IN 
(176,177,181,182,208,209,367);

UPDATE sys_fprocess SET fprocess_type='Check graf-config' WHERE fid IN 
(179,180,183,184,185,186,192,268,269,270,271);
 
UPDATE sys_fprocess SET fprocess_type='Check project' WHERE fid IN (349,350,351,352,353); 

UPDATE sys_fprocess SET fprocess_type='Function process' WHERE fid IN 
( 101,104,105,108,109,110,111,112,113,115,116,117,118,124,125,127,128,129,130,131,132,133,134,135,136,137,138,140,141,143,144,145,146,147,149,150,151,152,155,
156,157,158,163,168,193,194,195,199,203,207,211,212,213,214,215,216,217,218,219,220,221,222,225,248,249,250,288,289,298,299,300,301,357,358,359,360,361,362,376,
380,387,394,397,398,399,434,435,403);

UPDATE sys_fprocess SET fprocess_type=NULL WHERE fid IN 
(102,119,120,121,122,123,126,139,148,159,160,161,162,173,174,178,183,184,185,186,190,191,200,224,226,258,267,348,363,364,365,366,369,
370,374,378,389,390,393,401,410,420,426);

UPDATE sys_fprocess SET fprocess_type='Function process' WHERE fprocess_name ilike 'Import%' OR fprocess_name ilike 'Export%' and fprocess_type IS NULL;

UPDATE config_param_system SET 
value='{"table":"sector","selector":"selector_sector","table_id":"sector_id","selector_id":"sector_id","label":"sector_id, '' - '', name","orderBy":"sector_id","manageAll":true,"query_filter":" AND sector_id >=0","typeaheadForced":true,"explFromSector":false}'
WHERE parameter = 'basic_selector_tab_sector';

--2022/01/14
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3126,'gw_fct_setchangefeaturetype', 'utils', 'function', 'json', 'json', 'Change type and catalog of a node, arc, connec or gully', 
'role_edit', NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type)
VALUES (436, 'Change node type', 'utils', NULL, 'core', NULL,'Function process')  ON CONFLICT (fid) DO NOTHING;

