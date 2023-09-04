/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, 
label,isparent, iseditable, isautoupdate, isfilter, hidden)
SELECT 'v_edit_drainzone', 'form_feature', 'tab_none', attname, 'lyt_data_1', attnum,
attname, false, true, false, false, false FROM   pg_attribute
WHERE  attrelid = 'SCHEMA_NAME.v_edit_drainzone'::regclass 
and attname!='the_geom';
	
UPDATE config_form_fields set datatype='boolean', widgettype='check'
where formname = 'v_edit_drainzone' and columnname in ('active', 'undelete');

UPDATE config_form_fields set datatype='string', widgettype='text'
where formname = 'v_edit_drainzone' and columnname in ('stylesheet', 'name','descript','graphconfig','link');

UPDATE config_form_fields set datatype='integer', widgettype='text', ismandatory = true
where formname = 'v_edit_drainzone' and columnname in ('drainzone_id');

UPDATE config_form_fields set datatype=a.datatype, widgettype=a.widgettype, ismandatory = a.ismandatory, dv_querytext=a.dv_querytext,
dv_orderby_id=a.dv_orderby_id,dv_isnullvalue=a.dv_isnullvalue
from (select datatype, widgettype, ismandatory,  dv_querytext, dv_orderby_id, dv_isnullvalue
from config_form_fields where formname = 'v_edit_node' and columnname in ('expl_id'))a
where formname = 'v_edit_drainzone' and columnname in ('expl_id');