/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_doc', 'SELECT * FROM v_ui_doc WHERE id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','id',6,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
    VALUES ('edit toolbar','utils','v_ui_doc','name',0,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','observ',1,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','doc_type',2,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','path',3,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','date',4,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','user_name',5,true);


UPDATE config_form_tabs
    SET orderby=0
    WHERE formname IN ('v_edit_arc', 'v_edit_connec', 'v_edit_node', 'v_edit_gully') AND tabname='tab_data';

UPDATE config_form_tabs
    SET orderby=1
    WHERE tabname='tab_epa';


UPDATE config_form_tabs
	SET "label"='Elements' WHERE tabname='tab_elements';
UPDATE config_form_tabs
	SET "label"='Events' WHERE tabname='tab_event';
UPDATE config_form_tabs
	SET "label"='Documents' WHERE tabname='tab_documents';
UPDATE config_form_tabs
	SET "label"='Plan' WHERE tabname='tab_plan';
UPDATE config_form_tabs
	SET "label"='Hydrometer' WHERE tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET "label"='Hydrometer consumptions' WHERE tabname='tab_hydrometer_val';

UPDATE doc SET name = id WHERE name IS NULL;


-- 26/07/2024
UPDATE config_form_tableview
	SET columnindex=0
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='result_id';
UPDATE config_form_tableview
	SET columnindex=1
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='cur_user';
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','expl_id',2,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','sector_id',3,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','network_type',4,true);
UPDATE config_form_tableview
	SET columnindex=5
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='exec_date';
UPDATE config_form_tableview
	SET columnindex=6
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='status';
UPDATE config_form_tableview
	SET columnindex=7
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='iscorporate';
UPDATE config_form_tableview
	SET columnindex=8
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='export_options';
UPDATE config_form_tableview
	SET columnindex=9
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='network_stats';
UPDATE config_form_tableview
	SET columnindex=10
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='inp_options';
UPDATE config_form_tableview
	SET columnindex=11
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='rpt_stats';
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','addparam',12,false);
