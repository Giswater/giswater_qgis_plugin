/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_ui_element_x_node;
CREATE OR REPLACE VIEW v_ui_element_x_node AS
SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_node
JOIN element ON element.element_id = element_x_node.element_id
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type = element.location_type AND man_type_location.feature_type='ELEMENT'
LEFT JOIN cat_element ON cat_element.id=element.elementcat_id
WHERE element.state = 1;


DROP VIEW IF EXISTS v_ui_element_x_arc;
CREATE OR REPLACE VIEW v_ui_element_x_arc AS
SELECT element_x_arc.id,
    element_x_arc.arc_id,
    element_x_arc.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_arc
JOIN element ON element.element_id = element_x_arc.element_id
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type = element.location_type AND man_type_location.feature_type='ELEMENT'
LEFT JOIN cat_element ON cat_element.id=element.elementcat_id
WHERE element.state = 1;


DROP VIEW IF EXISTS v_ui_element_x_connec;
CREATE OR REPLACE VIEW v_ui_element_x_connec AS
SELECT element_x_connec.id,
    element_x_connec.connec_id,
    element_x_connec.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_connec
JOIN element ON element.element_id = element_x_connec.element_id
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type = element.location_type AND man_type_location.feature_type='ELEMENT'
LEFT JOIN cat_element ON cat_element.id=element.elementcat_id
WHERE element.state = 1;




