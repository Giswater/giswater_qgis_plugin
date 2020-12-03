/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2240

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_nod2arc_geom(character varying);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_nod2arc_geom(result_id_var character varying)
  RETURNS integer AS
$BODY$

DECLARE
	
rec_node record;
rec_arc1 record;
rec_arc2 record;
rec_arc record;
rec_new_arc record;
rec_flowreg record;

v_nodarc_geom geometry;
v_nodarc_node_1_geom geometry;
v_nodarc_node_2_geom geometry;
v_arc_reduced_geom geometry;
v_arc text;
v_node_1 text;
v_node_2 text;
v_geom geometry;
v_node_yinit double precision;
    

BEGIN

	--  Search path
    SET search_path = "SCHEMA_NAME", public;
   
	--  Move valves to arc
    RAISE NOTICE 'Starting process of nodarcs';
	
	-- setting record_new_arc
	SELECT * INTO rec_new_arc FROM temp_arc LIMIT 1;

    FOR rec_flowreg IN 
	SELECT DISTINCT ON (node_id, to_arc) node_id,  to_arc, max(flwreg_length) AS flwreg_length, flw_type FROM 
	(SELECT temp_node.node_id, to_arc, flwreg_length, 'ori'::text as flw_type FROM inp_flwreg_orifice JOIN temp_node ON temp_node.node_id=inp_flwreg_orifice.node_id 
	JOIN selector_sector ON selector_sector.sector_id=temp_node.sector_id
		UNION 
	SELECT DISTINCT temp_node.node_id,  to_arc, flwreg_length, 'out'::text as flw_type FROM inp_flwreg_outlet JOIN temp_node ON temp_node.node_id=inp_flwreg_outlet.node_id 
	JOIN selector_sector ON selector_sector.sector_id=temp_node.sector_id
		UNION 
	SELECT DISTINCT temp_node.node_id,  to_arc, flwreg_length, 'pump'::text as flw_type FROM inp_flwreg_pump JOIN temp_node ON temp_node.node_id=inp_flwreg_pump.node_id 
	JOIN selector_sector ON selector_sector.sector_id=temp_node.sector_id
		UNION 
	SELECT DISTINCT temp_node.node_id,  to_arc, flwreg_length, 'weir'::text as flw_type FROM inp_flwreg_weir JOIN temp_node ON temp_node.node_id=inp_flwreg_weir.node_id 
	JOIN selector_sector ON selector_sector.sector_id=temp_node.sector_id)a
	GROUP BY node_id, to_arc, flw_type
	ORDER BY node_id, to_arc
				
	LOOP
		RAISE NOTICE 'peric %, %', rec_flowreg.node_id, rec_flowreg.to_arc;
		-- Getting data from node
		SELECT * INTO rec_node FROM temp_node WHERE node_id = rec_flowreg.node_id;

	
		-- Getting data from arc
		SELECT arc_id, node_1, node_2, the_geom INTO v_arc, v_node_1, v_node_2, v_geom FROM temp_arc WHERE arc_id=rec_flowreg.to_arc;
		IF v_arc IS NULL THEN	

		ELSE

			IF v_node_2=rec_flowreg.node_id THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2038", "function":"2240","debug_msg":"'||v_arc||'"}}$$);';
				
			ELSE 
				-- Create the extrem nodes of the new nodarc
				v_nodarc_node_1_geom := ST_StartPoint(v_geom);
				v_nodarc_node_2_geom := ST_LineInterpolatePoint(v_geom, (rec_flowreg.flwreg_length / ST_Length(v_geom)));

				-- Correct old arc geometry
				v_arc_reduced_geom := ST_LineSubstring(v_geom, (rec_flowreg.flwreg_length / ST_Length(v_geom)),1);
				
				IF ST_GeometryType(v_arc_reduced_geom) != 'ST_LineString' THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"2040", "function":"2240","debug_msg":"'||concat(rec_arc1.arc_id,',',ST_GeometryType(v_arc_reduced_geom))||'"}}$$);';
				END IF;
  
				-- Create new arc geometry
				v_nodarc_geom := ST_MakeLine(v_nodarc_node_1_geom, v_nodarc_node_2_geom);

				-- Values to insert into arc table
				rec_new_arc.arc_id := concat(v_node_1,rec_flowreg.to_arc);   
				rec_new_arc.flw_code := concat(v_node_1,'_',rec_flowreg.to_arc); 
				rec_new_arc.node_1:= rec_node.node_id;
				rec_new_arc.node_2:= concat(v_node_1,'_',rec_flowreg.to_arc);  
				rec_new_arc.arc_type:= 'NODE2ARC';
				rec_new_arc.arccat_id := 'MAINSTREAM';
				rec_new_arc.epa_type := 'IN PROGRESS';
				rec_new_arc.sector_id := rec_node.sector_id;
				rec_new_arc.state := rec_node.state;
				rec_new_arc.state_type := rec_node.state_type;
				rec_new_arc.expl_id := rec_node.expl_id;
				rec_new_arc.annotation := rec_node.annotation;
				
				-- rec_new_arc.length := ST_length2d(v_nodarc_geom);
				rec_new_arc.the_geom := v_nodarc_geom;
      
				-- Inserting new arc into arc table
				RAISE NOTICE 'v_nodarc_geom %',v_nodarc_geom;
				INSERT INTO temp_arc (result_id, arc_id, flw_code, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, expl_id, the_geom)
				VALUES(result_id_var, rec_new_arc.arc_id, rec_new_arc.flw_code, rec_new_arc.node_1, rec_new_arc.node_2, rec_new_arc.arc_type, rec_new_arc.arccat_id, 
				rec_new_arc.epa_type, rec_new_arc.sector_id, rec_new_arc.state, rec_new_arc.state_type, rec_new_arc.annotation, rec_new_arc.length, rec_new_arc.expl_id, rec_new_arc.the_geom);
				RAISE NOTICE 'Inserted nodarc %', rec_new_arc.arc_id;

				-- Inserting new node into node table
				rec_node.epa_type := 'JUNCTION';
				rec_node.the_geom := v_nodarc_node_1_geom;
				rec_node.node_id := concat(v_node_1,'_',rec_flowreg.to_arc);
				v_node_yinit =(SELECT value::float FROM config_param_user WHERE parameter='epa_junction_y0_vdefault' AND cur_user=current_user);
				IF v_node_yinit IS NULL THEN v_node_yinit = 0; END IF;

	
				INSERT INTO temp_node (result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, expl_id, the_geom) 
				VALUES(result_id_var, rec_node.node_id, rec_node.top_elev, (rec_node.top_elev-rec_node.elev), rec_node.elev, rec_node.node_type, rec_node.nodecat_id, rec_node.epa_type, 
				rec_node.sector_id, rec_node.state, rec_node.state_type, rec_node.annotation, v_node_yinit, rec_node.ysur, rec_node.apond, rec_node.expl_id, v_nodarc_node_2_geom);
				RAISE NOTICE 'Inserted juncion %', rec_node.node_id;

				-- Updating the reduced arc
				UPDATE temp_arc SET node_1=rec_node.node_id, the_geom = v_arc_reduced_geom, length=length-rec_flowreg.flwreg_length WHERE arc_id = v_arc;
			END IF;
		END IF;
    END LOOP;

    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
