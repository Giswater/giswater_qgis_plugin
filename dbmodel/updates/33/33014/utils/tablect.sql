/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--14/11/2019
DROP INDEX IF EXISTS temp_anlgraf_arc_id;
CREATE INDEX temp_anlgraf_arc_id
  ON temp_anlgraf
  USING btree
  (arc_id);

DROP INDEX IF EXISTS temp_anlgraf_node_1;
CREATE INDEX temp_anlgraf_node_1
  ON temp_anlgraf
  USING btree
  (node_1);

DROP INDEX IF EXISTS temp_anlgraf_node_2;
CREATE INDEX temp_anlgraf_node_2
  ON temp_anlgraf
  USING btree
  (node_2);
