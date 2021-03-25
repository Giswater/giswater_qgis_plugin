INSERT INTO ws_sample35.config_typevalue VALUES('tabname_typevalue', 'tab_rpt', 'tab_rpt','tabRpt');
INSERT INTO ws_sample35.config_form_tabs VALUES ('v_edit_arc','tab_rpt','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1);
INSERT INTO ws_sample35.config_typevalue VALUES('widgettype_typevalue', 'tableview', 'tableview','tableview');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_1', 'lyt_rpt_1','lytRpt1');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_2', 'lyt_rpt_2','lytRpt2');
INSERT INTO ws_sample35.config_typevalue VALUES('layout_name_typevalue', 'lyt_rpt_3', 'lyt_rpt_3','lytRpt3');
INSERT INTO ws_sample35.config_typevalue VALUES('widgetfunction_typevalue', 'open_rpt_result', 'open_rpt_result','openRptResult');


ALTER TABLE ws_sample35.config_form_list ADD COLUMN columnname varchar(30);
UPDATE ws_sample35.config_form_list SET columnname = 'bmaps_column';
ALTER TABLE ws_sample35.config_form_list DROP CONSTRAINT config_form_list_pkey;
ALTER TABLE ws_sample35.config_form_list ADD CONSTRAINT "config_form_list_pkey" PRIMARY KEY ("tablename", "device", "listtype", "columnname");
ALTER TABLE config_form_list DROP COLUMN actionfields;

ALTER TABLE ws_sample35.config_form_fields ADD COLUMN isfilter boolean;
ALTER TABLE ws_sample35.config_form_fields ADD COLUMN tabname varchar(30);
UPDATE ws_sample35.config_form_fields SET tabname = 'main';
UPDATE ws_sample35.config_form_fields set tabname = 'data' WHERE formtype = 'form_feature' AND formname ILIKE 've_%_%';
ALTER TABLE ws_sample35.config_form_fields DROP CONSTRAINT config_form_fields_pkey;
ADD CONSTRAINT config_form_fields_pkey PRIMARY KEY(formname, formtype, columnname, tabname);

INSERT INTO ws_sample35.config_form_list(tablename, query_text, device, actionfields, listtype, listclass, vdefault, columnname)
    VALUES ('ve_arc_pipe', 'SELECT * FROM ve_arc_pipe WHERE arc_id IS NOT NULL', 4, NULL, 'tab', 'tableview', '{"orderBy":"1", "orderType": "DESC"}', 'tbl_rpt');

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetfunction, layoutname, tabname, isfilter)
				VALUES ('ve_arc_pipe', 'form_feature', 'expl_id', 1, 'string', 'combo',  'Expl id', false, false, True, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL AND active IS TRUE ', 'open_rpt_result', 'lyt_rpt_2', 'tab_rpt', True);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, columnname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetfunction, layoutname, tabname, isfilter)
				VALUES 	   ('ve_arc_pipe', 'form_feature', 'tbl_rpt', 1, 'tableview', false, false, false, false, 'open_rpt_result', 'lyt_rpt_3', 'tab_rpt', False);




