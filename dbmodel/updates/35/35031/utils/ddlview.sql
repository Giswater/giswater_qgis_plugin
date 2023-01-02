/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_macrosector AS 
 SELECT macrosector.macrosector_id,
    macrosector.name,
    macrosector.descript,
    macrosector.the_geom,
    macrosector.undelete,
    macrosector.active
   FROM macrosector WHERE active is true;

ALTER VIEW v_state_arc RENAME TO v_filter_arc;
ALTER VIEW v_state_node RENAME TO v_filter_node;
ALTER VIEW v_state_connec RENAME TO v_filter_connec;
ALTER VIEW v_state_element RENAME TO v_filter_element;
ALTER VIEW v_state_dimensions RENAME TO v_filter_dimensions;
ALTER VIEW v_state_samplepoint RENAME TO v_filter_samplepoint;