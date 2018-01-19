/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



DROP RULE IF EXISTS insert_plan_psector_x_arc ON arc;
CREATE OR REPLACE RULE insert_plan_psector_x_arc AS ON INSERT TO arc WHERE NEW.state=2 DO 
INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable) 
VALUES (new.arc_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()LIMIT 1),1,TRUE);
  

DROP RULE IF EXISTS update_plan_psector_x_arc ON arc;
CREATE OR REPLACE RULE update_plan_psector_x_arc AS ON UPDATE TO arc WHERE NEW.state=2 AND (OLD.state=1 OR OLD.state=1) DO 
INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable) 
VALUES (new.arc_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()LIMIT 1),1,TRUE);


DROP RULE IF EXISTS delete_plan_psector_x_arc ON arc;
CREATE OR REPLACE RULE delete_plan_psector_x_arc AS ON UPDATE TO arc WHERE (NEW.state=1 OR NEW.state=0) AND OLD.state=2 DO 
DELETE FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id;


DROP RULE IF EXISTS insert_plan_psector_x_node ON node;
CREATE OR REPLACE RULE insert_plan_psector_x_node AS ON INSERT TO node WHERE NEW.state=2 DO 
INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable) 
VALUES (new.node_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()LIMIT 1),1,TRUE);
  

DROP RULE IF EXISTS update_plan_psector_x_node ON node;
CREATE OR REPLACE RULE update_plan_psector_x_node AS ON UPDATE TO node WHERE NEW.state=2 AND (OLD.state=1 OR OLD.state=1) DO 
INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable) 
VALUES (new.node_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()LIMIT 1),1,TRUE);


DROP RULE IF EXISTS delete_plan_psector_x_node ON node;
CREATE OR REPLACE RULE delete_plan_psector_x_node AS ON UPDATE TO node WHERE (NEW.state=1 OR NEW.state=0) AND OLD.state=2 DO 
DELETE FROM plan_psector_x_node WHERE node_id=NEW.node_id;


DROP RULE IF EXISTS insert_plan_arc_x_pavement ON arc;
CREATE OR REPLACE RULE insert_plan_arc_x_pavement AS ON INSERT TO arc DO  
INSERT INTO plan_arc_x_pavement (arc_id, pavcat_id, percent) 
VALUES (new.arc_id,  (SELECT value FROM config_param_user WHERE parameter='pavcat_vdefault' and cur_user="current_user"()LIMIT 1), '1'::numeric);