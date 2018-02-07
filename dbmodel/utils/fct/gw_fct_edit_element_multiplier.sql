/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2428


--DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_edit_element_multiplier(character varying);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_edit_element_multiplier(element_id_aux varchar) RETURNS void AS
$BODY$

DECLARE 
rec_element record;
rec_feature record;
id_last bigint;
project_type_aux text;

BEGIN 

	SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO rec_element FROM element WHERE element_id=element_id_aux;
	SELECT wsoftware INTO project_type_aux FROM version;


	IF project_type_aux='UD' THEN
	
		-- looking for all features relateds to element
		FOR rec_feature IN 
		SELECT element_id, node_id as feature_id FROM element_x_node WHERE element_id=element_id_aux UNION
		SELECT element_id, arc_id as feature_id FROM element_x_arc WHERE element_id=element_id_aux UNION
		SELECT element_id, connec_id as feature_id FROM element_x_connec WHERE element_id=element_id_aux UNION
		SELECT element_id, gully_id as feature_id FROM element_x_gully WHERE element_id=element_id_aux
		LOOP 
			-- inserting new element on element table
			INSERT INTO element (code, elementcat_id, serial_number, num_elements, state, state_type, observ, comment, function_type, category_type, 
			fluid_type, location_type, workcat_id, workcat_id_end,buildercat_id, builtdate, enddate, ownercat_id, rotation, link, verified, 
			the_geom, label_x, label_y, label_rotation, undelete, publish, inventory, expl_id, feature_type)
			
			VALUES (rec_element.code, rec_element.elementcat_id, rec_element.serial_number, rec_element.num_elements, rec_element.state, rec_element.state_type, 
			rec_element.observ, rec_element.comment, rec_element.function_type, rec_element.category_type, rec_element.fluid_type, rec_element.location_type, 
			rec_element.workcat_id, rec_element.workcat_id_end, rec_element.buildercat_id, rec_element.builtdate, rec_element.enddate, rec_element.ownercat_id, 
			rec_element.rotation, rec_element.link, rec_element.verified, rec_element.the_geom, rec_element.label_x, rec_element.label_y, 
			rec_element.label_rotation, rec_element.undelete, rec_element.publish, rec_element.inventory, rec_element.expl_id, rec_element.feature_type) 
			RETURNING element_id INTO id_last;
	
			-- updating values of feature on element_x_feature table
			UPDATE element_x_node SET element_id=id_last WHERE element_id=element_id_aux AND node_id=rec_feature.feature_id;
			UPDATE element_x_arc SET element_id=id_last WHERE element_id=element_id_aux AND arc_id=rec_feature.feature_id;
			UPDATE element_x_connec SET element_id=id_last WHERE element_id=element_id_aux AND connec_id=rec_feature.feature_id;
			UPDATE element_x_gully SET element_id=id_last WHERE element_id=element_id_aux AND gully_id=rec_feature.feature_id;

		END LOOP;
			ELSIF project_type_aux='WS' THEN

		-- looking for all features relateds to element
		FOR rec_feature IN 
		SELECT element_id, node_id as feature_id FROM element_x_node WHERE element_id=element_id_aux UNION
		SELECT element_id, arc_id as feature_id FROM element_x_arc WHERE element_id=element_id_aux UNION
		SELECT element_id, connec_id as feature_id FROM element_x_connec WHERE element_id=element_id_aux
		LOOP 
			-- inserting new element on element table
			INSERT INTO element (code, elementcat_id, serial_number, num_elements, state, state_type, observ, comment, function_type, category_type, 
			fluid_type, location_type, workcat_id, workcat_id_end,buildercat_id, builtdate, enddate, ownercat_id, rotation, link, verified, 
			the_geom, label_x, label_y, label_rotation, undelete, publish, inventory, expl_id, feature_type)
			
			VALUES (rec_element.code, rec_element.elementcat_id, rec_element.serial_number, rec_element.num_elements, rec_element.state, rec_element.state_type, 
			rec_element.observ, rec_element.comment, rec_element.function_type, rec_element.category_type, rec_element.fluid_type, rec_element.location_type, 
			rec_element.workcat_id, rec_element.workcat_id_end, rec_element.buildercat_id, rec_element.builtdate, rec_element.enddate, rec_element.ownercat_id, 
			rec_element.rotation, rec_element.link, rec_element.verified, rec_element.the_geom, rec_element.label_x, rec_element.label_y, 
			rec_element.label_rotation, rec_element.undelete, rec_element.publish, rec_element.inventory, rec_element.expl_id, rec_element.feature_type) 
			RETURNING element_id INTO id_last;
	
			-- updating values of feature on element_x_feature table
			UPDATE element_x_node SET element_id=id_last WHERE element_id=element_id_aux AND node_id=rec_feature.feature_id;
			UPDATE element_x_arc SET element_id=id_last WHERE element_id=element_id_aux AND arc_id=rec_feature.feature_id;
			UPDATE element_x_connec SET element_id=id_last WHERE element_id=element_id_aux AND connec_id=rec_feature.feature_id;

		END LOOP;

	END IF;
  
	-- delete original element 
	DELETE FROM element WHERE element_id=element_id_aux;
	
RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;