/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- add foreign key for presszone_id
ALTER TABLE arc ADD CONSTRAINT arc_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node ADD CONSTRAINT node_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE minsector ADD CONSTRAINT minsector_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE plan_netscenario_presszone ADD CONSTRAINT plan_netscenario_presszone_netscenario_id_fkey FOREIGN KEY (netscenario_id) REFERENCES plan_netscenario(netscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_arc ADD CONSTRAINT plan_netscenario_arc_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_node ADD CONSTRAINT plan_netscenario_node_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_connec ADD CONSTRAINT plan_netscenario_connec_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;

-- create rules to avoid presszone_id = -1 or 0
CREATE RULE presszone_conflict AS
    ON UPDATE TO presszone
   WHERE ((NEW.presszone_id = -1) OR (OLD.presszone_id = -1)) DO INSTEAD NOTHING;

CREATE RULE presszone_del_uconflict AS
    ON DELETE TO presszone
   WHERE (OLD.presszone_id = -1) DO INSTEAD NOTHING;

CREATE RULE presszone_del_undefined AS
    ON DELETE TO presszone
   WHERE (OLD.presszone_id = 0) DO INSTEAD NOTHING;

CREATE RULE presszone_undefined AS
    ON UPDATE TO presszone
   WHERE ((NEW.presszone_id = 0) OR (OLD.presszone_id = 0)) DO INSTEAD NOTHING;