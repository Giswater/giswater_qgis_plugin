/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 23/12/2024
CREATE INDEX arc_streetname ON arc USING btree (streetname);
CREATE INDEX arc_streetname2 ON arc USING btree (streetname2);

CREATE INDEX node_streetname ON node USING btree (streetname);
CREATE INDEX node_streetname2 ON node USING btree (streetname2);

CREATE INDEX connec_streetname ON connec USING btree (streetname);
CREATE INDEX connec_streetname2 ON connec USING btree (streetname2);

CREATE INDEX link_expl_id2 ON link USING btree (expl_id2);

ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_expl_id_fkey;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_expl_id_fkey 
FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX rpt_arc_arc_id ON rpt_arc USING btree (arc_id);
CREATE INDEX rpt_arc_result_id ON rpt_arc USING btree (result_id);


