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
	
record_node "SCHEMA_NAME".rpt_inp_node%ROWTYPE;
record_arc1 "SCHEMA_NAME".rpt_inp_arc%ROWTYPE;
record_arc2 "SCHEMA_NAME".rpt_inp_arc%ROWTYPE;
record_new_arc "SCHEMA_NAME".rpt_inp_arc%ROWTYPE;
node_diameter double precision;
nodarc_geometry geometry;
nodarc_node_1_geom geometry;
nodarc_node_2_geom geometry;
arc_reduced_geometry geometry;
node_id_aux text;
num_arcs integer;
shortpipe_record record;
to_arc_aux text;
arc_aux text;
node_1_aux text;
node_2_aux text;
geom_aux geometry;
rec_options record;
rec_flowreg record;
old_node_id text;
record_arc record;
    

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

--  Looking for parameters
    SELECT * INTO rec_options FROM inp_options;
    
--  Move valves to arc
    RAISE NOTICE 'Starting process of nodarcs';

    FOR rec_flowreg IN 
	SELECT DISTINCT ON (node_id, to_arc) node_id,  to_arc, max(flwreg_length) AS flwreg_length, flw_type FROM 
	(SELECT rpt_inp_node.node_id, to_arc, flwreg_length, 'ori'::text as flw_type FROM inp_flwreg_orifice JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_orifice.node_id JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var
		UNION 
	SELECT DISTINCT rpt_inp_node.node_id,  to_arc, flwreg_length, 'out'::text as flw_type FROM inp_flwreg_outlet JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_outlet.node_id JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var			
		UNION 
	SELECT DISTINCT rpt_inp_node.node_id,  to_arc, flwreg_length, 'pump'::text as flw_type FROM inp_flwreg_pump JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_pump.node_id JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var			
		UNION 
	SELECT DISTINCT rpt_inp_node.node_id,  to_arc, flwreg_length, 'weir'::text as flw_type FROM inp_flwreg_weir JOIN rpt_inp_node ON rpt_inp_node.node_id=inp_flwreg_weir.node_id JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_node.sector_id WHERE result_id=result_id_var)a
	GROUP BY node_id, to_arc, flw_type
	ORDER BY node_id, to_arc
				
	LOOP
		RAISE NOTICE 'peric %, %', rec_flowreg.node_id, rec_flowreg.to_arc;
		-- Getting data from node
		SELECT * INTO record_node FROM rpt_inp_node WHERE node_id = rec_flowreg.node_id AND result_id=result_id_var;

	
		-- Getting data from arc
		SELECT arc_id, node_1, node_2, the_geom INTO arc_aux, node_1_aux, node_2_aux, geom_aux FROM rpt_inp_arc WHERE arc_id=rec_flowreg.to_arc AND result_id=result_id_var ;
		IF arc_aux IS NULL THEN	

		ELSE

			IF node_2_aux=rec_flowreg.node_id THEN
				RETURN audit_function(2038,2240, arc_aux);
			ELSE 
				-- Create the extrem nodes of the new nodarc
				nodarc_node_1_geom := ST_StartPoint(geom_aux);
				nodarc_node_2_geom := ST_LineInterpolatePoint(geom_aux, (rec_flowreg.flwreg_length / ST_Length(geom_aux)));

				-- Correct old arc geometry
				arc_reduced_geometry := ST_LineSubstring(geom_aux, (rec_flowreg.flwreg_length / ST_Length(geom_aux)),1);
				
				IF ST_GeometryType(arc_reduced_geometry) != 'ST_LineString' THEN
					RETURN audit_function(2040,2240,concat(record_arc1.arc_id,',',ST_GeometryType(arc_reduced_geometry)));
				END IF;
  
				-- Create new arc geometry
				nodarc_geometry := ST_MakeLine(nodarc_node_1_geom, nodarc_node_2_geom);

				-- Values to insert into arc table
				record_new_arc.arc_id := concat(node_1_aux,rec_flowreg.to_arc);   
				record_new_arc.flw_code := concat(node_1_aux,'_',rec_flowreg.to_arc); 
				record_new_arc.node_1:= record_node.node_id;
				record_new_arc.node_2:= concat(node_1_aux,'_',rec_flowreg.to_arc);  
				record_new_arc.arc_type:= 'NODE2ARC';
				record_new_arc.arccat_id := 'MAINSTREAM';
				record_new_arc.epa_type := 'IN PROGRESS';
				record_new_arc.sector_id := record_node.sector_id;
				record_new_arc.state := record_node.state;
				record_new_arc.state_type := record_node.state_type;
				record_new_arc.expl_id := record_node.expl_id;
				record_new_arc.annotation := record_node.annotation;
				
				-- record_new_arc.length := ST_length2d(nodarc_geometry);
				record_new_arc.the_geom := nodarc_geometry;
      
				-- Inserting new arc into arc table
				RAISE NOTICE 'nodarc_geometry %',nodarc_geometry;
				INSERT INTO rpt_inp_arc (result_id, arc_id, flw_code, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, expl_id, the_geom)
				VALUES(result_id_var, record_new_arc.arc_id, record_new_arc.flw_code, record_new_arc.node_1, record_new_arc.node_2, record_new_arc.arc_type, record_new_arc.arccat_id, 
				record_new_arc.epa_type, record_new_arc.sector_id, record_new_arc.state, record_new_arc.state_type, record_new_arc.annotation, record_new_arc.length, record_new_arc.expl_id, record_new_arc.the_geom);
				RAISE NOTICE 'Inserted nodarc %', record_new_arc.arc_id;

				-- Inserting new node into node table
				record_node.epa_type := 'JUNCTION';
				record_node.the_geom := nodarc_node_1_geom;
				record_node.node_id := concat(node_1_aux,'_',rec_flowreg.to_arc);
				record_node.y0=(SELECT value::float FROM config_param_user WHERE parameter='epa_junction_y0_vdefault');

	
				INSERT INTO rpt_inp_node (result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, expl_id, the_geom) 
				VALUES(result_id_var, record_node.node_id, record_node.top_elev, (record_node.top_elev-record_node.elev), record_node.elev, record_node.node_type, record_node.nodecat_id, record_node.epa_type, 
				record_node.sector_id, record_node.state, record_node.state_type, record_node.annotation, record_node.y0, record_node.ysur, record_node.apond, record_node.expl_id, nodarc_node_2_geom);
				RAISE NOTICE 'Inserted juncion %', record_node.node_id;

				-- Updating the reduced arc
				UPDATE rpt_inp_arc SET node_1=record_node.node_id, the_geom = arc_reduced_geometry, length=length-rec_flowreg.flwreg_length WHERE arc_id = arc_aux  AND result_id=result_id_var; 	
			END IF;
		END IF;
    END LOOP;



    RETURN 1;


		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_nod2arc_geom(character varying)
  OWNER TO postgres;
