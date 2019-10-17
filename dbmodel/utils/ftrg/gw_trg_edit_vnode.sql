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
	v_projectype text;
	v_new_arc_id text;
	v_link_geom public.geometry;
	v_arc_geom public.geometry;
	v_userdefined_geom boolean;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	SELECT wsoftware INTO v_projectype FROM version LIMIT 1;

-- INSERT
	IF TG_OP = 'INSERT' THEN

		RAISE EXCEPTION ' It is not enabled to insert vnodes. if you are looking for join links you can use vconnec to join it. You can create this vconnec feature and simbolyze it as vnodes. Using vconnec as vnodes you will have all features in terms of propagation of arc_id';

-- UPDATE
	ELSIF TG_OP = 'UPDATE' THEN

		-- update geom
		IF NEW.ispsectorgeom IS FALSE THEN -- if geometry comes from vnode table
			UPDATE vnode SET the_geom=NEW.the_geom WHERE vnode_id=NEW.vnode_id;
		ELSE

			-- update psector tables
			SELECT arc_id,arc.the_geom INTO v_new_arc_id,v_arc_geom FROM arc,v_edit_vnode 
			WHERE st_dwithin (v_edit_vnode.the_geom, arc.the_geom,0.01) AND v_edit_vnode.vnode_id=NEW.vnode_id;

			IF v_new_arc_id IS NOT NULL THEN
				
				--get userdefined_geom value
				SELECT userdefined_geom, link_geom INTO v_userdefined_geom, v_link_geom FROM plan_psector_x_connec WHERE id=NEW.psector_rowid;

				-- redraw link_geom in case userdefined true
				IF ST_equals(NEW.the_geom, OLD.the_geom) IS FALSE THEN -- on the other case link_geom must be calculated on trg_plan_psector_link		
					v_link_geom  := ST_SetPoint(v_link_geom, ST_NumPoints(v_link_geom) - 1, NEW.the_geom);
					v_userdefined_geom = TRUE;
				END IF;
	
				IF v_projectype = 'WS' THEN
					UPDATE plan_psector_x_connec SET vnode_geom = NEW.the_geom, link_geom=v_link_geom, userdefined_geom= v_userdefined_geom, arc_id=v_new_arc_id
					WHERE plan_psector_x_connec.id=NEW.psector_rowid;
					
				ELSIF v_projectype = 'UD' THEN
					IF NEW.feature_type='CONNEC' THEN
						UPDATE plan_psector_x_connec SET vnode_geom = NEW.the_geom, link_geom=v_link_geom, userdefined_geom= v_userdefined_geom, arc_id=v_new_arc_id
						WHERE plan_psector_x_connec.id=NEW.psector_rowid;
					ELSIF NEW.feature_type='GULLY' THEN
						UPDATE plan_psector_x_gully SET link_geom = NEW.the_geom, link_geom=v_link_geom, userdefined_geom= v_userdefined_geom, arc_id=v_new_arc_id
						WHERE plan_psector_x_gully.id=NEW.psector_rowid;
					END IF;
					
				END IF;				
			END IF;
		END IF;	

		--update the rest of values
		IF v_projectype='WS' THEN
			UPDATE vnode SET elev=NEW.elev WHERE vnode_id=NEW.vnode_id;
		ELSE
			UPDATE vnode SET top_elev=NEW.top_elev WHERE vnode_id=NEW.vnode_id;
		END IF; 
	

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
