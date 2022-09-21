/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/21
INSERT INTO config_form_fields(formname, formtype, tabname, columnname,  datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate,  dv_querytext,  dv_isnullvalue, hidden)
VALUES ('v_edit_dma', 'form_feature', 'data', 'avg_press', 'numeric', 'text', 'average pressure', null,
null, false, false, true, false, null,null, false);
