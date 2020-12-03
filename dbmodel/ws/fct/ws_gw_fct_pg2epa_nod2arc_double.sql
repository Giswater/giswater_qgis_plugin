/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2778
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_nod2arc_double(v_result varchar)  RETURNS integer 
AS $BODY$

/*example
select SCHEMA_NAME.gw_fct_pg2epa_nod2arc_double ('v41')
*/

DECLARE

v_query_text text;
v_arc_id text;
v_node_1 text;
v_geom	public.geometry;
v_record record;
v_record_a1	record;
v_record_a2	record;
v_curve	text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	v_query_text = 'SELECT temp_arc.arc_id, temp_arc.node_1, the_geom, curve_id FROM temp_arc
			JOIN inp_pump a ON concat(node_id,''_n2a'')=arc_id
			JOIN inp_curve b ON b.id=a.curve_id
			WHERE epa_type=''PUMP'' AND isdoublen2a IS TRUE';			

	FOR v_arc_id, v_node_1, v_geom, v_curve IN EXECUTE v_query_text
	LOOP
		-- New node
		SELECT * INTO v_record FROM temp_node WHERE node_id = v_node_1;
		v_record.node_id = concat (reverse(substring(reverse(v_record.node_id),2)), '3');
		v_record.the_geom := ST_LineInterpolatePoint(v_geom, 0.5);
		INSERT INTO temp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, the_geom, expl_id, pattern_id)
		VALUES (v_record.result_id, v_record.node_id, v_record.elevation, v_record.elev, v_record.node_type, v_record.nodecat_id, v_record.epa_type, 
		v_record.sector_id, v_record.state, v_record.state_type, v_record.annotation, v_record.demand, v_record.the_geom, v_record.expl_id, v_record.pattern_id);

		-- New arc (PRV)
		SELECT * INTO v_record_a2 FROM temp_arc WHERE arc_id = v_arc_id;
		v_record_a2.arc_id = concat (v_record_a2.arc_id, '_4');
		v_record_a2.arc_type =  'BINODE2ARC-PRV';
		v_record_a2.epa_type =  'VALVE';
		v_record_a2.node_2 = v_record.node_id;
		v_record_a2.length = v_record_a2.length/2;
		v_record_a2.the_geom := ST_LineSubstring(v_record_a2.the_geom,0.5,1);
		v_record_a2.addparam = concat('{"curve_id":"","pressure":"0" }');
		INSERT INTO temp_arc	(result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, the_geom, expl_id, flw_code, addparam)
		VALUES(v_record_a2.result_id, v_record_a2.arc_id, v_record_a2.node_1, v_record_a2.node_2, v_record_a2.arc_type, v_record_a2.arccat_id, v_record_a2.epa_type, v_record_a2.sector_id, v_record_a2.state, v_record_a2.state_type, 
		v_record_a2.annotation, v_record_a2.diameter, v_record_a2.roughness, v_record_a2.length, v_record_a2.status, v_record_a2.the_geom, v_record_a2.expl_id, v_record_a2.flw_code, v_record_a2.addparam);

		-- New arc (GPV)
		SELECT * INTO v_record_a1 FROM temp_arc WHERE arc_id = v_arc_id;
		v_record_a1.arc_id = concat (v_record_a1.arc_id, '_5');
		v_record_a1.arc_type =  'BINODE2ARC-GPV';
		v_record_a1.epa_type =  'VALVE';
		v_record_a1.node_1 = v_record.node_id;
		v_record_a1.length = v_record_a1.length/2;
		v_record_a1.the_geom := ST_LineSubstring(v_record_a1.the_geom,0,0.5);
		v_record_a1.addparam = concat('{"curve_id":"',v_curve,'"}');
		INSERT INTO temp_arc	(result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, the_geom, expl_id, flw_code, addparam)
		VALUES(v_record_a1.result_id, v_record_a1.arc_id, v_record_a1.node_1, v_record_a1.node_2, v_record_a1.arc_type, v_record_a1.arccat_id, v_record_a1.epa_type, v_record_a1.sector_id, v_record_a1.state, v_record_a1.state_type, 
		v_record_a1.annotation, v_record_a1.diameter, v_record_a1.roughness, v_record_a1.length, v_record_a1.status, v_record_a1.the_geom, v_record_a1.expl_id, v_record_a1.flw_code, v_record_a1.addparam);

		-- Deleting old arc
		DELETE FROM temp_arc WHERE arc_id = v_arc_id;

	END LOOP;

	RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
