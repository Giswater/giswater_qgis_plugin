/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- inserts on config_web_layer
INSERT INTO config_web_layer VALUES ('v_edit_plan_psector', false, NULL, false, 'v_edit_plan_psector', 'F11', 'Psector', 5, NULL);
INSERT INTO config_web_layer VALUES ('v_edit_node', true, 'v_web_parent_node', false, NULL, 'F11', 'Node', 2, 'link');
INSERT INTO config_web_layer VALUES ('v_ui_element', false, NULL, false, 'v_ui_element', 'F11', 'Element', 99, 'link');
INSERT INTO config_web_layer VALUES ('v_ui_workcat_polygon', false, NULL, false, 'v_ui_workcat_polygon', 'F14', 'Workcat', 6, NULL);
INSERT INTO config_web_layer VALUES ('v_edit_man_junction', false, NULL, true, NULL, 'F11', 'Node', NULL, NULL);
INSERT INTO config_web_layer VALUES ('v_edit_man_pipe', false, NULL, true, NULL, 'F13', 'Pipe', NULL, NULL);
INSERT INTO config_web_layer VALUES ('v_edit_man_wjoin', false, NULL, true, NULL, 'F14', 'Wjoin', NULL, NULL);
INSERT INTO config_web_layer VALUES ('v_edit_arc', true, 'v_web_parent_arc', false, NULL, 'F13', 'Arc', 3, 'link');
INSERT INTO config_web_layer VALUES ('v_ui_hydrometer', false, NULL, false, 'v_ui_hydrometer', 'F11', 'Hydrometer', 99, 'hydrometer_link');


INSERT INTO config_web_tabs VALUES (242, 'v_edit_connec', 'tabElement', 'Element', 'Llistat d''elements');
INSERT INTO config_web_tabs VALUES (245, 'v_edit_connec', 'tabVisit', 'Visit', 'Històric d''events');
INSERT INTO config_web_tabs VALUES (246, 'v_edit_connec', 'tabDoc', 'Doc', 'Documents associats');


INSERT INTO config_web_tabs VALUES (212, 'v_edit_node', 'tabElement', 'Element', 'Llistat d''elements');
INSERT INTO config_web_tabs VALUES (214, 'v_edit_node', 'tabConnect', 'Connect', '{"node", "Trams aigües amunt", "Trams aigües avall"}');
INSERT INTO config_web_tabs VALUES (215, 'v_edit_node', 'tabVisit', 'Visit', 'Històric d''events');
INSERT INTO config_web_tabs VALUES (252, 'sector', 'tabElement', 'Elements', 'Llistat de elements que pertanyen al sector');
INSERT INTO config_web_tabs VALUES (234, 'v_edit_connec', 'tabHydro', 'Abonat', 'Llista abonats');
INSERT INTO config_web_tabs VALUES (106, 'F31', 'tabPsector', 'Psector', 'Sectors de planejament');
INSERT INTO config_web_tabs VALUES (105, 'F31', 'tabWorkcat', 'Expedient', 'Expedients');
INSERT INTO config_web_tabs VALUES (104, 'F31', 'tabHydro', 'Abonat', 'Abonat');
INSERT INTO config_web_tabs VALUES (103, 'F31', 'tabSearch', 'Cercador', 'Cercador generic');
INSERT INTO config_web_tabs VALUES (272, 'v_ui_workcat_polygon', 'tabElement', 'Servei', 'Elements en servei');
INSERT INTO config_web_tabs VALUES (244, 'v_ui_workcat_polygon', 'tabHydro', 'Baixa', 'Elements donats de baixa');
INSERT INTO config_web_tabs VALUES (114, 'F33', 'tabNetworkState', 'Elements xarxa', 'Elements de xarxa');
INSERT INTO config_web_tabs VALUES (111, 'F33', 'tabExploitation', 'Explotacions', 'Explotacions actives');
INSERT INTO config_web_tabs VALUES (118, 'F33', 'tabHydroState', 'Abonats', 'Abonats');
INSERT INTO config_web_tabs VALUES (206, 'v_edit_node', 'tabDoc', 'Doc', 'Documents associats');
INSERT INTO config_web_tabs VALUES (232, 'v_edit_connec', 'tabElement', 'Element', 'Llistat d''elements');
INSERT INTO config_web_tabs VALUES (235, 'v_edit_connec', 'tabVisit', 'Visit', 'Històric d''events');
INSERT INTO config_web_tabs VALUES (236, 'v_edit_connec', 'tabDoc', 'Doc', 'Documents associats');
INSERT INTO config_web_tabs VALUES (222, 'v_edit_arc', 'tabElement', 'Obra', 'Obra relacionada');
INSERT INTO config_web_tabs VALUES (223, 'v_edit_arc', 'tabHydro', 'Elements', 'Elements relacionats');
INSERT INTO config_web_tabs VALUES (224, 'v_edit_arc', 'tabConnect', 'Connect', 'Connect');
INSERT INTO config_web_tabs VALUES (225, 'v_edit_arc', 'tabVisit', 'Visit', 'Històric d''events');
INSERT INTO config_web_tabs VALUES (101, 'F31', 'tabNetwork', 'Xarxa', 'Elements de xarxa');
INSERT INTO config_web_tabs VALUES (102, 'F31', 'tabAddress', 'Carrerer', 'Carrerer dades PG');


--inserts on config_web_layer_child (dinamyc insert)
INSERT INTO config_web_layer_child
SELECT cat_feature.id, tablename FROM ud.cat_feature JOIN ud.sys_feature_cat ON system_id=sys_feature_cat.id;


--inserts on config_web_tableinfo_x_inforole (dinamyc insert)
insert into ud.config_web_tableinfo_x_inforole (tableinfo_id, inforole_id,tableinforole_id)
select tableinfo_id, 100, tableinfo_id  FROM ud.config_web_layer where tableinfo_id is not null ;

insert into ud.config_web_tableinfo_x_inforole (tableinfo_id, inforole_id,tableinforole_id)
select tableinfo_id, 100, tableinfo_id  FROM ud.config_web_layer_child;


