/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- inserts on config_web_layer
INSERT INTO config_web_layer VALUES ('v_edit_arc', 'arc', true, 'v_web_parent_arc', false, 'v_edit_arc', 'F13', 'Arc', 2, link);
INSERT INTO config_web_layer VALUES ('v_edit_connec', 'connec', true, 'v_web_parent_connec', false, 'v_edit_connec', 'F14', 'Connec', 3, link);
INSERT INTO config_web_layer VALUES ('v_edit_node', 'node', true, 'v_web_parent_node', false, 'v_edit_node', 'F11', 'Node', 1, link);

INSERT INTO config_web_layer VALUES ('v_edit_man_pipe', 'arc', false, null, true, null, 'F13', 'Pipe', 4, link);
INSERT INTO config_web_layer VALUES ('v_edit_man_wjoin', 'connec', false, null, true, null, 'F14', 'Wjoin', 5, link);
INSERT INTO config_web_layer VALUES ('v_edit_man_junction', 'node', false, null, true, null, 'F11', 'junction', 6, link);




-- inserts on config_web_layer_tab
INSERT INTO config_web_layer_tab VALUES (104, 'v_edit_node', 'tabElement');
INSERT INTO config_web_layer_tab VALUES (105, 'v_edit_node', 'tabConnect');
INSERT INTO config_web_layer_tab VALUES (106, 'v_edit_node', 'tabVisit');
INSERT INTO config_web_layer_tab VALUES (107, 'v_edit_node', 'tabDoc');

INSERT INTO config_web_layer_tab VALUES (100, 'v_edit_arc', 'tabElement');
INSERT INTO config_web_layer_tab VALUES (101, 'v_edit_arc', 'tabConnect');
INSERT INTO config_web_layer_tab VALUES (102, 'v_edit_arc', 'tabVisit');
INSERT INTO config_web_layer_tab VALUES (103, 'v_edit_arc', 'tabDoc');

INSERT INTO config_web_layer_tab VALUES (108, 'v_edit_connec', 'tabElement');
INSERT INTO config_web_layer_tab VALUES (109, 'v_edit_connec', 'tabHydro');
INSERT INTO config_web_layer_tab VALUES (110, 'v_edit_connec', 'tabMincut');
INSERT INTO config_web_layer_tab VALUES (111, 'v_edit_connec', 'tabVisit');
INSERT INTO config_web_layer_tab VALUES (112, 'v_edit_connec', 'tabDoc');

INSERT INTO config_web_layer_tab VALUES (113, 'v_edit_gully', 'tabElement');
INSERT INTO config_web_layer_tab VALUES (114, 'v_edit_gully', 'tabVisit');
INSERT INTO config_web_layer_tab VALUES (115, 'v_edit_gully', 'tabDoc');


--inserts on config_web_layer_child (dinamyc insert)
INSERT INTO config_web_layer_child
SELECT cat_feature.id, tablename FROM SCHEMA_NAME.cat_feature JOIN SCHEMA_NAME.sys_feature_cat ON system_id=sys_feature_cat.id


--inserts on config_web_tableinfo_x_inforole (dinamyc insert)
insert into SCHEMA_NAME.config_web_tableinfo_x_inforole (tableinfo_id, inforole_id,tableinforole_id)
select tableinfo_id, 1, tableinfo_id  FROM SCHEMA_NAME.config_web_layer 

insert into SCHEMA_NAME.config_web_tableinfo_x_inforole (tableinfo_id, inforole_id,tableinforole_id)
select tableinfo_id, 1, tableinfo_id  FROM SCHEMA_NAME.config_web_layer_child 


