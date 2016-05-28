/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- MINCUT
-- ----------------------------


CREATE OR REPLACE VIEW SCHEMA_NAME.v_mincut_connec AS 
SELECT
anl_mincut_node.node_id
FROM SCHEMA_NAME.anl_mincut_node;



CREATE OR REPLACE VIEW SCHEMA_NAME.v_mincut_hydrometer AS 
SELECT
anl_mincut_node.node_id
FROM SCHEMA_NAME.anl_mincut_node;

