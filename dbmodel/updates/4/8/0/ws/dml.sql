/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 02/02/2026
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_connec', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_frpump', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_frshortpipe', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_frvalve', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_pump', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_reservoir', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_tank', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_virtualpump', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_virtualvalve', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;

-- Update weblayoutorder for all fields
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='demand' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='tbl_inp_connec' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='peak_factor' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='emitter_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='power' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='pump_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='energy_price' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='usage_fact' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='energy_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='avg_effic' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='kwhr_mgal' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='effic_curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='avg_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='peak_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='cost_day' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='tbl_inp_shortpipe' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='bulk_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='wall_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='tbl_inp_valve' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='setting' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='uheadloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='uheadloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='add_settings' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='initlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='tbl_inp_inlet' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='minlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='maxlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='diameter' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='minvol' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='overflow' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='mixing_model' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='mixing_fraction' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='reaction_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='head' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demand' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=18
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demand_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=19
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='emitter_coeff' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='demand' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='tbl_inp_junction' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='emitter_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='custom_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='custom_length' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='cat_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='flow_avg' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='vel_avg' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='seetting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=18
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=19
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=20
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=21
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='total_headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=22
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='total_headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=23
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=24
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=25
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tbl_inp_pipe' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='cat_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='custom_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reactionparam' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reactionvalue' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='bulk_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='wall_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=18
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=19
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=20
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=21
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tot_headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=22
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tot_headloss_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='power' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='pump_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='usage_fact' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='energy_price' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='energy_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='avg_effic' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='effic_curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='kwhr_mgal' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='avg_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='peak_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='cost_day' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='tbl_inp_reservoir' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='head' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='nodarc_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='tbl_inp_shortpipe' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='bulk_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='wall_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='initlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='tbl_inp_tank' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='minlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='maxlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='diameter' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='minvol' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='headavg' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='overflow' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='mixing_model' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='mixing_fraction' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='reaction_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='nodarc_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='tbl_inp_valve' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='setting' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='uheadloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='uheadloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='add_settings' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='power' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='tbl_inp_virtualpump' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='usage_fact' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='pump_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='hspacer_lyt_epa' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='effic_curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='avg_effic' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='energy_price' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='kwhr_mgal' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='energy_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='avg_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='peak_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='cost_day' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='tbl_inp_virtualvalve' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='nodarc_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='setting' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='diameter' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='uheadloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='uheadloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';