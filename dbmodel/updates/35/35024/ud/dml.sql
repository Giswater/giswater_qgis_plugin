/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/02
UPDATE config_form_fields SET formname='v_edit_inp_coverage' where formname ='inp_coverage_land_x_subc';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_coverage', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE columnname ilike 'hydrology_id' AND formname='v_edit_inp_subcatchment';

INSERT INTO sys_table(id, descript, sys_role,  context, orderby, alias, source)
VALUES ('v_edit_inp_coverage', 'Editable view to manage coverage', 'role_epa',  '{"level_1":"EPA","level_2":"HYDRAULICS"}',17, 'Inp coverage', 
'core');

INSERT INTO sys_table (id, descript, sys_role, source)
VALUES ('v_anl_grafanalytics_upstream', 'Table to work with grafanalytics', 'role_epa', 'giswater') 
ON CONFLICT (id) DO NOTHING;