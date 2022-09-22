/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/21
ALTER TABLE temp_anlgraph RENAME CONSTRAINT temp_anlgraf_pkey TO temp_anlgraph_pkey;
ALTER TABLE temp_anlgraph RENAME CONSTRAINT temp_anlgraf_unique TO temp_anlgraph_unique;

ALTER SEQUENCE temp_anlgraf_id_seq RENAME TO temp_anlgraph_id_seq;

ALTER INDEX IF EXISTS temp_anlgraf_arc_id RENAME TO temp_anlgraph_arc_id;
ALTER INDEX IF EXISTS temp_anlgraf_node_1 RENAME TO temp_anlgraph_node_1;
ALTER INDEX IF EXISTS temp_anlgraf_node_2 RENAME TO temp_anlgraph_node_2;