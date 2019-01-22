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

    
    IF TG_OP='UPDATE' THEN

		-- Update vnode/link
			
		-- Redraw the link and vnode
		FOR connec_id_aux IN SELECT connec_id FROM connec WHERE arc_id=NEW.arc_id
		LOOP
			array_connec_agg:= array_append(array_connec_agg, connec_id_aux);
			UPDATE connec SET arc_id=NULL WHERE connec_id=connec_id_aux;
						
		END LOOP;

		PERFORM gw_fct_connect_to_network(array_connec_agg, 'CONNEC');
		
		IF (select wsoftware FROM version LIMIT 1)='ud' THEN 

			FOR gully_id_aux IN SELECT gully_id FROM gully WHERE arc_id=NEW.arc_id
			LOOP
				array_gully_agg:= array_append(array_gully_agg, gully_id_aux);
				UPDATE gully SET arc_id=NULL WHERE gully_id=gully_id_aux;
			END LOOP;

			PERFORM gw_fct_connect_to_network(array_gully_agg, 'GULLY');
		
		END IF;

		RETURN NEW;

    END IF;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

 