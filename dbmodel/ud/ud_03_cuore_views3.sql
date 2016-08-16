/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------



  
 
CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_element_x_node AS 
SELECT
element_x_node.id,
element_x_node.node_id,
element.elementcat_id,
element_x_node.element_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM SCHEMA_NAME.element_x_node
JOIN SCHEMA_NAME.element ON element.element_id::text = element_x_node.element_id::text;




CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_element_x_connec AS
SELECT
element_x_connec.id,
element_x_connec.connec_id,
element.elementcat_id,
element_x_connec.element_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM SCHEMA_NAME.element_x_connec
JOIN SCHEMA_NAME.element ON element.element_id::text = element_x_connec.element_id::text;



CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_element_x_gully AS
SELECT
element_x_gully.id,
element_x_gully.gully_id,
element.elementcat_id,
element_x_gully.element_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM SCHEMA_NAME.element_x_gully
JOIN SCHEMA_NAME.element ON element.element_id::text = element_x_gully.element_id::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_element_x_arc AS
SELECT
element_x_arc.id,
element_x_arc.arc_id,
element.elementcat_id,
element_x_arc.element_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM SCHEMA_NAME.element_x_arc
JOIN SCHEMA_NAME.element ON element.element_id::text = element_x_arc.element_id::text;







