/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2814

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_gully_proximity() 
RETURNS trigger AS 
$BODY$
DECLARE 
    v_numConnecs numeric;
    v_gully_proximity double precision;
    v_gully_proximity_control boolean;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get gully tolerance from config table

    SELECT ((value::json)->>'value') INTO v_gully_proximity FROM config_param_system WHERE parameter='edit_gully_proximity';
    SELECT ((value::json)->>'activated') INTO v_gully_proximity_control FROM config_param_system WHERE parameter='edit_gully_proximity';

    IF TG_OP = 'INSERT' THEN
        -- Existing gullys  
        v_numConnecs:= (SELECT COUNT(*) FROM gully WHERE gully.the_geom && ST_Expand(NEW.the_geom, v_gully_proximity));

    ELSIF TG_OP = 'UPDATE' THEN
        -- Existing gullys  
       v_numConnecs := (SELECT COUNT(*) FROM gully WHERE ST_DWithin(NEW.the_geom, gully.the_geom, v_gully_proximity) AND gully.gully_id != NEW.gully_id);
    END IF;

    -- If there is an existing gully closer than 'rec.gully_tolerance' meters --> error
    IF (v_numConnecs > 0) AND (v_gully_proximity_control IS TRUE) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1044", "function":"2814","debug_msg":"'||NEW.gully_id||'"}}$$);';
    END IF;

    RETURN NEW;

     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
