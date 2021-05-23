/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/23
CREATE OR REPLACE VIEW vp_basic_arc AS 
SELECT arc_id AS nid,
arc_type AS custom_type
FROM arc;

CREATE OR REPLACE VIEW vp_basic_connec AS 
SELECT connec_id AS nid,
connec_type AS custom_type
FROM connec;

CREATE OR REPLACE VIEW vp_basic_gully AS 
SELECT gully_id AS nid,
gully_type AS custom_type
FROM gully;

CREATE OR REPLACE VIEW vp_basic_node AS 
SELECT node_id AS nid,
node_type AS custom_type
FROM node;
