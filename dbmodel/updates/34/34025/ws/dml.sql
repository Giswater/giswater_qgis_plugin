/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'custom_dint', 21, 'double', 'text', 'custom_dint', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_inp_valve' and columnname = 'flow' ON CONFLICT  (formname, formtype, columnname) DO NOTHING;
