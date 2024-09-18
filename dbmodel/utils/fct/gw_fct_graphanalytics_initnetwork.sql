/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_initnetwork()
 RETURNS text
 LANGUAGE plpgsql
AS $function$

/* example

SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector('{"data":{"parameters":{"exploitation":"[1,2]", "MaxMinsectors":0, "checkData": false, "usePsectors":"TRUE", "updateFeature":"TRUE", "updateMinsectorGeom":2 ,"geomParamUpdate":10}}}');

	select * from temp_pgr_node;
	select * from  temp_pgr_arc;
	select * from  temp_pgr_minsector;
	select * from  temp_pgr_connectedcomponents;
	select * from temp_pgr_drivingdistance;

	DROP TABLE IF EXISTS temp_pgr_node;
	DROP TABLE IF EXISTS temp_pgr_arc;
	DROP TABLE IF EXISTS temp_pgr_minsector;
	DROP TABLE IF EXISTS temp_pgr_connectedcomponents;
	DROP TABLE IF EXISTS temp_pgr_drivingdistance;


és un proces auxiliar que es fa servir per macro_minsector, minsector o mapzone que genera les taules temp_pgr_node i temp_pgr_arc
*/

declare

v_project_type text;
v_cost integer=1;
v_reverse_cost integer=1;
v_return_text text;
 

begin
		
	SET search_path = "SCHEMA_NAME", public;
		
	EXECUTE 'select lower(project_type) from sys_version order by "date" desc limit 1'
	INTO v_project_type;
	if v_project_type='ud' then v_reverse_cost=-1; end if;

	insert into temp_pgr_node (pgr_node_id, node_id)
	(SELECT node_id::int, node_id
	FROM 
	(select node_id, state, state_type from node) n
	join value_state_type s on s.id =n.state_type 
	where n.state=1 and s.is_operative =true
	);

	insert into temp_pgr_arc (pgr_arc_id,arc_id, pgr_node_1,pgr_node_2, node_1, node_2, cost, reverse_cost)
	(SELECT a.arc_id::int, a.arc_id, a.node_1::int, a.node_2::int,a.node_1, a.node_2, v_cost,v_reverse_cost
	FROM arc a
	join value_state_type s on s.id =a.state_type 
	where a.state=1 and s.is_operative =true
	and a.node_1 is not null and a.node_2 is not null -- evita el crash de les funccions pgrouting
	);

	v_return_text = '{"Status":"OK"}';

return v_return_text;
end;
$function$
;