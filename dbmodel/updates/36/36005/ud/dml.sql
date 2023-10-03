/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_inp_transects',formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'inp_transects_value'  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_inp_transects',formtype, tabname, columnname, null, null, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 've_node' AND columnname in ('sector_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET dv_isnullvalue = false WHERE formname='v_edit_inp_transects' and columnname in ('sector_id');

INSERT INTO sys_table(id, descript, sys_role,  source, context,alias )
VALUES ('v_edit_inp_transects' , 'Editable view of transects', 'role_epa', 'core','{"level_1":"EPA","level_2":"CATALOGS"}','Transects value')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET context=NULL, alias = NULL WHERE id = 'inp_transects_value';

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3276, 'gw_trg_edit_inp_transects', 'ud', 'function trigger', null, null, 'Function trigger that allows editing view of inp transects', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;


-- 3/10/2023
update config_toolbox set device = '{4}' WHERE id in (3172,2110,3040,2768);

update config_report set 
alias = 'Conduit length by exploitation and catalog',
query_text = 'SELECT name as "Exploitation", arccat_id as "Arc Catalog", sum(gis_length) as "Length" FROM v_edit_arc JOIN exploitation USING (expl_id) GROUP BY arccat_id, name',
addparam = '{"orderBy":"1", "orderType": "DESC"}',
filterparam = '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER BY name","isNullValue":"true"},
{"columnname":"Arc Catalog", "label":"Arc catalog:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select id as id, id as idval FROM cat_arc WHERE id IS NOT NULL ORDER BY id","isNullValue":"true"}]'
WHERE id = 100;

INSERT INTO config_report (id, alias, query_text, addparam, filterparam, sys_role, active, device) VALUES
(105, 'Nodes by exploitation and type', 'SELECT name as "Exploitation", node_type as "Node type", count(*) as "Units" FROM v_edit_node JOIN exploitation USING (expl_id) GROUP BY node_type, name',
 '{"orderBy":"1", "orderType": "DESC"}',
 '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER BY name","isNullValue":"true"},
{"columnname":"Node type", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select id as id, id as idval FROM cat_feature_node join cat_feature USING (id) WHERE id IS NOT NULL AND active ORDER BY id","isNullValue":"true"}]',
'role_basic', true, '{4,5}')
ON CONFLICT id DO NOTHING;