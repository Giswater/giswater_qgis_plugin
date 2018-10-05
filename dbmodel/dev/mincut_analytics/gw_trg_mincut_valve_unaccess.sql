/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_trg_mincut_valve_unaccess"() RETURNS pg_catalog.trigger AS $BODY$

DECLARE 
feature_id_aux text;
feature_type_aux text;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    SELECT anl_feature_id INTO feature_id_aux FROM anl_mincut_result_cat WHERE id=NEW.result_id;
    SELECT anl_feature_type INTO feature_type_aux FROM anl_mincut_result_cat WHERE id=NEW.result_id;

    -- Computing process
    IF NEW.unaccess=TRUE AND (SELECT node_id FROM anl_mincut_result_valve_unaccess WHERE node_id=NEW.node_id AND result_id=NEW.result_id) IS NULL THEN
        INSERT INTO anl_mincut_result_valve_unaccess (result_id, node_id) VALUES (NEW.result_id, NEW.node_id);            
    ELSIF NEW.unaccess=FALSE THEN 
        DELETE FROM anl_mincut_result_valve_unaccess WHERE result_id=NEW.result_id AND node_id=NEW.node_id;
    END IF;

    PERFORM gw_fct_mincut(feature_id_aux, feature_type_aux, NEW.result_id, current_user);
            
        RETURN NEW;
    
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

