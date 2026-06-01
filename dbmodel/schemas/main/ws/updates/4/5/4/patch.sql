/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields
SET dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE ((featurecat_id is null AND ''LINK''=ANY(feature_type)) ) AND active IS TRUE'
WHERE formname='ve_link' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DROP TRIGGER IF EXISTS gw_trg_edit_plan_psector_connec ON ve_plan_psector_x_connec;
DROP VIEW IF EXISTS ve_plan_psector_x_connec;
DROP FUNCTION IF EXISTS gw_trg_edit_plan_psector_x_connect();
DELETE FROM sys_function WHERE id = 3174;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'form_featuretype_change', 'tab_none', 'fluid_type', 'lyt_main_3', 5, 'string', 'combo', 'Fluid type:', 'Fluid type', NULL, NULL, NULL, true, NULL, NULL, 'SELECT fluid_type as id, fluid_type AS idval FROM man_type_fluid WHERE fluid_type IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('om_mincut_conflict','Table of minimum cut analysis related to conflicts','role_om','core') ON CONFLICT DO NOTHING;

DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON arc;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON arc;
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_waterwell":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc", "man_frelem":"to_arc"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_waterwell":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc", "man_frelem":"to_arc"}');
