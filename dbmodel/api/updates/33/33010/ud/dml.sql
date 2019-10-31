/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--30/10/2019
SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_form_fields (formname, formtype, column_id, isenabled, ismandatory,
            datatype, widgettype, label, iseditable, widgetcontrols, hidden)
VALUES ('inp_hydrograph', 'form','text', true,false, 'string','text','text', true,'{"setQgisMultiline":true}', false);

INSERT INTO config_api_form_fields (formname, formtype, column_id, isenabled, ismandatory,
            datatype, widgettype, label, iseditable, widgetcontrols, hidden)
VALUES ('inp_transects', 'form','text', true,false, 'string','text','text', true,'{"setQgisMultiline":true}', false);

INSERT INTO config_api_form_fields (formname, formtype, column_id, isenabled, ismandatory,
            datatype, widgettype, label, iseditable, widgetcontrols, hidden)
VALUES ('inp_controls_x_arc', 'form','text', true, false,'string','text','text', true,'{"setQgisMultiline":true}', false);

INSERT INTO config_api_form_fields (formname, formtype, column_id, isenabled, ismandatory,
            datatype, widgettype, label, iseditable, widgetcontrols, hidden)
VALUES ('inp_controls_x_node', 'form','text', true, false,'string','text','text', true,'{"setQgisMultiline":true}', false);