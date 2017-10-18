
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_link()
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

	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
        man_table:= TG_ARGV[0];

    -- control of project type
    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
     
			
        -- link ID
			IF (NEW.link_id IS NULL) THEN
				--PERFORM setval('urn_id_seq', gw_fct_urn()+1,true);
				NEW.link_id:= (SELECT nextval('urn_id_seq'));
			END IF;			
		

		
				link_geom:=NEW.the_geom;
				link_start:=ST_StartPoint(link_geom);
				link_end:=ST_EndPoint(link_geom);
				
				SELECT arc_id, the_geom INTO arc_id_end, arc_geom_end FROM v_edit_arc WHERE ST_DWithin(link_end, v_edit_arc.the_geom,0.001) LIMIT 1;
				
				SELECT node_id, the_geom INTO node_id_end, node_geom_end FROM v_edit_node WHERE ST_DWithin(link_end, v_edit_node.the_geom,0.001) LIMIT 1;
				
				SELECT connec_id, state, the_geom INTO connec_id_start, state_start, connec_geom_start FROM v_edit_connec WHERE ST_DWithin(link_start, v_edit_connec.the_geom,0.001) LIMIT 1;
				SELECT connec_id, the_geom INTO connec_id_end, connec_geom_end FROM v_edit_connec WHERE ST_DWithin(link_end, v_edit_connec.the_geom,0.001) LIMIT 1;

				IF project_type_aux='UD' then
					SELECT gully_id, state, the_geom INTO gully_id_start, state_start, gully_geom_start FROM v_edit_gully WHERE ST_DWithin(link_start, v_edit_gully.the_geom,0.001) LIMIT 1;
					SELECT gully_id, the_geom INTO gully_id_end, gully_geom_end FROM v_edit_gully WHERE ST_DWithin(link_end, v_edit_gully.the_geom,0.001) LIMIT 1;
				END IF;
				
				SELECT vnode_id, the_geom INTO vnode_id_start, vnode_geom_start FROM v_edit_vnode WHERE ST_DWithin(link_start, v_edit_vnode.the_geom,0.001) LIMIT 1;
				SELECT vnode_id, state, expl_id, sector_id, dma_id, the_geom INTO vnode_id_end, state_arg, expl_id_arg, sector_id_arg, dma_id_arg, vnode_geom_end FROM v_edit_vnode WHERE ST_DWithin(link_end, v_edit_vnode.the_geom,0.001) LIMIT 1;


				-- Identifing downstream arcs in case of node_id end
				IF node_id_end IS NOT NULL THEN
					SELECT arc_id INTO arc_id_end FROM v_edit_arc WHERE node_1=node_id_end LIMIT 1;
				END IF;	


				-- Control init (connec / gully exists)
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
					RAISE EXCEPTION 'You need to connec the link to one connec/gully';
				END IF;	

		
				-- Control init (if more than one link per connec/gully exits)
				-- TO DO



				-- Control exit feature type
				IF (arc_geom_end IS NOT NULL) AND( node_geom_end IS NULL) THEN

				SELECT arc_id, state, expl_id, sector_id, dma_id, the_geom 
				INTO arc_id_end, state_arg, expl_id_arg, sector_id_arg, dma_id_arg, arc_geom_end FROM v_edit_arc 
				WHERE arc_id=arc_id_end;

					-- Inserting vnode values
					INSERT INTO vnode (vnode_id, state, expl_id, sector_id, dma_id, vnode_type, the_geom) 
					VALUES ((SELECT nextval('urn_id_seq')), state_arg, 1, sector_id_arg, dma_id_arg, NEW.feature_type, link_end);			

					-- Inserting link values
					INSERT INTO link (link_id, feature_type, feature_id, exit_id, exit_type, userdefined_geom, state, the_geom)
					VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, (SELECT currval('urn_id_seq')), 'VNODE', TRUE, state_start, NEW.the_geom);

					-- Update connec or gully arc_id
					IF gully_geom_start IS NOT NULL  THEN
						UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start	;
					
					ELSIF connec_geom_start IS NOT NULL THEN
						UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start ;
					END IF;

				ELSIF node_geom_end IS NOT NULL THEN

					-- Inserting link values
					INSERT INTO link (link_id, feature_type, feature_id, exit_id, exit_type, userdefined_geom, state, the_geom)
					VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, node_id_end, 'NODE', TRUE, state_start, NEW.the_geom);

					-- Update connec or gully arc_id
					IF gully_geom_start IS NOT NULL  THEN
						UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start	;
					
					ELSIF connec_geom_start IS NOT NULL THEN
						UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start;	
					END IF;


				ELSIF connec_geom_end IS NOT NULL THEN
					
					SELECT arc_id INTO arc_id_end FROM connec WHERE connec_id=connec_id_end;
					INSERT INTO link (link_id,feature_type, feature_id, exit_id,  exit_type, userdefined_geom, state, the_geom)
					VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, connec_id_end, 'CONNEC', TRUE, state_start, NEW.the_geom);
					UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start;


				ELSIF vnode_geom_end IS NOT NULL THEN
				
					INSERT INTO link (link_id,feature_type, feature_id, exit_id,  exit_type, userdefined_geom, state, the_geom)
					VALUES (NEW.link_id,  NEW.feature_type, NEW.feature_id, vnode_id_end, 'VNODE', TRUE, state_start, NEW.the_geom);
					

				ELSIF gully_geom_end IS NOT NULL THEN
				
					SELECT arc_id INTO arc_id_end FROM connec WHERE gully_id=gully_id_end;
					INSERT INTO link (link_id,feature_type, feature_id, exit_id, exit_type, userdefined_geom, state, the_geom)
					VALUES (NEW.link_id, NEW.feature_type, NEW.feature_id, gully_id_end, 'GULLY', TRUE, state_start, NEW.the_geom);
					UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start;
				
					
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
			RAISE EXCEPTION 'Is not enabled to modify the start/end point of link. If you are looking to reconnect the features, please delete this link and draw a new one';
		END IF;

		UPDATE link SET userdefined_geom=NEW.userdefined_geom, state=NEW.state  WHERE link_id=OLD.link_id;

		IF OLD.the_geom IS DISTINCT FROM NEW.the_geom THEN
			UPDATE link SET userdefined_geom=NEW.userdefined_geom, the_geom = NEW.the_geom WHERE link_id=OLD.link_id;	
		END IF;
                
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM link WHERE link_id = OLD.link_id;
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER IF EXISTS gw_trg_edit_link ON "SCHEMA_NAME"."v_edit_link";
CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_link FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_link();




