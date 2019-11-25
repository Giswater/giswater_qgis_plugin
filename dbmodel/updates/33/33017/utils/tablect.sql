/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--24/11/2019
DROP INDEX IF EXISTS rpt_inp_arc_arc_id;
CREATE INDEX rpt_inp_arc_arc_id ON rpt_inp_arc USING btree (arc_id);

DROP INDEX IF EXISTS rpt_inp_node_node_id;
CREATE INDEX rpt_inp_node_node_id ON rpt_inp_node USING btree (node_id);
