/*This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);


--3.1.110
CREATE OR REPLACE VIEW v_web_parent_node AS 
 SELECT v_edit_node.node_id AS nid,
    v_edit_node.node_type AS custom_type,
    node_type.descript
   FROM v_edit_node
   JOIN node_type ON node_type.id = v_edit_node.node_type;


CREATE OR REPLACE VIEW v_web_parent_arc AS 
 SELECT v_edit_arc.arc_id AS nid,
    v_edit_arc.arc_type AS custom_type,
    arc_type.descript
   FROM v_edit_arc
   JOIN arc_type ON arc_type.id = v_edit_arc.arc_type;
   

CREATE OR REPLACE VIEW v_web_parent_connec AS 
 SELECT v_edit_connec.connec_id AS nid,
    v_edit_connec.connec_type AS custom_type,
    connec_type.descript
   FROM v_edit_connec
   JOIN connec_type ON connec_type.id = v_edit_connec.connec_type;


CREATE OR REPLACE VIEW v_web_parent_gully AS 
 SELECT v_edit_gully.gully_id AS nid,
    v_edit_gully.gully_type AS custom_type,
    gully_type.descript
   FROM v_edit_gully
   JOIN gully_type ON gully_type.id = v_edit_gully.gully_type;



