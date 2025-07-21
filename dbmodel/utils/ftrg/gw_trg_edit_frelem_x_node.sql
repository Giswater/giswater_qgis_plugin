/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 2460

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_frelem_x_node() RETURNS trigger AS
$BODY$

DECLARE 
	element_type varchar;
	old_node integer;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
		
	SELECT cat_feature.feature_class INTO element_type
	FROM element
		JOIN cat_element ON element.elementcat_id = cat_element.id
		JOIN cat_feature_element ON cat_element.element_type = cat_feature_element.id
		JOIN cat_feature ON cat_feature_element.id = cat_feature.id
	WHERE element_id = NEW.element_id;


	IF element_type = 'FRELEM' THEN
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
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;