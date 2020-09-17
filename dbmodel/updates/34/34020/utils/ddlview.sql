/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


set search_path = 'SCHEMA_NAME';


CREATE OR REPLACE VIEW v_edit_element AS 
 SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    pol_id
   FROM selector_expl,
    element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



DROP TRIGGER IF EXISTS gw_trg_edit_element_pol ON v_edit_element_pol;
DROP VIEW IF EXISTS v_edit_element_pol;
CREATE OR REPLACE VIEW ve_pol_element AS 
 SELECT e.pol_id,
    e.element_id,
    polygon.the_geom
   FROM v_edit_element e
     JOIN polygon USING (pol_id);
     
