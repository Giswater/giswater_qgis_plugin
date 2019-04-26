/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1126


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_network_features();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_vnode()
  RETURNS trigger AS
$BODY$
DECLARE 

    vnode_seq int8;
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

-- INSERT
	IF TG_OP = 'INSERT' THEN

		RAISE EXCEPTION ' It is not enabled to insert vnodes. if you are looking for join links you can use vconnec to join it. You can create this vconnec feature and simbolyze it as vnodes. Using vconnec as vnodes you will have all features in terms of propagation of arc_id';

-- UPDATE
	ELSIF TG_OP = 'UPDATE' THEN
    
		UPDATE vnode
		SET vnode_id=NEW.vnode_id, vnode_type=NEW.vnode_type, sector_id=NEW.sector_id, state=NEW.state, annotation=NEW.annotation, the_geom=NEW.the_geom, expl_id=NEW.expl_id
		WHERE vnode_id=NEW.vnode_id;

		RETURN NEW;
-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM vnode WHERE vnode_id=OLD.vnode_id;
		
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
