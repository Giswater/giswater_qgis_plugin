INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'hspacer', 'hspacer','hSpacer');
INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'vspacer', 'vspacer','vSpacer');
INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'tableview', 'tableview','tableview');



-- TAB EPA
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_1', 'lyt_epa_1','lytEpa1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_data_1', 'lyt_epa_data_1','lytEpaData1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_data_2', 'lyt_epa_data_2','lytEpaData2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_3', 'lyt_epa_3','lytEpa3');

-- JUNCTION
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_junction', 'SELECT dscenario_id, demand, pattern_id FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL', 4); -- SELECT dscenario_id, demand, pattern_id, emitter_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_junction WHERE node_id IS NOT NULL

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', NULL, false, '');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'demand', 'lyt_epa_data_1', 1, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Pattern id:', 'Pattern id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'emitter_coeff', 'lyt_epa_data_1', 3, 'string', 'text', 'Emitter coefficient:', 'Emitter coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'initial_quality', 'lyt_epa_data_1', 4, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 5, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 6, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 7, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'total_head', 'lyt_epa_data_2', 2, 'string', 'text', 'Total head:', 'Total head', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 3, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 4, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'tbl_inp_junction', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_junction');


-- PUMP
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_pump', 'SELECT dscenario_id, power, curve_id, speed, pattern, status, pump_type, energy_price, price_pattern FROM ve_inp_dscenario_pump WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'power', 'lyt_epa_data_1', 1, 'string', 'text', 'Power:', 'Power', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'speed', 'lyt_epa_data_1', 3, 'string', 'text', 'Speed:', 'Speed', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'pattern', 'lyt_epa_data_1', 4, 'string', 'text', 'Pattern:', 'Pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 5, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 6, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'pump_type', 'lyt_epa_data_1', 7, 'string', 'text', 'Pump type:', 'Pump type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'energy_price', 'lyt_epa_data_1', 8, 'string', 'text', 'Energy price:', 'Energy price', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'price_pattern', 'lyt_epa_data_1', 9, 'string', 'text', 'Price pattern:', 'Price pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'headloss', 'lyt_epa_data_2', 3, 'string', 'text', 'Headloss:', 'Headloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 4, 'string', 'text', 'Quality:', 'Quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'status', 'lyt_epa_data_2', 5, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'usage_fact', 'lyt_epa_data_2', 6, 'string', 'text', 'Usage factor:', 'Usage factor', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_effic', 'lyt_epa_data_2', 7, 'string', 'text', 'Average efficiency:', 'Average efficiency', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'kwhr_mgal', 'lyt_epa_data_2', 8, 'string', 'text', 'KWh mgal?:', 'KWh mgal?', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_kw', 'lyt_epa_data_2', 9, 'string', 'text', 'Average KW:', 'Average KW', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'peak_kw', 'lyt_epa_data_2', 10, 'string', 'text', 'Peak KW:', 'Peak KW', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'cost_day', 'lyt_epa_data_2', 11, 'string', 'text', 'Cost day:', 'Cost day', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'tbl_inp_pump', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_pump');


-- PIPE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_pipe', 'SELECT dscenario_id, minorloss, status, buk_coeff, wall_coeff FROM ve_inp_dscenario_pipe WHERE arc_id IS NOT NULL', 4); -- 

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 1, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 2, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'buk_coeff', 'lyt_epa_data_1', 3, 'string', 'text', 'Buk coefficient:', 'Buk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 4, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Flow:', 'Flow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'velocity', 'lyt_epa_data_2', 3, 'string', 'text', 'Velocity:', 'Velocity', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'unit_headloss', 'lyt_epa_data_2', 4, 'string', 'text', 'Unit headloss:', 'Unit headloss', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'friction_factor', 'lyt_epa_data_2', 5, 'string', 'text', 'Friction factor:', 'Friction factor', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'reaction_rate', 'lyt_epa_data_2', 6, 'string', 'text', 'Reaction rate:', 'Reaction rate', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 7, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_2', 8, 'string', 'text', 'Status:', 'Status', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'tbl_inp_pipe', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_pipe');


