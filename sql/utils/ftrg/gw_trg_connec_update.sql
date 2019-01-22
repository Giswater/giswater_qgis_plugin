/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1108


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_connec_update() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 

linkrec Record; 
querystring text;
connecRecord1 record; 
connecRecord2 record;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

--  Select links with start-end on the updated node
	querystring := 'SELECT * FROM link WHERE (link.feature_id = ' || quote_literal(NEW.connec_id) || ' 
	AND feature_type=''CONNEC'') OR (link.exit_id = ' || quote_literal(NEW.connec_id)|| ' AND feature_type=''CONNEC'');'; 
	FOR linkrec IN EXECUTE querystring
	LOOP
		-- Initial and final connec of the LINK
		SELECT * INTO connecRecord1 FROM v_edit_connec WHERE v_edit_connec.connec_id = linkrec.feature_id AND linkrec.feature_type='CONNEC';
		SELECT * INTO connecRecord2 FROM v_edit_connec WHERE v_edit_connec.connec_id = linkrec.exit_id AND linkrec.exit_type='CONNEC'; 

		-- Update link
		IF (connecRecord1.connec_id = NEW.connec_id) THEN
			EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, 0, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
		ELSIF (connecRecord2.connec_id = NEW.connec_id) THEN
			EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
		END IF;
	END LOOP;


    RETURN NEW;
    
END; 
$$;
