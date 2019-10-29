/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--29/10/2019

INSERT INTO config_api_form_fields(id, formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden)VALUES (30090, 'lot','lot', 'team_id', 1, 3, TRUE, NULL, 'combo', 'Equip:', NULL, NULL, NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM cat_team ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE);

UPDATE config_api_form_fields SET tooltip = concat(column_id,' - ',tooltip) WHERE formtype = 'feature' AND tooltip IS NOT NULL;
UPDATE config_api_form_fields SET tooltip = column_id WHERE formtype = 'feature' AND tooltip IS NULL;