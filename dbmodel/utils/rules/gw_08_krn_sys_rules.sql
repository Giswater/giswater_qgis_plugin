	/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP RULE IF EXISTS undelete_exploitation ON exploitation;
CREATE OR REPLACE RULE undelete_dma AS ON DELETE TO exploitation WHERE old.undelete = true DO INSTEAD NOTHING;


DROP RULE IF EXISTS undelete_dma ON dma;
CREATE OR REPLACE RULE undelete_dma AS ON DELETE TO dma WHERE old.undelete = true DO INSTEAD NOTHING;


DROP RULE IF EXISTS undelete_sector ON sector;
CREATE OR REPLACE RULE undelete_sector AS ON DELETE TO sector WHERE old.undelete = true DO INSTEAD NOTHING;


DROP RULE IF EXISTS insert_plan_arc_x_psector ON arc;
CREATE OR REPLACE RULE insert_plan_arc_x_psector AS ON INSERT TO arc WHERE NEW.state=2 DO 
INSERT INTO plan_arc_x_psector (arc_id, psector_id, state, doable) 
VALUES (new.arc_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()),1,TRUE);
  

DROP RULE IF EXISTS update_plan_arc_x_psector ON arc;
CREATE OR REPLACE RULE update_plan_arc_x_psector AS ON UPDATE TO arc WHERE NEW.state=2 AND (OLD.state=1 OR OLD.state=1) DO 
INSERT INTO plan_arc_x_psector (arc_id, psector_id, state, doable) 
VALUES (new.arc_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()),1,TRUE);


DROP RULE IF EXISTS delete_plan_arc_x_psector ON arc;
CREATE OR REPLACE RULE delete_plan_arc_x_psector AS ON UPDATE TO arc WHERE (NEW.state=1 OR NEW.state=0) AND OLD.state=2 DO 
DELETE FROM plan_arc_x_psector WHERE arc_id=NEW.arc_id;


DROP RULE IF EXISTS insert_plan_arc_x_pavement ON arc;
CREATE OR REPLACE RULE insert_plan_arc_x_pavement AS
ON INSERT TO arc DO  
INSERT INTO plan_arc_x_pavement (arc_id, percent) VALUES (new.arc_id, '1'::numeric);

