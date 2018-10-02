/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_utils_reverse_links()
  RETURNS void AS
$BODY$
DECLARE

	arc_geom_end public.geometry;
	arc_id_end varchar;

	node_geom_end public.geometry;
	node_id_end varchar;

	gully_geom_start public.geometry;
	gully_geom_end public.geometry;
	gully_id_start varchar;
	gully_id_end varchar;

	connec_geom_start public.geometry;
	connec_geom_end public.geometry;
	connec_id_start varchar;	
	connec_id_end varchar;

	link_buffer_aux double precision;
	
	link_end public.geometry;	
	
	vnode_geom_start public.geometry;
	vnode_geom_end public.geometry;
	vnode_id_start varchar;	
	vnode_id_end varchar;
	
	project_type_aux varchar;
	rec_link record;
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
        SELECT arc_searchnodes into link_buffer_aux FROM config;
        
        SELECT wsoftware into project_type_aux FROM version LIMIT 1;
        
UPDATE link SET userdefined_geom='False' WHERE exit_type='CONNEC';

FOR rec_link IN SELECT * FROM v_edit_link WHERE exit_type='CONNEC' LIMIT 10 LOOP
	
	UPDATE link SET the_geom=ST_Reverse(rec_link.the_geom),userdefined_geom='True', exit_type=NULL, exit_id=NULL, feature_type='CONNEC' WHERE link.link_id=rec_link.link_id;
	UPDATE link SET feature_id=connec_id FROM connec where st_dwithin(connec.the_geom,ST_StartPoint(link.the_geom),link_buffer_aux) and link.link_id=rec_link.link_id returning connec_id into connec_id_start ;


	link_end:=ST_StartPoint(rec_link.the_geom);-- FROM link where link.link_id=rec_link.link_id;

		-- arc as end point
		SELECT arc_id, the_geom INTO arc_id_end, arc_geom_end FROM v_edit_arc WHERE ST_DWithin(link_end, v_edit_arc.the_geom, link_buffer_aux) 
		ORDER by st_distance(link_end, v_edit_arc.the_geom) LIMIT 1;
		
		-- node as end point
		SELECT node_id, the_geom INTO node_id_end, node_geom_end FROM v_edit_node WHERE ST_DWithin(link_end, v_edit_node.the_geom, link_buffer_aux) 
		ORDER by st_distance(link_end, v_edit_node.the_geom) LIMIT 1;
		
		-- connec as init/end point
		
		SELECT connec_id, the_geom INTO connec_id_end, connec_geom_end FROM v_edit_connec WHERE ST_DWithin(link_end, v_edit_connec.the_geom,link_buffer_aux) 
		ORDER by st_distance(link_end, v_edit_connec.the_geom) LIMIT 1;

		--gully as init/end point
		IF project_type_aux='UD' then
			
			SELECT gully_id, the_geom INTO gully_id_end, gully_geom_end FROM v_edit_gully WHERE ST_DWithin(link_end, v_edit_gully.the_geom,link_buffer_aux) 
			ORDER by st_distance(link_end, v_edit_gully.the_geom) LIMIT 1;
		END IF;
				
		-- vnode as init/end point		
		SELECT vnode_id, the_geom INTO vnode_id_end,  vnode_geom_end 
		FROM v_edit_vnode WHERE ST_DWithin(link_end, v_edit_vnode.the_geom, link_buffer_aux) ORDER by st_distance(link_end, v_edit_vnode.the_geom) LIMIT 1;
	
		IF vnode_geom_end IS NOT NULL THEN
				
			UPDATE link SET exit_id=vnode_id_end,  exit_type='VNODE' WHERE link.link_id=rec_link.link_id;
			SELECT arc_id INTO arc_id_end FROM vnode,arc WHERE st_dwithin(vnode.the_geom,arc.the_geom,link_buffer_aux) and vnode_id=vnode_id_end::integer;
			UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start;
			
		ELSIF node_geom_end IS NOT NULL THEN

			-- Inserting link values
			UPDATE link SET exit_id=node_id_end,  exit_type='NODE' WHERE link.link_id=rec_link.link_id;
			-- Update connec or gully arc_id
			IF gully_geom_start IS NOT NULL  THEN
				UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start	;
					
			ELSIF connec_geom_start IS NOT NULL THEN
				UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start;	
			END IF;
			
		ELSIF connec_geom_end IS NOT NULL THEN		
			SELECT arc_id INTO arc_id_end FROM connec WHERE connec_id=connec_id_end;
			UPDATE link SET exit_id=connec_id_end,  exit_type='CONNEC' where link.link_id=rec_link.link_id ;
			UPDATE v_edit_connec SET arc_id=arc_id_end WHERE connec_id=connec_id_start;


		ELSIF gully_geom_end IS NOT NULL AND project_type_aux='UD' THEN
				
			SELECT arc_id INTO arc_id_end FROM gully WHERE gully_id=gully_id_end;
			INSERT INTO link (exit_id, exit_type)
			VALUES ( gully_id_end, 'GULLY');
			
			UPDATE v_edit_gully SET arc_id=arc_id_end WHERE gully_id=gully_id_start;
		END IF;

END LOOP;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
