/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- WS
-- JUNCTION
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'headmax', 'lyt_epa_data_2', 5, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'headavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg head:', 'Avg demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'headmin', 'lyt_epa_data_2', 6, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- PUMP
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'flowavg', 'lyt_epa_data_2', 4, 'string', 'text', 'Avg flow:', 'Avg Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'velavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg velocity:', 'Avg velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- PIPE
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'flowavg', 'lyt_epa_data_2', 4, 'string', 'text', 'Avg flow:', 'Avg Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'velavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg velocity:', 'Avg velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- SHORTPIPE
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'flowavg', 'lyt_epa_data_2', 4, 'string', 'text', 'Avg flow:', 'Avg Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'velavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg velocity:', 'Avg velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- TANK
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'headmax', 'lyt_epa_data_2', 5, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'headmin', 'lyt_epa_data_2', 6, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'headavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg head:', 'Avg demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- RESERVOIR
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'headmax', 'lyt_epa_data_2', 5, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'headmin', 'lyt_epa_data_2', 6, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'headavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg head:', 'Avg demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- VALVE
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'flowavg', 'lyt_epa_data_2', 4, 'string', 'text', 'Avg flow:', 'Avg Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'velavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg velocity:', 'Avg velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- VIRTUALVALVE
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'flowavg', 'lyt_epa_data_2', 4, 'string', 'text', 'Avg flow:', 'Avg Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'velavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg velocity:', 'Avg velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- INLET
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'headmax', 'lyt_epa_data_2', 5, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'headmin', 'lyt_epa_data_2', 6, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'headavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg head:', 'Avg demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

-- CONNEC
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'headmax', 'lyt_epa_data_2', 5, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'headmin', 'lyt_epa_data_2', 6, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'headavg', 'lyt_epa_data_2', 7, 'string', 'text', 'Avg head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);



--UD
-- CONDUIT
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_shear', 'lyt_epa_data_2', 7, 'string', 'text', 'max_shear:', 'max_shear', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_hr', 'lyt_epa_data_2', 8, 'string', 'text', 'max_hr:', 'max_hr', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_slope', 'lyt_epa_data_2', 9, 'string', 'text', 'max_slope:', 'max_slope', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'day_max', 'lyt_epa_data_2', 10, 'string', 'text', 'day_max:', 'day_max', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_max', 'lyt_epa_data_2', 11, 'string', 'text', 'time_max:', 'time_max', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'min_shear', 'lyt_epa_data_2', 12, 'string', 'text', 'min_shear:', 'min_shear', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'day_min', 'lyt_epa_data_2', 13, 'string', 'text', 'day_min:', 'day_min', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_min', 'lyt_epa_data_2', 14, 'string', 'text', 'time_min:', 'time_min', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
