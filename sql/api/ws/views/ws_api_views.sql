/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- VIEW PARENT

CREATE OR REPLACE VIEW v_web_parent_arc AS 
 SELECT v_edit_arc.arc_id AS nid,
    v_edit_arc.cat_arctype_id AS custom_type
   FROM v_edit_arc;
   
   
      
CREATE OR REPLACE VIEW v_web_parent_connec AS 
 SELECT v_edit_connec.connec_id AS nid,
    v_edit_connec.connectype_id AS custom_type
   FROM v_edit_connec;
   
   
   
   CREATE OR REPLACE VIEW v_web_parent_node AS 
 SELECT v_edit_node.node_id AS nid,
    v_edit_node.nodetype_id AS custom_type
   FROM v_edit_node;
   

-- VIEWS CHILD