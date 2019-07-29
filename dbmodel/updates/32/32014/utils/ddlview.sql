/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE VIEW SCHEMA_NAME.vi_parent_arc AS 
SELECT ve_arc.*
FROM ve_arc, inp_selector_sector 
WHERE ve_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.vi_parent_node as
SELECT DISTINCT ON (node_id) ve_node.*
FROM ve_node
JOIN vi_parent_arc a ON a.node_1::text = ve_node.node_id::text OR a.node_2::text = ve_node.node_id::text;

