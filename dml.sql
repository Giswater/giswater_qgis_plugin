INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'hspacer', 'hspacer','hSpacer');
INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'tableview', 'tableview','tableview');




-- TAB CONNECTIONS
-- TAB HYDROMETER
-- TAB HYDROMETER VALUES
-- TAB VISIT
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_visits_1', 'lyt_visits_1','lytVisits1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_visits_2', 'lyt_visits_2','lytVisits2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_visits_3', 'lyt_visits_3','lytVisits3');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'visit', 'date_visit_from', 'lyt_visits_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true,  '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'visit', 'date_visit_to', 'lyt_visits_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'visit', 'visit_class', 'lyt_visits_1', 3, 'string', 'combo',  'Visit class:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_class WHERE feature_type IN (''ARC'',''ALL'') ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_arc_pipe', 'form_feature', 'visit', 'hspacer_lyt_document_1', 'lyt_visits_2', 1, 'hspacer', false, false, true, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'visit', 'open_gallery', 'lyt_visits_2', 2, 'button', 'Open gallery', false, false, true, false,  '{"icon":"136"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_visit", "parameters":{"sourcewidget":"visit_id", "targetwidget":"tbl_visits", "sourceview":"visit"}}', false, 'tbl_visit_x_arc');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'visit', 'tbl_visits', 'lyt_visits_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}', 'tbl_visit_x_arc');


-- TAB EVENT
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_event_1', 'lyt_event_1','lytEvents1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_event_2', 'lyt_event_2','lytEvents2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_event_3', 'lyt_event_3','lytEvents3');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'event', 'date_from', 'lyt_event_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true,  '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'event', 'date_to', 'lyt_event_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'event', 'parameter_type', 'lyt_event_1', 3, 'string', 'combo',  'Parameter type:', false, false, true, false, true, 'SELECT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''ARC'', ''ALL'') ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'event', 'parameter_id', 'lyt_event_1', 4, 'string', 'combo',  'Parameter:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''ARC'', ''ALL'') ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc');


-- TAB PLAN
-- TAB DOCUMENTS
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_document_1', 'lyt_document_1','lytDocuments1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_document_2', 'lyt_document_2','lytDocuments2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_document_3', 'lyt_document_3','lytDocuments3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_doc_x_arc', 'SELECT id as sys_id, * FROM v_ui_doc_x_arc WHERE id IS NOT NULL', 4);
delete from ws_sample35.config_form_fields where layoutname ilike '%document%';
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'tbl_documents', 'lyt_document_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'hspacer_lyt_document_1', 'lyt_document_2', 10, 'hspacer', false, false, true, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'doc_id', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', false, false, true, false, 'SELECT id as id, id as idval FROM doc WHERE id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'insert_document', 'lyt_document_2', 2, 'button', 'Insert document', false, false, true, false,  '{"icon":"111"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"doc_id", "targetwidget":"tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'delete_element', 'lyt_document_2', 3, 'button', 'Delete document', false, false, true, false,  '{"icon":"112"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'new_element', 'lyt_document_2', 4, 'button', 'New document', false, false, true, false,  '{"icon":"131"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_document", "parameters":{"sourcewidget":"doc_id", "targetwidget":"tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');


INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'date_from', 'lyt_document_1', 1, 'date', 'datetime',  'Date from:', false, false, true, false, true,  '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'date_to', 'lyt_document_1', 2, 'date', 'datetime',  'Date to:', false, false, true, false, true, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'document', 'doc_type', 'lyt_document_1', 3, 'string', 'combo',  'Doc type:', false, false, true, false, true, 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc');




-- TAB ELEMENTS
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_element_1', 'lyt_element_1','lytElements1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_element_2', 'lyt_element_2','lytElements2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_element_3', 'lyt_element_3','lytElements3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_element_x_arc', 'SELECT id as sys_id, * FROM v_ui_element_x_arc WHERE id IS NOT NULL', 4);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'element', 'tbl_elements', 'lyt_element_2', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_element", "parameters":{"columnfind":"element_id"}}', 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_arc_pipe', 'form_feature', 'element', 'hspacer_lyt_element', 'lyt_element_1', 10, 'hspacer', false, false, true, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'element', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', false, false, true, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'element', 'insert_element', 'lyt_element_1', 2, 'button', 'Insert element', false, false, true, false,  '{"icon":"111"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"element_id", "targetwidget":"tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'element', 'delete_element', 'lyt_element_1', 3, 'button', 'Delete element', false, false, true, false,  '{"icon":"112"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'element', 'new_element', 'lyt_element_1', 4, 'button', 'New element', false, false, true, false,  '{"icon":"131"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_element", "parameters":{"sourcewidget":"element_id", "targetwidget":"tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');


-- TAB REALATIONS
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relations_1', 'lyt_relations_1','lytRelations1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relations_2', 'lyt_relations_2','lytRelations2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_relations_3', 'lyt_relations_3','lytRelations3');
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_relations', 'SELECT rid as sys_id, * FROM v_ui_arc_x_relations WHERE rid IS NOT NULL', 4);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_arc_pipe', 'form_feature', 'tab_relations', 'tbl_relations', 'lyt_relations_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}','{"functionName": "open_selected_feature", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', false, 'tbl_relations');


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
    VALUES ('ve_arc_pipe', 'form_feature', 'rpt', 'tbl_rpt', 1, 'tableview', false, false, false, false, '{"saveValue": false}','{"functionName": "open_rpt_result", "parameters":{"columname":"arc_id"}}', 'lyt_rpt_3', false, 'tbl_rpt');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'expl_id', 1, 'string', 'combo',  'Expl id', false, false, true, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL AND active IS TRUE ', True, '{"functionName": "_filter_table", "parameters":{}}', 'lyt_rpt_2', 'rpt', True);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'arc_id', 2, 'string', 'text', false, false, true, false, '{"functionName": "_filter_table", "parameters":{}}', 'lyt_rpt_2', 'rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetfunction, layoutname, tabname, isfilter)
    VALUES ('ve_arc_pipe', 'form_feature', 'arccat_id', 3, 'string', 'typeahead', 'Arc cat', false, false, true, false, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL AND active IS TRUE ', '{"functionName": "_filter_table", "parameters":{}}', 'lyt_rpt_2', 'rpt', true);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, layoutname, tabname)
    VALUES ('ve_arc_pipe', 'form_feature', 'hspacer_lyt_rpt_2', 4, 'hspacer', false, false, true, false, 'lyt_rpt_2', 'rpt');