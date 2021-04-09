
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_elements_1', 'lyt_elements_1','lytElements1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_elements_2', 'lyt_elements_2','lytElements2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_elements_3', 'lyt_elements_3','lytElements3');
INSERT INTO ws_sample35.config_typevalue VALUES('widgetfunction_typevalue', '_open_selected_element', '_open_selected_element','openSelectedElement');
INSERT INTO ws_sample35.config_typevalue VALUES('widgetfunction_typevalue', '_filter_table', '_filter_table','filterTable');
INSERT INTO ws_sample35.config_typevalue VALUES('widgetfunction_typevalue', '_add_object', '_add_object','addObject');

INSERT INTO ws_sample35.config_form_list(tablename, query_text, device, listtype, listclass, vdefault, columnname)
    VALUES ('ve_arc_pipe', 'SELECT * FROM v_ui_element_x_arc WHERE element_id IS NOT NULL', 4, 'attributeTable', 'tableview', '{"orderBy":"1", "orderType": "DESC"}', 'tbl_elements');


INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, layoutname, widgetcontrols, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'element_id', 1, 'string', 'typeahead', 'Element id', false, false, true, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', 'lyt_elements_1', '{"accept":false}', 'tab_elements', false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, stylesheet, layoutname, widgetcontrols, tabname, isfilter)
VALUES ('ve_arc_pipe', 'form_feature', 'insert_element', 2, 'button', 'Insert element', false, false, true, false, '_add_object', '{"icon":"111"}', 'lyt_elements_1', '{"saveValue":false}', 'tab_elements', false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, layoutname, tabname)
    VALUES ('ve_arc_pipe', 'form_feature', 'hspacer_lyt_elements_2', 4, 'hspacer', false, false, true, false, 'lyt_elements_1', 'tab_elements');



INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'tbl_elements', 1, 'tableview', false, false, false, false, '_open_selected_element', 'lyt_elements_3', 'tab_elements', false);


/***********************************************************************/
INSERT INTO ws_sample35.config_typevalue VALUES('tabname_typevalue', 'tab_rpt', 'tab_rpt','tabRpt');
INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'tableview', 'tableview','tableview');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_1', 'lyt_rpt_1','lytRpt1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_2', 'lyt_rpt_2','lytRpt2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_3', 'lyt_rpt_3','lytRpt3');
INSERT INTO ws_sample35.config_typevalue VALUES('widgetfunction_typevalue', 'open_rpt_result', 'open_rpt_result','openRptResult');
INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'hspacer', 'hspacer','hSpacer');

INSERT INTO ws_sample35.config_form_tabs VALUES ('v_edit_arc','tab_rpt','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1);



INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'expl_id', 1, 'string', 'combo',  'Expl id', false, false, true, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL AND active IS TRUE ', True, '_filter_table', 'lyt_rpt_2', 'tab_rpt', True);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'arc_id', 2, 'string', 'text', false, false, true, false, '_filter_table', 'lyt_rpt_2', 'tab_rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'arccat_id', 3, 'string', 'typeahead', 'Arc cat', false, false, true, false, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL AND active IS TRUE ', '_filter_table', 'lyt_rpt_2', 'tab_rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, layoutname, tabname)
    VALUES ('ve_arc_pipe', 'form_feature', 'hspacer_lyt_rpt_2', 4, 'hspacer', false, false, true, false, 'lyt_rpt_2', 'tab_rpt');



INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'tbl_rpt', 1, 'tableview', false, false, false, false, 'open_rpt_result', 'lyt_rpt_3', 'tab_rpt', false);




