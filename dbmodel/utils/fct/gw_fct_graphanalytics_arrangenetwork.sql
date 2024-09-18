/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_arrangenetwork()
 RETURNS text
 LANGUAGE plpgsql
AS $function$

/* example
SELECT gw_fct_graphanalytics_arrangenetwork(); 
és un proces auxiliar que es fa servir per macro_minsector, minsector o mapzone que genera arcs de més
*/

declare

v_record record;
v_node_id integer=0;
v_arc_id integer=0;
v_id integer=0;
v_return_text text;


begin
	
	SET search_path = "SCHEMA_NAME", public;

	EXECUTE 'select max (pgr_node_id) from temp_pgr_node'
	INTO v_node_id;
	EXECUTE 'select max (pgr_arc_id) from temp_pgr_arc'
	INTO v_arc_id;
	if v_node_id>v_arc_id then v_id=v_node_id;
	else v_id=v_arc_id;
	end if;

	-- desconnectar en els nodes amb modif=true els arcs amb modif=true; es crea un arc nou  N_new->N_original amb el cost i reverse cost de l'arc
	FOR v_record IN 
		SELECT  n.pgr_node_id,n.graph_delimiter, a.pgr_arc_id,a.pgr_node_1,a.pgr_node_2, a.cost, a.reverse_cost
		FROM temp_pgr_node n 
		join temp_pgr_arc a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
		where n.modif=true and a.modif=true
	LOOP
		v_id=v_id+2;
		insert into temp_pgr_node(pgr_node_id, node_id,modif,graph_delimiter) values (v_id, v_record.pgr_node_id::text,false,v_record.graph_delimiter);
		if v_record.pgr_node_id=v_record.pgr_node_1 then
			update temp_pgr_arc set pgr_node_1=v_id 
			where pgr_arc_id=v_record.pgr_arc_id;
			insert into temp_pgr_arc(pgr_arc_id, arc_id, pgr_node_1,pgr_node_2,node_1,node_2, modif,graph_delimiter, cost, reverse_cost) 
			values (v_id+1, v_record.pgr_arc_id::text,v_record.pgr_node_id, v_id, v_record.pgr_node_id,v_record.pgr_node_id, false,v_record.graph_delimiter, v_record.cost, v_record.reverse_cost);
		else
			update temp_pgr_arc set pgr_node_2=v_id 
			where pgr_arc_id=v_record.pgr_arc_id;
			insert into temp_pgr_arc(pgr_arc_id, arc_id, pgr_node_1,pgr_node_2,node_1,node_2, modif,graph_delimiter, cost, reverse_cost) 
			values (v_id+1, v_record.pgr_arc_id::text,v_id, v_record.pgr_node_id, v_record.pgr_node_id,v_record.pgr_node_id, false,v_record.graph_delimiter, v_record.cost, v_record.reverse_cost);
		end if;
		update temp_pgr_arc set cost=1, reverse_cost=1 where pgr_arc_id=v_record.pgr_arc_id; -- el nou arc té el cost i reverse cost
	END LOOP;

	v_return_text = '{"Status":"OK"}';

return v_return_text;
end;
$function$
;