/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2910

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_join_virtual(character varying);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_manage_varc(result_id_var character varying)
  RETURNS integer AS
$BODY$

DECLARE

rec_virtual record;
rec_arc record;
arc_id_aux varchar;
node_id1_aux varchar;
node_id2_aux varchar;
fusion_node_aux varchar;
add_length_bool boolean;
length_aux float;
pointArray1 geometry[];
pointArray2 geometry[];
new_arc_geom public.geometry;


BEGIN

	--  Search path
    SET search_path = "SCHEMA_NAME", public;

	-- Loop for the virtual arcs
	FOR rec_virtual IN SELECT * FROM temp_arc WHERE epa_type='VIRTUAL'
	LOOP
		RAISE NOTICE 'rec_virtual %', rec_virtual;

		-- Taking values from inp_virtual arc
		SELECT fusion_node, add_length INTO fusion_node_aux, add_length_bool FROM inp_virtual WHERE arc_id=rec_virtual.arc_id;

		IF fusion_node_aux IS NULL THEN
			fusion_node_aux:=(SELECT node_id FROM temp_node WHERE (node_id=rec_virtual.node_1 AND node_type='JUNCTION') OR (node_id=rec_virtual.node_2 AND node_type='JUNCTION'));
		END IF;

		-- Taking values from the fusion node (as node1)
		FOR rec_arc IN SELECT * FROM temp_arc WHERE node_1=rec_virtual.node_2 AND node_1=fusion_node_aux
		LOOP

			-- Looking for add or not the length of virtual arc to the destination arc
			IF add_length_bool IS TRUE THEN
				length_aux=st_length2d(rec_virtual.the_geom);
			ELSE
				length_aux=0;
			END IF;
	
			-- Making new geometry
			pointArray1 := ARRAY(SELECT (ST_DumpPoints(rec_virtual.the_geom)).geom);
			pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(rec_arc.the_geom)).geom));
			new_arc_geom := ST_MakeLine(pointArray2);
	
		
			-- Deleting features 
			DELETE FROM temp_node WHERE node_id=rec_virtual.node_2;
			DELETE FROM temp_arc WHERE arc_id=rec_virtual.arc_id;

			-- Updating arc
			UPDATE temp_arc SET node_1=rec_virtual.node_1, length=length+length_aux, the_geom=new_arc_geom WHERE arc_id=rec_arc.arc_id;

		END LOOP;
		
		-- Taking values from the fusion node (as node2)
		FOR rec_arc IN SELECT * FROM temp_arc WHERE node_2=rec_virtual.node_1 AND node_2=fusion_node_aux
		LOOP
	
			-- Looking for add or not the length of virtual arc to the destination arc
			IF add_length_bool IS TRUE THEN
				length_aux=st_length2d(rec_virtual.the_geom);
			ELSE
				length_aux=0;
			END IF;
	
			-- Making new geometry
			pointArray1 := ARRAY(SELECT (ST_DumpPoints(rec_virtual.the_geom)).geom);
			pointArray2 := array_cat(ARRAY(SELECT (ST_DumpPoints(rec_arc.the_geom)).geom),pointArray1);
			new_arc_geom := ST_MakeLine(pointArray2);
	
			-- Deleting features 
			DELETE FROM temp_node WHERE node_id=rec_virtual.node_1;
			DELETE FROM temp_arc WHERE arc_id=rec_virtual.arc_id;

			-- Updating arc
			UPDATE temp_arc SET node_2=rec_virtual.node_2, length=length+length_aux, the_geom=new_arc_geom WHERE arc_id=rec_arc.arc_id;

		END LOOP;

	END LOOP;

    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
