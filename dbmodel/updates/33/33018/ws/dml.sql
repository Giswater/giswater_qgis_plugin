/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--28/11/2019
SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, 
	label, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, 
	dv_querytext, isreload,  typeahead, layout_name, hidden)
SELECT 'v_edit_inp_virtualvalve', formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, 
	label, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, 
	dv_querytext, isreload,  typeahead, layout_name, hidden 
FROM config_api_form_fields WHERE formname = 'v_edit_inp_valve';

UPDATE config_api_form_fields SET column_id = 'arc_id', label='arc_id', placeholder = 'Ex.:arc_id' 
WHERE formname = 'v_edit_inp_virtualvalve' AND column_id = 'node_id';

UPDATE config_api_form_fields SET column_id = 'arccat_id', label='arccat_id', placeholder = 'Ex.:arccat_id',
dv_querytext = 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL'
WHERE formname = 'v_edit_inp_virtualvalve' AND column_id = 'nodecat_id';
