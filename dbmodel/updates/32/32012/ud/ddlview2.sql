/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_parent_arc;
CREATE OR REPLACE VIEW v_parent_arc AS 
 SELECT v_edit_arc.arc_id AS nid,
    v_edit_arc.arc_type AS custom_type
   FROM v_edit_arc;
   
  
DROP VIEW IF EXISTS v_parent_node;
CREATE OR REPLACE VIEW v_parent_node AS 
 SELECT v_edit_node.node_id AS nid,
    v_edit_node.node_type AS custom_type
   FROM v_edit_node;
   
   
DROP VIEW IF EXISTS v_parent_node ;
CREATE OR REPLACE VIEW ve_connec_parent AS 
 SELECT .connec_id AS nid,
    v_edit_connec.connec_type AS custom_type
   FROM SCHEMA_NAME.v_edit_connec;
   

DROP VIEW IF EXISTS v_parent_gully;
CREATE OR REPLACE VIEW v_parent_gully AS 
 SELECT v_edit_arc.arc_id AS nid,
    v_edit_arc.arc_type AS custom_type
   FROM v_edit_arc;