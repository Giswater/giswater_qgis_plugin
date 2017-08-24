/*
This file is part of Giswater 3
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
	gully_geom_start public.geometry;
	gully_geom_end public.geometry;
	link_geom public.geometry;
	man_table varchar;
	connec_geom_start public.geometry;
	connec_geom_end public.geometry;
	arc_id_start varchar;
	arc_id_end varchar;
	sector_id_int integer;
	connec_counter varchar;
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
        man_table:= TG_ARGV[0];
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

			--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(125,340);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(130,340);
				RETURN NULL; 
            END IF;
		
		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
	
   			--vnode id
			IF (NEW.vnode_id IS NULL) THEN
				--PERFORM setval('urn_id_seq', gw_fct_urn(),true);
				NEW.vnode_id:= (SELECT nextval('urn_id_seq'));
			END IF;      
			
        -- link ID
			IF (NEW.link_id IS NULL) THEN
				--PERFORM setval('urn_id_seq', gw_fct_urn()+1,true);
				NEW.link_id:= (SELECT nextval('urn_id_seq'));
			END IF;			
		

		
				link_geom:=NEW.the_geom;

				vnode_start:=ST_StartPoint(link_geom);
				vnode_end:=ST_EndPoint(link_geom);
				
				SELECT the_geom INTO arc_geom_start FROM arc WHERE ST_DWithin(vnode_start, arc.the_geom,0.001) LIMIT 1;
				SELECT the_geom INTO arc_geom_end FROM arc WHERE ST_DWithin(vnode_end, arc.the_geom,0.001) LIMIT 1;
				
				SELECT the_geom INTO gully_geom_start FROM gully WHERE ST_DWithin(vnode_start, gully.the_geom,0.001) LIMIT 1;
				SELECT the_geom INTO gully_geom_end FROM gully WHERE ST_DWithin(vnode_end, gully.the_geom,0.001) LIMIT 1;
				SELECT the_geom INTO connec_geom_start FROM connec WHERE ST_DWithin(vnode_start, connec.the_geom,0.001) LIMIT 1;
				SELECT the_geom INTO connec_geom_end FROM connec WHERE ST_DWithin(vnode_end, connec.the_geom,0.001) LIMIT 1;
				SELECT arc_id INTO arc_id_start FROM arc WHERE ST_DWithin(vnode_start, arc.the_geom,0.001) LIMIT 1;
				SELECT arc_id INTO arc_id_end FROM arc WHERE ST_DWithin(vnode_end, arc.the_geom,0.001) LIMIT 1;
					
				IF arc_geom_start IS  NULL  OR arc_geom_end IS  NULL  THEN			
					RAISE NOTICE 'ARC START AND END NULL' ;
				END IF;

				IF arc_geom_start IS NOT NULL THEN
				
					IF NEW.feature_id IS NULL AND gully_geom_end IS NOT NULL  THEN
						NEW.feature_id=(SELECT gully_id FROM gully WHERE  ST_DWithin(vnode_end, gully.the_geom,0.001));
						NEW.featurecat_id='gully';
						sector_id_int=(SELECT sector_id FROM connec WHERE connec_id=NEW.feature_id);
					END IF;

					IF NEW.feature_id IS NULL AND connec_geom_end IS NOT NULL THEN
						NEW.feature_id=(SELECT connec_id FROM connec WHERE  ST_DWithin(vnode_end, connec.the_geom,0.001));
						NEW.featurecat_id='connec';
						sector_id_int=(SELECT sector_id FROM connec WHERE connec_id=NEW.feature_id);
					END IF;
					
					SELECT connec_id INTO connec_counter FROM v_edit_man_connec WHERE connec_id=NEW.feature_id AND arc_id IS NOT NULL;
					IF connec_counter IS NOT NULL  THEN
						RAISE EXCEPTION 'Connec already has a link %', NEW.feature_id;
					END IF;	
					
					INSERT INTO vnode (vnode_id, the_geom, expl_id,  sector_id, vnode_type,state) 
					VALUES (NEW.vnode_id, vnode_start, expl_id_int, sector_id_int,NEW.featurecat_id,NEW.state);			
					
					INSERT INTO link (link_id,featurecat_id, feature_id, vnode_id,  the_geom)
					VALUES (NEW.link_id,  NEW.featurecat_id, NEW.feature_id, NEW.vnode_id, NEW.the_geom);
				END IF;

					IF arc_geom_end IS NOT NULL THEN		

					IF NEW.feature_id IS NULL AND gully_geom_start IS NOT NULL THEN
						NEW.feature_id=(SELECT gully_id FROM gully WHERE  ST_DWithin(vnode_start, gully.the_geom,0.001));
						NEW.featurecat_id='gully';
						sector_id_int=(SELECT sector_id FROM connec WHERE connec_id=NEW.feature_id);
					END IF;
					IF NEW.feature_id IS NULL AND connec_geom_start IS NOT NULL THEN
						NEW.feature_id=(SELECT connec_id FROM connec WHERE  ST_DWithin(vnode_start, connec.the_geom,0.001));
						NEW.featurecat_id='connec';
						sector_id_int=(SELECT sector_id FROM connec WHERE connec_id=NEW.feature_id);
					END IF;
					
				SELECT connec_id INTO connec_counter FROM v_edit_man_connec WHERE connec_id=NEW.feature_id AND arc_id IS NOT NULL;
				IF connec_counter IS NOT NULL  THEN
						RAISE EXCEPTION 'Connec already has a link %', NEW.feature_id;
				END IF;
				
					INSERT INTO vnode (vnode_id, the_geom, expl_id,  sector_id, vnode_type,state) 
					VALUES (NEW.vnode_id, vnode_end, expl_id_int, sector_id_int,NEW.featurecat_id,NEW.state);			
					
					INSERT INTO link (link_id,featurecat_id, feature_id, vnode_id,  the_geom)
					VALUES (NEW.link_id,  NEW.featurecat_id, NEW.feature_id, NEW.vnode_id, NEW.the_geom);
					END IF;
					
				IF gully_geom_end IS NOT NULL AND gully_geom_start IS NOT NULL THEN
					IF NEW.feature_id IS NULL THEN
						NEW.feature_id=(SELECT gully_id FROM gully WHERE  ST_DWithin(vnode_start, gully.the_geom,0.001));
						NEW.featurecat_id='gully';
					END IF;
					
					INSERT INTO link (link_id,featurecat_id, feature_id, vnode_id,  the_geom)
					VALUES (NEW.link_id,  NEW.featurecat_id, NEW.feature_id, NEW.vnode_id, NEW.the_geom);
				END IF;	
				

					RETURN NEW;
					
    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE link 
		SET link_id=NEW.link_id, featurecat_id=NEW.featurecat_id,  feature_id=NEW.feature_id, vnode_id=NEW.vnode_id, the_geom=NEW.the_geom
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
