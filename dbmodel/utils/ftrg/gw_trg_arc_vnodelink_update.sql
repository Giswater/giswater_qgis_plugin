/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2542


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_vnodelink_update()
  RETURNS trigger AS
$BODY$
DECLARE 
    connec_id_aux text;
    gully_id_aux text;
    array_connec_agg text[];
    array_gully_agg text[];

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- only if the geometry has changed (not reversed) because reverse may not affect links....
    IF st_orderingequals(OLD.the_geom, NEW.the_geom) IS FALSE THEN

		-- Redraw the link and vnode
		FOR connec_id_aux IN SELECT connec_id FROM connec JOIN link ON link.feature_id=connec_id 
		WHERE link.feature_type='CONNEC' AND exit_type='VNODE' AND arc_id=NEW.arc_id
		LOOP
			array_connec_agg:= array_append(array_connec_agg,connec_id_aux);
			UPDATE connec SET arc_id=NULL WHERE connec_id=connec_id_aux;	
		END LOOP;

		IF array_connec_agg IS NOT NULL THEN
			EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
			"feature":{"id":'|| array_to_json(array_connec_agg)||'},"data":{"feature_type":"CONNEC"}}$$)';
		END IF;

		IF (select project_type FROM sys_version LIMIT 1)='UD' THEN

			FOR gully_id_aux IN SELECT gully_id FROM gully JOIN link ON link.feature_id=gully_id 
			WHERE link.feature_type='GULLY' AND exit_type='VNODE' AND arc_id=NEW.arc_id
			LOOP
				array_gully_agg:= array_append(array_gully_agg,gully_id_aux);
				UPDATE gully SET arc_id=NULL WHERE gully_id=gully_id_aux;
			END LOOP;

			IF array_gully_agg IS NOT NULL THEN
				EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
				"feature":{"id":'|| array_to_json(array_gully_agg)||'},"data":{"feature_type":"GULLY"}}$$)';		
			END IF;
		END IF;
    END IF;

    RETURN NEW;

    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

 