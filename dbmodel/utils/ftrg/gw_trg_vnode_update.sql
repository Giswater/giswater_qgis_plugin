/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1144


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_vnode_update() RETURNS trigger AS $BODY$
DECLARE

linkrec record;
arcrec record;
rec record;
querystring text;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

        -- Start process
	SELECT * INTO rec FROM config;
	SELECT * INTO arcrec FROM v_edit_arc WHERE ST_DWithin((NEW.the_geom), v_edit_arc.the_geom, rec.vnode_update_tolerance) 
	ORDER BY ST_Distance(v_edit_arc.the_geom, (NEW.the_geom)) LIMIT 1;

        -- Snnaping to arc
	IF arcrec.arc_id IS NOT NULL THEN
		NEW.the_geom = ST_ClosestPoint(arcrec.the_geom, NEW.the_geom);
	END IF;


	--  Select links with end(exit) on the updated node
		querystring := 'SELECT * FROM link WHERE (link.exit_id = ' || quote_literal(NEW.vnode_id)|| ' AND exit_type=''VNODE'');'; 
		FOR linkrec IN EXECUTE querystring
		LOOP
			-- Update parent arc_id from connec table or gully table
			IF linkrec.feature_type='CONNEC' THEN
				UPDATE connec SET arc_id=arcrec.arc_id WHERE connec.connec_id = linkrec.feature_id;
			ELSIF linkrec.feature_type='GULLY' THEN
				UPDATE gully SET arc_id=arcrec.arc_id WHERE gully.gully_id = linkrec.feature_id;
			END IF;		
		
			-- Update link
			EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || 
			quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
			
		END LOOP;

    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;