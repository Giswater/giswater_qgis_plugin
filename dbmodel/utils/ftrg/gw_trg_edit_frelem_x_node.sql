/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 2460

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_frelem_x_node() RETURNS trigger AS
$BODY$

DECLARE
	v_version text;
	v_project_type text;
	element_type varchar;
	old_node integer;
	v_epa_type text;
BEGIN

	SET search_path = "SCHEMA_NAME", public;

	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get element type
	SELECT cat_feature.feature_class INTO element_type
	FROM element
		JOIN cat_element ON element.elementcat_id = cat_element.id
		JOIN cat_feature_element ON cat_element.element_type = cat_feature_element.id
		JOIN cat_feature ON cat_feature_element.id = cat_feature.id
	WHERE element_id = NEW.element_id;

	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

		-- check if element is a frelem
		IF element_type = 'FRELEM' THEN

			IF v_project_type = 'WS' THEN
				-- check if node is already linked to a frelem
				IF EXISTS (SELECT 1 FROM element_x_node WHERE node_id = NEW.node_id) THEN
					IF EXISTS(
						SELECT 1
						FROM element
							JOIN cat_element ON element.elementcat_id = cat_element.id
							JOIN cat_feature_element ON cat_element.element_type = cat_feature_element.id
							JOIN cat_feature ON cat_feature_element.id = cat_feature.id
						WHERE element_id IN (SELECT element_id FROM element_x_node WHERE node_id = NEW.node_id) AND cat_feature.feature_class = 'FRELEM' AND element.epa_type != 'FRPUMP' LIMIT 1
					) THEN
						-- ANOTHER FRELEM IS LINKED TO THE NODE
						SELECT node_id INTO old_node FROM element_x_node WHERE element_id =  NEW.element_id;
						SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"4320", "function":"2560","parameters":{"node_id":"'||old_node||'"}, "is_process":true}}$$);
						RETURN NULL;
					ELSE
						-- NO OTHER FRELEM IS LINKED TO THE NODE
						UPDATE man_frelem SET node_id = NEW.node_id WHERE element_id = NEW.element_id;
						RETURN NEW;
					END IF;
				END IF;
			END IF;

			-- check if element is already linked to a node
			IF EXISTS (SELECT 1 FROM element_x_node WHERE element_id = NEW.element_id) THEN
				SELECT node_id INTO old_node FROM element_x_node WHERE element_id =  NEW.element_id;
				SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"4320", "function":"2560","parameters":{"node_id":"'||old_node||'"}, "is_process":true}}$$);
				RETURN NULL;
			ELSE
				UPDATE man_frelem SET node_id = NEW.node_id WHERE element_id = NEW.element_id;
				RETURN NEW;
			END IF;

		ELSE
			RETURN NEW;
		END IF;
	
	ELSEIF TG_OP = 'DELETE' THEN
		-- check if element is a frelem
		IF element_type = 'FRELEM' THEN
			SELECT epa_type INTO v_epa_type FROM element WHERE element_id = OLD.element_id;
			IF v_epa_type IS NOT NULL AND v_epa_type != 'UNDEFINED' THEN
				EXECUTE format('DELETE FROM inp_%s WHERE element_id = %s', v_epa_type, OLD.element_id);
			END IF;

			DELETE FROM element WHERE element_id = OLD.element_id;
		ELSE
			RETURN OLD;
		END IF;
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;