/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system set 
value = '{"arc": "SELECT arc_id AS arc_id, concat(v_edit_arc.matcat_id,''-Ø'',(c.geom1*100)::integer) as catalog, (case when slope is not null then concat((100*slope)::numeric(12,2),'' % / '',gis_length::numeric(12,2),''m'') else concat(''None / '',gis_length::numeric(12,2),''m'') end) as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id", "node": "SELECT node_id AS node_id, code AS code FROM v_edit_node"}'
where parameter = 'om_profile_guitartext';

-- 01/07/2024
UPDATE sys_table SET addparam='{"pkey":"hydrology_id"}'::json WHERE id='v_edit_cat_hydrology';

-- 02/07/2024
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_connec', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 44, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_vconnec', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 44, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

-- 05/07/2024
UPDATE sys_param_user SET "label"='End date' WHERE id='inp_options_end_date';