-- SHORTPIPE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_shortpipe', 'SELECT dscenario_id, minorloss, to_arc, status, buk_coeff, wall_coeff FROM ve_inp_dscenario_shortpipe WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 2, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 3, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 4, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'buk_coeff', 'lyt_epa_data_1', 5, 'string', 'text', 'Buk coefficient:', 'Buk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 6, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Flow:', 'Flow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'velocity', 'lyt_epa_data_2', 3, 'string', 'text', 'Velocity:', 'Velocity', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'unit_headloss', 'lyt_epa_data_2', 4, 'string', 'text', 'Unit headloss:', 'Unit headloss', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'friction_factor', 'lyt_epa_data_2', 5, 'string', 'text', 'Friction factor:', 'Friction factor', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'reaction_rate', 'lyt_epa_data_2', 6, 'string', 'text', 'Reaction rate:', 'Reaction rate', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 7, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_2', 8, 'string', 'text', 'Status:', 'Status', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'tbl_inp_shortpipe', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_shortpipe');


-- TANK
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_tank', 'SELECT dscenario_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, mixing_model, bulk_coeff, wall_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_tank WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'initlevel', 'lyt_epa_data_1', 1, 'string', 'text', 'Init level:', 'Initial level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'minlevel', 'lyt_epa_data_1', 2, 'string', 'text', 'Min level:', 'Minimum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'maxlevel', 'lyt_epa_data_1', 3, 'string', 'text', 'Max level:', 'Maximum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'diameter', 'lyt_epa_data_1', 4, 'string', 'text', 'Diameter:', 'Diameter', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'minvol', 'lyt_epa_data_1', 5, 'string', 'text', 'Min volume:', 'Minimum volume', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'mixing_model', 'lyt_epa_data_1', 7, 'string', 'text', 'Mixing model:', 'Mixing model', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'bulk_coeff', 'lyt_epa_data_1', 8, 'string', 'text', 'Bulk coefficient:', 'Bulk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 9, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 10, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 11, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 13, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'tbl_inp_tank', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_tank');


-- RESERVOIR
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_reservoir', 'SELECT dscenario_id, head, pattern, initial_quality, source_type, source_quality_source_pattern FROM ve_inp_dscenario_reservoir WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'head', 'lyt_epa_data_1', 1, 'string', 'text', 'Head:', 'Head', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'pattern', 'lyt_epa_data_1', 2, 'string', 'text', 'Pattern:', 'Pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'initial_quality', 'lyt_epa_data_1', 3, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 4, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 5, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 6, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'tbl_inp_reservoir', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_reservoir');


-- VALVE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_valve', 'SELECT dscenario_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, to_arc, status, custom_dint, add_settings, quality FROM ve_inp_dscenario_valve WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'valv_type', 'lyt_epa_data_1', 2, 'string', 'text', 'Valve type:', 'Valve type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_1', 3, 'string', 'text', 'Pressure:', 'Pressure', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'flow', 'lyt_epa_data_1', 4, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'coef_loss', 'lyt_epa_data_1', 5, 'string', 'text', 'Coefficient loss:', 'Coefficient loss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 7, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 8, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 9, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'custom_dint', 'lyt_epa_data_1', 10, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'add_settings', 'lyt_epa_data_1', 11, 'string', 'text', 'Add settings:', 'Add settings', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Quality:', 'Quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'tbl_inp_valve', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_valve');


-- VIRTUALVALVE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_virtualvalve', 'SELECT dscenario_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, to_arc, status, custom_dint, add_settings, quality, status FROM ve_inp_dscenario_virtualvalve WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'valv_type', 'lyt_epa_data_1', 1, 'string', 'text', 'Valve type:', 'Valve type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_1', 2, 'string', 'text', 'Pressure:', 'Pressure', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'flow', 'lyt_epa_data_1', 3, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'coef_loss', 'lyt_epa_data_1', 4, 'string', 'text', 'Coefficient loss:', 'Coefficient loss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 5, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 6, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 7, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 8, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'custom_dint', 'lyt_epa_data_1', 9, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'add_settings', 'lyt_epa_data_1', 10, 'string', 'text', 'Add settings:', 'Add settings', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_1', 11, 'string', 'text', 'Quality:', 'Quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 2, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 3, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 4, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 5, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 6, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'tbl_inp_virtualvalve', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_virtualvalve');


