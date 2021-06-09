/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/09
CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
 SELECT row_number() OVER (ORDER BY v_node.node_id) AS rid,
    v_node.parent_id AS node_id,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.node_id AS child_id,
    v_node.code,
    v_node.sys_type,
    'v_edit_node'::text AS sys_table_id
   FROM v_node
  WHERE v_node.parent_id IS NOT NULL;