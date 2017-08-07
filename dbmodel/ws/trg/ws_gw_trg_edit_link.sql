/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_link() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;
	expl_id_int integer;
	vnode_end public.geometry;
	vnode_start public.geometry;
	arc_geom_start public.geometry;
	arc_geom_end public.geometry;
	link_geom public.geometry;
	connec_counter varchar;
	arc_id_start varchar;
	arc_id_end varchar;
	sector_id_varchar varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
		
			--vnode id
		IF (NEW.vnode_id IS NULL) THEN
				PERFORM setval('urn_id_seq', gw_fct_urn(),true);
				NEW.vnode_id:= (SELECT nextval('urn_id_seq'));
			END IF;               
			
        -- link ID
		IF (NEW.link_id IS NULL) THEN
				PERFORM setval('urn_id_seq', gw_fct_urn()+1,true);
				NEW.link_id:= (SELECT nextval('urn_id_seq'));
			END IF;			
		
		link_geom:=NEW.the_geom;

		vnode_start:=ST_StartPoint(link_geom);
		vnode_end:=ST_EndPoint(link_geom);
		
		SELECT the_geom INTO arc_geom_start FROM arc WHERE ST_DWithin(vnode_start, arc.the_geom,0.001) LIMIT 1;
		SELECT the_geom INTO arc_geom_end FROM arc WHERE ST_DWithin(vnode_end, arc.the_geom,0.001) LIMIT 1;
		SELECT arc_id INTO arc_id_start FROM arc WHERE ST_DWithin(vnode_start, arc.the_geom,0.001) LIMIT 1;
		SELECT arc_id INTO arc_id_end FROM arc WHERE ST_DWithin(vnode_end, arc.the_geom,0.001) LIMIT 1;
		
		IF NEW.feature_id IS NULL THEN
			NEW.feature_id=(SELECT connec_id FROM connec WHERE  ST_DWithin(vnode_start, connec.the_geom,0.001) OR ST_DWithin(vnode_end, connec.the_geom,0.001));
			NEW.featurecat_id=(SELECT connec_type FROM connec WHERE connec_id=NEW.feature_id);
		END IF;
		
		IF arc_geom_start IS NOT NULL THEN
			INSERT INTO vnode (vnode_id, the_geom, vnode_type, arc_id) VALUES (NEW.vnode_id, vnode_start,  NEW.featurecat_id, arc_id_start );
		END IF;

		IF arc_geom_end IS NOT NULL THEN
			INSERT INTO vnode (vnode_id, the_geom, vnode_type, arc_id ) VALUES (NEW.vnode_id, vnode_end, NEW.featurecat_id,arc_id_end);
		END IF;
		
		SELECT connec_id INTO connec_counter FROM v_edit_connec WHERE connec_id=NEW.feature_id AND arc_id IS NOT NULL;
		IF connec_counter IS NOT NULL  THEN
			RAISE EXCEPTION 'Connec already has a link %', NEW.feature_id;
		END IF;
		
		INSERT INTO link (link_id, feature_id, vnode_id, custom_length, the_geom, featurecat_id)
		VALUES (NEW.link_id, NEW.feature_id, NEW.vnode_id, NEW.custom_length, NEW.the_geom, NEW.featurecat_id, );
		
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE link 
		SET link_id=NEW.link_id, feature_id=NEW.feature_id, vnode_id=NEW.vnode_id, custom_length=NEW.custom_length, the_geom=NEW.the_geom, featurecat_id=NEW.featurecat_id
		WHERE link_id=OLD.link_id;			
                
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM link WHERE link_id = OLD.link_id;
        RETURN NULL;
   
    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_link ON "SCHEMA_NAME".v_edit_link;
CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_link
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_link();

      