-- INLET
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_inlet', 'SELECT dscenario_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, pattern_id, head, mixing_model, bulk_coeff, wall_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_inlet WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'initlevel', 'lyt_epa_data_1', 1, 'string', 'text', 'Init level:', 'Initial level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'minlevel', 'lyt_epa_data_1', 2, 'string', 'text', 'Min level:', 'Minimum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'maxlevel', 'lyt_epa_data_1', 3, 'string', 'text', 'Max level:', 'Maximum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'diameter', 'lyt_epa_data_1', 4, 'string', 'text', 'Diameter:', 'Diameter', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'minvol', 'lyt_epa_data_1', 5, 'string', 'text', 'Min volume:', 'Minimum volume', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 7, 'string', 'text', 'Pattern id:', 'Pattern id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'head', 'lyt_epa_data_1', 8, 'string', 'text', 'Head:', 'Head', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'mixing_model', 'lyt_epa_data_1', 9, 'string', 'text', 'Mixing model:', 'Mixing model', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'bulk_coeff', 'lyt_epa_data_1', 10, 'string', 'text', 'Bulk coefficient:', 'Bulk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 11, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 13, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 14, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 15, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'tbl_inp_tank', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_inlet');


--



-- TAB ELEMENTS -- ARC FET
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_element_1', 'lyt_element_1','lytElements1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_element_2', 'lyt_element_2','lytElements2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_element_3', 'lyt_element_3','lytElements3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_element_x_arc', 'SELECT id as sys_id, * FROM v_ui_element_x_arc WHERE id IS NOT NULL', 4);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'element', 'tbl_elements', 'lyt_element_2', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}', 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('arc', 'form_feature', 'element', 'hspacer_lyt_element', 'lyt_element_1', 10, 'hspacer', false, false, true, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('arc', 'form_feature', 'element', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', false, false, true, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'element', 'insert_element', 'lyt_element_1', 3, 'button', 'Insert element', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'element', 'delete_element', 'lyt_element_1', 4, 'button', 'Delete element', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'element', 'new_element', 'lyt_element_1', 5, 'button', 'New element', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_element", "module": "info", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'element', 'open_element', 'lyt_element_1', 11, 'button', 'Open element', false, false, true, false,  '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');




-- TAB REALATIONS -- FET
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relation_1', 'lyt_relation_1','lytRelations1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relation_2', 'lyt_relation_2','lytRelations2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relation_3', 'lyt_relation_3','lytRelations3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_relations', 'SELECT rid as sys_id, * FROM v_ui_arc_x_relations WHERE rid IS NOT NULL', 4);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'relation', 'tbl_relations', 'lyt_relation_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}','{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', false, 'tbl_relations');




-- TAB CONNECTIONS -- UD
INSERT INTO ud_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_1', 'lyt_connection_1','lytConnection1');
INSERT INTO ud_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_2', 'lyt_connection_2','lytConnection2');
INSERT INTO ud_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_3', 'lyt_connection_3','lytConnection3');

INSERT INTO ud_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_connection_upstream', 'SELECT * FROM v_ui_node_x_connection_upstream WHERE rid IS NOT NULL', 4);
INSERT INTO ud_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_connection_downstream', 'SELECT * FROM v_ui_node_x_connection_downstream WHERE rid IS NOT NULL', 4);

INSERT INTO ud_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('node', 'form_feature', 'connection', 'tbl_upstream', 'lyt_connection_2', 1, 'tableview', 'Upstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_upstream');
INSERT INTO ud_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('node', 'form_feature', 'connection', 'tbl_downstream', 'lyt_connection_3', 1, 'tableview', 'Downstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_downstream');




-- TAB HYDROMETER
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_1', 'lyt_hydrometer_1','lytHydrometer1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_2', 'lyt_hydrometer_2','lytHydrometer2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_3', 'lyt_hydrometer_3','lytHydrometer3');

INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_hydrometer', 'SELECT * FROM v_ui_hydrometer WHERE hydrometer_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('connec', 'form_feature', 'hydrometer', 'hydrometer_id', 'lyt_hydrometer_1', 1, 'string', 'text', '', 'Hydrometer id', false, false, true, false, '','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table", "parameters": {"columnfind": "hydrometer_customer_code"}}', true, 'v_ui_hydrometer');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('connec', 'form_feature', 'hydrometer', 'hspacer_lyt_hydrometer_1', 'lyt_hydrometer_1', 10, 'hspacer', false, false, true, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('connec', 'form_feature', 'hydrometer', 'btn_link', 'lyt_hydrometer_1', 11, 'button', 'Open link', false, false, true, false,  '{"icon":"70", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_path", "parameters":{"targetwidget":"hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}', false, 'v_ui_hydrometer');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydrometer', 'tbl_hydrometer', 'lyt_hydrometer_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_hydro", "module": "info", "parameters":{}}', 'v_ui_hydrometer');




-- TAB HYDROMETER VALUES
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_1', 'lyt_hydro_val_1','lytHydroVal1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_2', 'lyt_hydro_val_2','lytHydroVal2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_3', 'lyt_hydro_val_3','lytHydroVal3');

INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_hydrometer_value', 'SELECT * FROM v_ui_hydroval_x_connec WHERE hydrometer_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydro_val', 'cat_period_id_filter', 'lyt_hydro_val_1', 0, 'string', 'combo', 'Cat period filter:', false, false, true, false, true, 'SELECT DISTINCT(t1.code) as id, t2.cat_period_id as idval FROM ext_cat_period AS t1 JOIN (SELECT * FROM v_ui_hydroval_x_connec) AS t2 on t1.id = t2.cat_period_id ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_hydrometer_value');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydro_val', 'hyd_customer_code', 'lyt_hydro_val_1', 2, 'string', 'combo', 'Customer code:', false, false, true, false, true, 'SELECT hydrometer_id as id, hydrometer_customer_code as idval FROM v_rtc_hydrometer ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_hydrometer_value');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('connec', 'form_feature', 'hydro_val', 'hspacer_lyt_hydro_val_1', 'lyt_hydro_val_1', 10, 'hspacer', false, false, true, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydro_val', 'tbl_hydrometer_value', 'lyt_hydro_val_3', 1, 'tableview', false, false, true, false, false, '{"saveValue": false}', NULL, 'tbl_hydrometer_value');




-- TAB VISIT
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_visit_1', 'lyt_visit_1','lytVisits1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_visit_2', 'lyt_visit_2','lytVisits2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_visit_3', 'lyt_visit_3','lytVisits3');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'visit', 'date_visit_from', 'lyt_visit_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true,  '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'visit', 'date_visit_to', 'lyt_visit_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'visit', 'visit_class', 'lyt_visit_1', 3, 'string', 'combo',  'Visit class:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_class WHERE feature_type IN (''ARC'',''ALL'') ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('arc', 'form_feature', 'visit', 'hspacer_lyt_document_1', 'lyt_visit_2', 1, 'hspacer', false, false, true, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'visit', 'open_gallery', 'lyt_visit_2', 2, 'button', 'Open gallery', false, false, true, false,  '{"icon":"136b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"visit_tbl_visits"}}', false, 'tbl_visit_x_arc');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'visit', 'tbl_visits', 'lyt_visit_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}', 'tbl_visit_x_arc');




-- TAB EVENT
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_event_1', 'lyt_event_1','lytEvents1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_event_2', 'lyt_event_2','lytEvents2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_event_3', 'lyt_event_3','lytEvents3');

INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_visit_x_arc', 'SELECT * FROM v_ui_event_x_arc WHERE event_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'date_event_from', 'lyt_event_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'date_event_to', 'lyt_event_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'parameter_type', 'lyt_event_1', 3, 'string', 'combo',  'Parameter type:', false, false, true, false, true, 'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''ARC'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'parameter_id', 'lyt_event_1', 4, 'string', 'combo',  'Parameter:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''ARC'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'btn_open_visit', 'lyt_event_2', 1, 'button', 'Open visit', false, false, true, false, '{"icon":"65", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "event_tbl_event_cf", "sourceview": "event"}}', false, 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'btn_new_visit', 'lyt_event_2', 2, 'button', 'New visit', false, false, true, false, '{"icon":"64", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "new_visit", "module": "info", "parameters":{}}', false, 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('arc', 'form_feature', 'event', 'hspacer_event_1', 'lyt_event_2', 10, 'hspacer', false, false, true, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'btn_open_gallery', 'lyt_event_2', 11, 'button', 'Open gallery', false, false, true, false, '{"icon":"136b", "size":"24x24"}', '{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}', false, 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'btn_open_visit_doc', 'lyt_event_2', 12, 'button', 'Open visit document', false, false, true, false, '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind": "visit_id"}}', false, 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'btn_open_visit_event', 'lyt_event_2', 13, 'button', 'Open visit event', false, false, true, false, '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}', false, 'tbl_visit_x_arc');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'event', 'tbl_event_cf', 'lyt_event_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}', 'tbl_visit_x_arc');




-- TAB DOCUMENTS
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_document_1', 'lyt_document_1','lytDocuments1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_document_2', 'lyt_document_2','lytDocuments2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_document_3', 'lyt_document_3','lytDocuments3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_doc_x_arc', 'SELECT id as sys_id, * FROM v_ui_doc_x_arc WHERE id IS NOT NULL', 4);
delete from ws_sample35.config_form_fields where layoutname ilike '%document%';
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'tbl_documents', 'lyt_document_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"targetwidget": "document_tbl_documents", "columnfind":"path"}}', 'tbl_doc_x_arc');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('arc', 'form_feature', 'document', 'doc_id', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', false, false, true, false, 'SELECT id as id, id as idval FROM doc WHERE id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'btn_doc_insert', 'lyt_document_2', 2, 'button', 'Insert document', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'btn_doc_delete', 'lyt_document_2', 3, 'button', 'Delete document', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'btn_doc_new', 'lyt_document_2', 4, 'button', 'New document', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_document", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('arc', 'form_feature', 'document', 'hspacer_document_1', 'lyt_document_2', 10, 'hspacer', false, false, true, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'open_doc', 'lyt_document_2', 11, 'button', 'Open document', false, false, true, false,  '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');


INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'date_from', 'lyt_document_1', 1, 'date', 'datetime',  'Date from:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":">="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'date_to', 'lyt_document_1', 2, 'date', 'datetime',  'Date to:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":"<="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('arc', 'form_feature', 'document', 'doc_type', 'lyt_document_1', 3, 'string', 'combo',  'Doc type:', false, false, true, false, true, '{"labelPosition": "top"}', 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');




-- SET TOP & BOT WIDGETS' LABELS ON-TOP OF THE WIDGET
UPDATE ws_sample35.config_form_fields
SET widgetcontrols = jsonb_set(widgetcontrols::jsonb, '{labelPosition}', '"top"', true)
WHERE formname LIKE 've_%' AND (layoutname LIKE 'lyt_top%' OR layoutname LIKE 'lyt_bot%');








-- TAB RPT
INSERT INTO ws_sample35.config_typevalue VALUES('tabname_typevalue', 'rpt', 'rpt','tabRpt');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_1', 'lyt_rpt_1','lytRpt1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_2', 'lyt_rpt_2','lytRpt2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_3', 'lyt_rpt_3','lytRpt3');

INSERT INTO ws_sample35.config_form_tabs VALUES ('v_edit_arc','rpt','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, layoutname, isfilter, linkedobject)
    VALUES ('arc', 'form_feature', 'rpt', 'tbl_rpt', 1, 'tableview', false, false, false, false, '{"saveValue": false}','{"functionName": "open_rpt_result", "parameters":{"columname":"arc_id"}}', 'lyt_rpt_3', false, 'tbl_rpt');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('arc', 'form_feature', 'expl_id', 1, 'string', 'combo',  'Expl id', false, false, true, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL AND active IS TRUE ', True, '{"functionName": "_filter_table", "parameters":{}}', 'lyt_rpt_2', 'rpt', True);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('arc', 'form_feature', 'arc_id', 2, 'string', 'text', false, false, true, false, '{"functionName": "_filter_table", "parameters":{}}', 'lyt_rpt_2', 'rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('arc', 'form_feature', 'arccat_id', 3, 'string', 'typeahead', 'Arc cat', false, false, true, false, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL AND active IS TRUE ', '{"functionName": "_filter_table", "parameters":{}}', 'lyt_rpt_2', 'rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, layoutname, tabname)
    VALUES ('arc', 'form_feature', 'hspacer_lyt_rpt_2', 4, 'hspacer', false, false, true, false, 'lyt_rpt_2', 'rpt');