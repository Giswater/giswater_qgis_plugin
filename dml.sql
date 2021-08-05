INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'hspacer', 'hspacer','hSpacer');
INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'tableview', 'tableview','tableview');




-- TAB CONNECTIONS
-- TAB HYDROMETER
-- TAB HYDROMETER VALUES
-- TAB VISIT
-- TAB EVENT


-- TAB PLAN
-- TAB DOCUMENTS
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_documents_1', 'lyt_documents_1','lytDocuments1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_documents_2', 'lyt_documents_2','lytDocuments2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_documents_3', 'lyt_documents_3','lytDocuments3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_doc_x_arc', 'SELECT id as sys_id, * FROM v_ui_doc_x_arc WHERE id IS NOT NULL', 4);
delete from ws_sample35.config_form_fields where layoutname ilike '%document%';
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_documents_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'hspacer_lyt_documents_1', 'lyt_documents_1', 10, 'hspacer', false, false, true, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'doc_id', 'lyt_documents_1', 1, 'string', 'typeahead', 'Doc id:', false, false, true, false, 'SELECT id as id, id as idval FROM doc WHERE id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'insert_document', 'lyt_documents_1', 2, 'button', 'Insert document', false, false, true, false,  '{"icon":"111"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"doc_id", "targetwidget":"tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'delete_element', 'lyt_documents_1', 3, 'button', 'Delete document', false, false, true, false,  '{"icon":"112"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'new_element', 'lyt_documents_1', 4, 'button', 'New document', false, false, true, false,  '{"icon":"131"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_document", "parameters":{"sourcewidget":"doc_id", "targetwidget":"tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'doc_type', 'lyt_documents_2', 1, 'string', 'combo',  'Doc type:', false, false, true, false, true, 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');


INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'date_from', 'lyt_documents_2', 1, 'date', 'datetime',  'Date from:', false, false, true, false, true,  '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_documents', 'date_to', 'lyt_documents_2', 2, 'date', 'datetime',  'Date to:', false, false, true, false, true, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');




-- TAB ELEMENTS
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_elements_1', 'lyt_elements_1','lytElements1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_elements_2', 'lyt_elements_2','lytElements2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_elements_3', 'lyt_elements_3','lytElements3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_element_x_arc', 'SELECT id as sys_id, * FROM v_ui_element_x_arc WHERE id IS NOT NULL', 4);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_elements_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_element", "parameters":{"columnfind":"element_id"}}', 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_elements', 'hspacer_lyt_elements_1', 'lyt_elements_1', 10, 'hspacer', false, false, true, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_elements', 'element_id', 'lyt_elements_1', 1, 'string', 'typeahead', 'Element id:', false, false, true, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_elements', 'insert_element', 'lyt_elements_1', 2, 'button', 'Insert element', false, false, true, false,  '{"icon":"111"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"element_id", "targetwidget":"tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_elements', 'delete_element', 'lyt_elements_1', 3, 'button', 'Delete element', false, false, true, false,  '{"icon":"112"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_elements', 'new_element', 'lyt_elements_1', 4, 'button', 'New element', false, false, true, false,  '{"icon":"131"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_element", "parameters":{"sourcewidget":"element_id", "targetwidget":"tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');


-- TAB REALATIONS
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relations_1', 'lyt_relations_1','lytRelations1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relations_2', 'lyt_relations_2','lytRelations2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relations_3', 'lyt_relations_3','lytRelations3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_relations', 'SELECT rid as sys_id, * FROM v_ui_arc_x_relations WHERE rid IS NOT NULL', 4);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_relations', 'tbl_relations', 'lyt_relations_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}','{"functionName": "open_selected_feature", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', false, 'tbl_relations');


-- TAB RPT
INSERT INTO ws_sample35.config_typevalue VALUES('tabname_typevalue', 'tab_rpt', 'tab_rpt','tabRpt');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_1', 'lyt_rpt_1','lytRpt1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_2', 'lyt_rpt_2','lytRpt2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_3', 'lyt_rpt_3','lytRpt3');

INSERT INTO ws_sample35.config_form_tabs VALUES ('v_edit_arc','tab_rpt','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, layoutname, tabname, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_rpt', 'tbl_rpt', 1, 'tableview', false, false, false, false, '{"saveValue": false}','{"functionName": "open_rpt_result", "parameters":{"columname":"arc_id"}}', 'lyt_rpt_3', 'tab_rpt', false, 'tbl_rpt');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'expl_id', 1, 'string', 'combo',  'Expl id', false, false, true, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL AND active IS TRUE ', True, '_filter_table', 'lyt_rpt_2', 'tab_rpt', True);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'arc_id', 2, 'string', 'text', false, false, true, false, '_filter_table', 'lyt_rpt_2', 'tab_rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'arccat_id', 3, 'string', 'typeahead', 'Arc cat', false, false, true, false, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL AND active IS TRUE ', '_filter_table', 'lyt_rpt_2', 'tab_rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, layoutname, tabname)
    VALUES ('ve_arc_pipe', 'form_feature', 'hspacer_lyt_rpt_2', 4, 'hspacer', false, false, true, false, 'lyt_rpt_2', 'tab_rpt');