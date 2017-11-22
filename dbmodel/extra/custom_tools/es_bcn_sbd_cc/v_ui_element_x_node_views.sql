/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


DROP VIEW sanejament.v_ui_element_x_node;

CREATE OR REPLACE VIEW sanejament.v_ui_element_x_node AS 
 SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    element.elementcat_id,
    element.state,
    element.observ,
    element.comment,
    element.builtdate,
    element.enddate,
    element.units
   FROM sanejament.element_x_node
     JOIN sanejament.element ON element.element_id::text = element_x_node.element_id::text
     where is_last is true;

ALTER TABLE sanejament.v_ui_element_x_node
  OWNER TO postgres;
GRANT ALL ON TABLE sanejament.v_ui_element_x_node TO postgres;
GRANT ALL ON TABLE sanejament.v_ui_element_x_node TO "VIALITAT";
GRANT ALL ON TABLE sanejament.v_ui_element_x_node TO "ADMIN_GIS" WITH GRANT OPTION;
GRANT SELECT, REFERENCES, TRIGGER ON TABLE sanejament.v_ui_element_x_node TO "VIALITAT_CONSULTA";

-- Trigger: gw_trg_ui_element_x_node on sanejament.v_ui_element_x_node

-- DROP TRIGGER gw_trg_ui_element_x_node ON sanejament.v_ui_element_x_node;

CREATE TRIGGER gw_trg_ui_element_x_node
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON sanejament.v_ui_element_x_node
  FOR EACH ROW
  EXECUTE PROCEDURE sanejament.gw_trg_ui_element('element_x_node');

