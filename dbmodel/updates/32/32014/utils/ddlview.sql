/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE VIEW v_anl_graf AS
WITH nodes_a AS (SELECT anl_graf.node_1, anl_graf.node_2 FROM anl_graf WHERE water = 1)
SELECT graftype, anl_graf.arc_id, anl_graf.node_1 FROM anl_graf
LEFT JOIN nodes_a ON anl_graf.node_1::text = nodes_a.node_2::text
WHERE (anl_graf.flag = 0 AND nodes_a.node_1 IS NOT NULL) OR anl_graf.flag = 1 AND anl_graf.user_name::name = "current_user"();
