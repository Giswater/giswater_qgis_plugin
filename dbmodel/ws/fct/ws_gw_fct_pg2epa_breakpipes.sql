/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3020

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_breakpipes(result_id_var character varying)  RETURNS json AS 
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_pg2epa_breakpipes('r1')

*/

DECLARE

v_total double precision = 0;
v_maxlength json;
v_breaklegth double precision = 10;
v_removevnodebuffer double precision = 1;
v_count integer = 0;
i integer = 0;
rec_arc record;

BEGIN
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- set sequence with value of vnode sequences in order to create vnode correlatives to do not crash epanet
	PERFORM setval('SCHEMA_NAME.temp_table_id_seq', (SELECT max(vnode_id) FROM temp_link), true);
	
	-- get values
	v_maxlength = (SELECT value::json->>'breakPipes' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user);
	v_breaklegth = v_maxlength::json->>'maxLength';
	v_removevnodebuffer = v_maxlength::json->>'removeVnodeBuffer';

	-- profilactic control
	IF v_breaklegth = NULL THEN v_breaklegth = 1000; END IF;
	
	-- count
	SELECT count(*) INTO v_count FROM (SELECT arc_id, v_breaklegth/(st_length(the_geom)+0.001) as partial, the_geom  FROM temp_arc)a  WHERE partial < 1;

	-- insert into vnode table with state  = 0
	FOR rec_arc IN EXECUTE ' SELECT * FROM (SELECT arc_id, '||v_breaklegth||'/(st_length(the_geom)+0.001) as partial, the_geom  FROM temp_arc)a  WHERE partial < 1'
	LOOP
		-- counter
		i = i+1;
		RAISE NOTICE 'Counter % / %', i, v_count;
		v_total = 0;
		
		LOOP
			EXIT WHEN v_total > 1;

			INSERT INTO temp_table(fid, geom_point)
			SELECT 150, ST_LineInterpolatePoint(rec_arc.the_geom, v_total);
			v_total = v_total + rec_arc.partial;
		END LOOP;
				
	END LOOP;

	-- delete those are overlaped with real vnodes
	UPDATE temp_table a SET fid = 296 FROM temp_link WHERE st_dwithin(st_endpoint(the_geom), geom_point, v_removevnodebuffer);
	UPDATE temp_table a SET fid = 296 FROM temp_node WHERE st_dwithin((the_geom), geom_point, v_removevnodebuffer);
	DELETE FROM temp_table WHERE fid = 296;

RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;