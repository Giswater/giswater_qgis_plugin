/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--28/11/2019
SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_typevalue(typevalue, id, idval)
VALUES ('layout_name_typevalue', 'other_layout', 'other_layout');

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, 
       datatype, widgettype, label, ismandatory, isparent, iseditable, 
       isautoupdate, isreload, layout_name, hidden)
VALUES ('dimensioning', 'catalog','observ',1,1,true,'string', 'text', 'observations',false,false,true,false,false,
'other_layout',false);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, 
       datatype, widgettype, label, ismandatory, isparent, iseditable, 
       isautoupdate, isreload, layout_name, hidden)
VALUES ('dimensioning', 'catalog','comment',1,2,true,'string', 'text', 'comment',false,false,true,false,false,
'other_layout',false);

-- 03/12/2019
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue', 'tabMincut', 'tabMincut');

INSERT INTO config_api_form_tabs (id, formname, tabname, tablabel, tabtext, sys_role, tooltip) VALUES (700, 'mincut', 'tabMincut', 'Mincut', 'Mincut Selector', 'role_basic', 'Mincut');

INSERT INTO config_api_list (id, tablename, query_text, device) VALUES (16, 'om_vehicle_x_parameters', 'SELECT * FROM om_vehicle_x_parameters', 3);

-- 04/12/2019
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, project_type, isdeprecated) VALUES ('api_selector_label', '{"mincut": ["name", "work_order", "state"], "state": ["id", "name"]}', 'json', 'system', 'Select which label to display for selectors', 'Selector labels:', 'utils', 'false');