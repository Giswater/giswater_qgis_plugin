/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1116


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_link()
  RETURNS trigger AS
$BODY$
DECLARE 

	project_type_aux varchar;

	v_sql varchar;
	expl_id_int integer;
	sector_id_int integer;
	connec_counter varchar;

	link_geom public.geometry;
	link_end public.geometry;
	link_start public.geometry;

	link_geom_old public.geometry;
	link_end_old public.geometry;
	link_start_old public.geometry;

	arc_geom_end public.geometry;
	arc_id_end varchar;
	state_arg integer;
	expl_id_arg integer;
	sector_id_arg integer;
	dma_id_arg integer;

	state_start integer;
	
	node_geom_end public.geometry;
	node_id_end varchar;

	gully_geom_start public.geometry;
	gully_geom_end public.geometry;
	gully_id_start varchar;
	gully_id_end varchar;
	
	man_table varchar;

	connec_geom_start public.geometry;
	connec_geom_end public.geometry;
	connec_id_start varchar;	
	connec_id_end varchar;

	
	vnode_geom_start public.geometry;
	vnode_geom_end public.geometry;
	vnode_id_start varchar;	
	vnode_id_end varchar;
	
	count_int integer;
	
	v_link_searchbuffer double precision;
	
	init_aux_arc text;
	init_aux_node text;
	end_aux text;
	distance_init_aux double precision;
	distance_end_aux double precision;
	
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];

	-- To do (enhance link buffer using the same strategy of arcs, moving the endpoint of the link to the node candidate)
	-- Meanwhile, v_link_searchbuffer is forced to 0.001
	-- SELECT ??? into v_link_searchbuffer FROM config_param_system;
	v_link_searchbuffer=0.05;

    -- control of project type
    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
     
        -- link ID
			IF (NEW.link_id IS NULL) THEN
				--PERFORM setval('urn_id_seq', gw_fct_urn()+1,true);
				NEW.link_id:= (SELECT nextval('link_link_id_seq'));
			END IF;			
		
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1116); 
            END IF;
			NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"());
			END IF;
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1116,NEW.link_id::text); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1116); 
            END IF;
			NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"());
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1116,NEW.link_id::text); 
            END IF;
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := 1;
            END IF;
        END IF;

	
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1116,NEW.link_id::text);
				END IF;		
			END IF;
		END IF;		

		
		link_geom:=NEW.the_geom;
		link_start:=ST_StartPoint(link_geom);
		link_end:=ST_EndPoint(link_geom);
		

		-- arc as end point
		SELECT arc_id, the_geom INTO arc_id_end, arc_geom_end FROM v_edit_arc WHERE ST_DWithin(link_end, v_edit_arc.the_geom, v_link_searchbuffer) 
		ORDER by st_distance(link_end, v_edit_arc.the_geom) LIMIT 1;
		
		-- node as end point
		SELECT node_id, the_geom INTO node_id_end, node_geom_end FROM v_edit_node WHERE ST_DWithin(link_end, v_edit_node.the_geom, v_link_searchbuffer) 
		ORDER by st_distance(link_end, v_edit_node.the_geom) LIMIT 1;
		
		-- connec as init/end point
		SELECT connec_id, state, the_geom INTO connec_id_start, state_start, connec_geom_start FROM v_edit_connec WHERE ST_DWithin(link_start, v_edit_connec.the_geom,v_link_searchbuffer) 
		ORDER by st_distance(link_start, v_edit_connec.the_geom) LIMIT 1;
		
		SELECT connec_id, the_geom INTO connec_id_end, connec_geom_end FROM v_edit_connec WHERE ST_DWithin(link_end, v_edit_connec.the_geom,v_link_searchbuffer) 
		ORDER by st_distance(link_end, v_edit_connec.the_geom) LIMIT 1;

		--gully as init/end point
		IF project_type_aux='UD' then
			SELECT gully_id, state, the_geom INTO gully_id_start, state_start, gully_geom_start FROM v_edit_gully WHERE ST_DWithin(link_start, v_edit_gully.the_geom,v_link_searchbuffer) 
			ORDER by st_distance(link_start, v_edit_gully.the_geom) LIMIT 1;
			
			SELECT gully_id, the_geom INTO gully_id_end, gully_geom_end FROM v_edit_gully WHERE ST_DWithin(link_end, v_edit_gully.the_geom,v_link_searchbuffer) 
			ORDER by st_distance(link_end, v_edit_gully.the_geom) LIMIT 1;
		END IF;
				
		-- vnode as init/end point
		SELECT vnode_id, state, expl_id, sector_id, dma_id, the_geom INTO vnode_id_start, state_arg, expl_id_arg, sector_id_arg, dma_id_arg, vnode_geom_start 
		FROM v_edit_vnode WHERE ST_DWithin(link_start, v_edit_vnode.the_geom, v_link_searchbuffer) ORDER by st_distance(link_start, v_edit_vnode.the_geom) LIMIT 1;
		
		SELECT vnode_id, state, expl_id, sector_id, dma_id, the_geom INTO vnode_id_end, state_arg, expl_id_arg, sector_id_arg, dma_id_arg, vnode_geom_end 
		FROM v_edit_vnode WHERE ST_DWithin(link_end, v_edit_vnode.the_geom, v_link_searchbuffer) ORDER by st_distance(link_end, v_edit_vnode.the_geom) LIMIT 1;


		-- Control init (ony enabled for connec / gully / vnode)
		IF gully_geom_start IS NOT NULL  THEN
			NEW.feature_id=gully_id_start;
			NEW.feature_type='GULLY';
					
		ELSIF connec_geom_start IS NOT NULL THEN
			NEW.feature_id=connec_id_start;
			NEW.feature_type='CONNEC';

		ELSIF vnode_geom_start IS NOT NULL THEN
			NEW.feature_id=vnode_id_start::text;
			NEW.feature_type='VNODE';
					
		ELSIF (connec_geom_start IS NULL) AND (gully_geom_start IS NULL) AND (vnode_geom_start IS NULL) THEN
			NEW.feature_id=NULL;
			NEW.feature_type=NULL;
			--PERFORM audit_function(2014,1116);
		END IF;	

		-- Control init (if more than one link per connec/gully exits)
		-- TO DO

		IF (arc_geom_end IS NOT NULL) AND( node_geom_end IS NULL) and (vnode_geom_end is null) THEN
		

			SELECT arc_id, state, expl_id, sector_id, dma_id, the_geom 
			INTO arc_id_end, state_arg, expl_id_arg, sector_id_arg, dma_id_arg, arc_geom_end FROM v_edit_arc 
			WHERE arc_id=arc_id_end;

			-- Inserting vnode values
			INSERT INTO vnode (vnode_id, state, expl_id, sector_id, dma_id, vnode_type, the_geom) 
			VALUES ((SELECT nextval('vnode_vnode_id_seq')), state_arg, NEW.expl_id, sector_id_arg, dma_id_arg, NEW.feature_type, link_end);			

			-- Inserting link values
			INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom)
			VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, NEW.expl_id, (SELECT currval('vnode_vnode_id_seq')), 'VNODE', TRUE, NEW.state, NEW.the_geom);

			-- Update connec or gully arc_id
			IF gully_geom_start IS NOT NULL  THEN
				UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start	;
				
			ELSIF connec_geom_start IS NOT NULL THEN
				UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start ;
			END IF;

		ELSIF vnode_geom_end IS NOT NULL THEN
				
			INSERT INTO link (link_id,feature_type, feature_id, expl_id, exit_id,  exit_type, userdefined_geom, state, the_geom)
			VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, NEW.expl_id, vnode_id_end, 'VNODE', TRUE,  NEW.state, NEW.the_geom);
					

		ELSIF node_geom_end IS NOT NULL THEN

			-- Inserting link values
			INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom)
			VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, NEW.expl_id, node_id_end, 'NODE', TRUE,  NEW.state, NEW.the_geom);

			-- Update connec or gully arc_id
			IF gully_geom_start IS NOT NULL  THEN
				UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start	;
					
			ELSIF connec_geom_start IS NOT NULL THEN
				UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start;	
			END IF;


		ELSIF connec_geom_end IS NOT NULL THEN
					
			SELECT arc_id INTO arc_id_end FROM connec WHERE connec_id=connec_id_end;
			INSERT INTO link (link_id,feature_type, feature_id, expl_id, exit_id,  exit_type, userdefined_geom, state, the_geom)
			VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, NEW.expl_id, connec_id_end, 'CONNEC', TRUE,  NEW.state, NEW.the_geom);
			UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start;


		ELSIF gully_geom_end IS NOT NULL AND project_type_aux='UD' THEN
				
			SELECT arc_id INTO arc_id_end FROM gully WHERE gully_id=gully_id_end;
			INSERT INTO link (link_id,feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom)
			VALUES (NEW.link_id, NEW.feature_type, NEW.feature_id, NEW.expl_id, gully_id_end, 'GULLY', TRUE,  NEW.state, NEW.the_geom);
			UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start;

		ELSE 
			INSERT INTO link (link_id,feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom)
			VALUES (NEW.link_id, NEW.feature_type, NEW.feature_id, NEW.expl_id, gully_id_end, null, TRUE,  NEW.state, NEW.the_geom);
					
		END IF;
		
		-- Update connec or gully state_type
		IF connec_id_start IS NOT NULL THEN
			-- Update state_type if edit_connect_update_statetype is TRUE
			IF (SELECT ((value::json->>'connec')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
				UPDATE connec SET state_type = (SELECT ((value::json->>'connec')::json->>'state_type')::int2 FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE connec_id=connec_id_start;
			END IF;
		ELSIF gully_id_start IS NOT NULL THEN
			-- Update state_type if edit_connect_update_statetype is TRUE
			IF (SELECT ((value::json->>'gully')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
				UPDATE gully SET state_type = (SELECT ((value::json->>'gully')::json->>'state_type')::int2 FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE gully_id=gully_id_start;
			END IF;
		END IF;

		RETURN NEW;
					
    ELSIF TG_OP = 'UPDATE' THEN

		link_geom_old:=OLD.the_geom;
		link_start_old:=ST_StartPoint(link_geom_old);
		link_end_old:=ST_EndPoint(link_geom_old);
		
		link_geom:=NEW.the_geom;
		link_end:=ST_EndPoint(link_geom);
		link_end:=ST_EndPoint(link_geom);
		
		IF ST_DWithin(link_start_old, link_start,0.001) OR ST_DWithin(link_end_old, link_end,0.001) THEN

		ELSE
			PERFORM audit_function(2016,1116);
		END IF;

		UPDATE link SET userdefined_geom=NEW.userdefined_geom, the_geom = NEW.the_geom, state=NEW.state  WHERE link_id=OLD.link_id;

		IF st_equals (link_geom_old, link_geom) IS FALSE THEN
			UPDATE link SET userdefined_geom=true WHERE link_id=OLD.link_id;	
		END IF;
                
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
	
		IF OLD.exit_type='VNODE' THEN
			SELECT count (*) INTO count_int FROM vnode WHERE vnode_id::text=OLD.exit_id;
			IF count_int = 1 THEN	
				DELETE FROM vnode WHERE vnode_id::text=OLD.exit_id;
			END IF;
		END IF;
		
        DELETE FROM link WHERE link_id = OLD.link_id;
					
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



