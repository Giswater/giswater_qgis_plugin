/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

--25/03/2025

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_drainzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 10, 'string', 'combo', 'expl_id', 'expl_id', '1', NULL, false, true, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, NULL, NULL, NULL, false, NULL);
