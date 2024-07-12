/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_doc', 'SELECT * FROM v_ui_doc WHERE id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','id',0,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','doc_type',2,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','path',3,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','observ',1,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','date',4,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','user_name',5,true);


UPDATE config_form_tabs
    SET orderby=0
    WHERE formname IN ('v_edit_arc', 'v_edit_connec', 'v_edit_node', 'v_edit_gully') AND tabname='tab_data';

UPDATE config_form_tabs
    SET orderby=1
    WHERE formname IN ('v_edit_arc', 'v_edit_node', 've_epa_connec', 've_epa_junction', 've_epa_pump', 've_epa_storage') AND tabname='tab_epa';

UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_arc' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_arc' AND tabname='tab_relations';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_arc' AND tabname='tab_event';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname IN ('v_edit_arc', 'v_edit_connec', 'v_edit_node', 'v_edit_gully') AND tabname='tab_documents';

UPDATE config_form_tabs
    SET orderby=6
    WHERE formname='v_edit_arc' AND tabname='tab_plan';

