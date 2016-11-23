/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_man_arc CASCADE;
CREATE VIEW v_man_arc AS 
SELECT
arc_id,
node_1,
node_2,
the_geom
FROM arc
JOIN man_selector_state ON arc.state=man_selector_state.id
;

DROP VIEW IF EXISTS v_man_node CASCADE;
CREATE VIEW v_man_node AS 
SELECT
node_id,
the_geom
FROM node
JOIN man_selector_state ON arc.state=man_selector_state.id
;

DROP VIEW IF EXISTS v_man_connec CASCADE;
CREATE VIEW v_man_connec AS 
SELECT
connec_id,
the_geom
FROM connec
JOIN man_selector_state ON arc.state=man_selector_state.id
;



