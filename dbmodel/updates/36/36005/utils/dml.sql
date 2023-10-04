/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP RULE macroexploitation_undefined ON macroexploitation;
DROP RULE macroexploitation_del_undefined ON macroexploitation;

INSERT INTO macroexploitation VALUES (1, 'Default', 'Default macroexploitation', NULL) ON CONFLICT (macroexpl_id) DO NOTHING;


CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;
   
  CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;
   
 
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3280, 'gw_fct_setnoderotation', 'utils', 'function', 'json', 'json', 'Function to update massively the column rotation for nodes. Function works with the selection of user (exploitation and psectors)', 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (516, 'Node rotation update', 'utils', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3280, 'Massive node rotation update','{"featureType":[]}', '{}', null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id, formname, descript, sys_role, project_type, ismandatory, source) 
VALUES ('edit_disable_arctopocontrol', 'dynamic', 'If true, topocontrol is disabled', 'role_edit', 'utils', true, 'core');

INSERT INTO sys_param_user (id, formname, descript, sys_role, project_type, ismandatory, source) 
VALUES ('edit_disable_update_nodevalues', 'dynamic', 'If true, topocontrol is disabled', 'role_edit', 'utils', true, 'core');


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_link', formtype, 'tab_none', columnname, 'lyt_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_connec' AND columnname in ('connecat_id', 'workcat_id', 'workcat_id_end','builtdate','enddate', 'drainzone_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET ismandatory = false, dv_orderby_id = true, dv_parent_id = NULL, dv_querytext_filterc = NULL WHERE  columnname = 'connecat_id' AND formname = 'v_edit_link';

UPDATE config_form_fields SET iseditable = true, placeholder=null WHERE  columnname in ('workcat_id', 'workcat_id_end', 'builtdate', 'enddate') AND formname = 'v_edit_link';

UPDATE config_form_fields SET iseditable = false, placeholder=null WHERE  columnname in ('connecat_id', 'drainzone_id') AND formname = 'v_edit_link';

UPDATE config_form_fields SET dv_querytext = 'SELECT id as id, name as idval from drainzone WHERE id IS NOT NULL ' WHERE  columnname in ('drainzone_id') AND formname = 'v_edit_link';

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('tabname_typevalue', 'tab_exploitation_add', 'tab_exploitation_add', 'ExploitationAdd', null);