/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2772

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics(p_data json)
RETURNS integer AS
$BODY$

/*
--EXAMPLE
SELECT gw_fct_grafanalytics('{"data":{"parameters":{"node":"5100"}}}');

vacuum analyze


--RESULTS
SELECT * FROM anl_graf WHERE fprocesscat_id=99 AND cur_user=current_user
*/

DECLARE
	affected_rows numeric;
	cont1 integer default 0;
	v_nodeid integer;
	v_sum integer = 0;
	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

   	v_nodeid = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'node');
	
	delete FROM anl_arc where cur_user=current_user AND fprocesscat_id=39;
	delete FROM anl_graf where user_name=current_user AND grafclass='FLOWTRACE';

	-- fill the graf table
	insert into anl_graf (grafclass, arc_id, node_1, node_2, water, flag,  user_name) 
	select  'FLOWTRACE', arc.arc_id::integer, node_1::integer, node_2::integer, 0, 0, current_user from arc
	union all
	select  'FLOWTRACE', arc.arc_id::integer, node_2::integer, node_1::integer, 0, 0, current_user from arc;
	
	-- Delete from the graf table all that rows that only exists one time (it means that arc don't have the correct topology)
	DELETE FROM anl_graf WHERE user_name=current_user AND grafclass= 'FLOWTRACE' AND arc_id IN 
	(SELECT a.arc_id FROM (SELECT count(*) AS count, arc_id FROM anl_graf GROUP BY 2 HAVING count(*)=1 ORDER BY 2)a);

	-- init inlets
	UPDATE anl_graf	SET flag=1, water=1 WHERE node_1 = v_nodeid AND anl_graf.user_name=current_user AND grafclass='FLOWTRACE'; 

	-- inundation process
	LOOP
		cont1 = cont1+1;

                update anl_graf n
		set water= 1, flag=n.flag+1
		from v_anl_graf a
		where n.node_1 = a.node_1 
		and n.arc_id = a.arc_id AND n.grafclass='FLOWTRACE';


		GET DIAGNOSTICS affected_rows =row_count;

		exit when affected_rows = 0;
		EXIT when cont1 = 400;

		v_sum = v_sum + affected_rows;

		RAISE NOTICE ' % % %', cont1, affected_rows, v_sum;

	END LOOP;

	-- insert into result table the dry arcs (water=0)
	INSERT INTO anl_arc (fprocesscat_id, arc_id, the_geom, descript)
	SELECT DISTINCT ON (a.arc_id) 39, a.arc_id, the_geom, 'Arcs disconnected'  
		FROM anl_graf a
		JOIN arc b ON a.arc_id=b.arc_id::integer
		WHERE grafclass='FLOWTRACE'
		GROUP BY a.arc_id, user_name, the_geom
		having max(water) = 0 and user_name=current_user;

RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
