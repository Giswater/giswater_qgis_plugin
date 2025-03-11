/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

This code of mapzones have been provide by Claudia Dragoste
*/


CREATE OR REPLACE FUNCTION amsa_fct_pgr_minsector()
 RETURNS text
 LANGUAGE plpgsql
AS $function$

/* example
SELECT amsa_fct_pgr_minsector(); 

Consulta per visualitzar els arcs  amb les seves geometries:

select a.arc_id, p.mapzone_id, p.macro_minsector_id, p.minsector_id, a.the_geom 
from amsa_pgr_arc p
join 
(select arc_id, the_geom from arc) a on p.pgr_arc_id =a.arc_id::int;

Consulta per visualitzar els nodes amb les seves geometries :

select n.node_id,  p.mapzone_id, p.macro_minsector_id, p.minsector_id, n.the_geom from amsa_pgr_node p
join
(select node_id, the_geom from node) n on p.pgr_node_id =n.node_id::int;

*/

declare

v_query text;
v_record record;
v_record_id integer=0;
v_arc_id integer=0;
v_id integer=0;
v_i integer;
v_return_text text;
v_field_name text;
v_affectrow int;

 

begin
	
--SET search_path = "ws_github_full", public;

-- no es guarda la geometria, s'ha de fer un join amb la taula node per recuperar-la per els resultats
	
truncate amsa_pgr_node;
truncate amsa_pgr_arc;

insert into amsa_pgr_node (pgr_node_id, node_id)
(SELECT node_id::int, node_id
 FROM node n
 join value_state_type s on s.id =n.state_type 
 where n.state=1 and s.is_operative =true
);

insert into amsa_pgr_arc (pgr_arc_id,arc_id, pgr_node_1,pgr_node_2, node_1, node_2)
(SELECT a.arc_id::int, a.arc_id, a.node_1::int, a.node_2::int,a.node_1, a.node_2
 FROM arc a
 join value_state_type s on s.id =a.state_type 
 where a.state=1 and s.is_operative =true
  and a.node_1 is not null and a.node_2 is not null -- evita el crash de pgr_connectedComponents
);

-- GENERAR ELS MACRO_MINSECTORS

update amsa_pgr_arc a set modif=true, graph_delimiter='macro_minsector', cost=-1, reverse_cost=-1
from
(select node_id , unnest(string_to_array(json_array_elements_text((parameters::json->>'inletArc')::json),',')) as InletArc 
from config_graph_inlet
) s
where a.arc_id=s.InletArc;	

truncate amsa_pgr_connectedcomponents;
insert into  amsa_pgr_connectedComponents
(SELECT * FROM pgr_connectedComponents(
  'SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, cost
FROM amsa_pgr_arc a'
)
);
	
-- actualitzar el camp macro_minsector_id per els arcs i els nodes
		
UPDATE amsa_pgr_node n SET macro_minsector_id=c.component
FROM amsa_pgr_connectedcomponents c
where n.pgr_node_id =c.node;

UPDATE amsa_pgr_arc a SET macro_minsector_id=c.component
FROM amsa_pgr_connectedcomponents c
where a.pgr_node_1 =c.node;

-- GENERAR ELS MINSECTORS

update amsa_pgr_node n set modif=true, graph_delimiter='minsector'
from
(select node_id
	from node n 
	join cat_node c on n.nodecat_id=c.id
	join cat_feature_node cf on c.nodetype_id =cf.id 
	where cf.graph_delimiter ='MINSECTOR'
) s
where n.node_id=s.node_id;


--comença el proces de desconnectar les fronteres MINSECTOR; es crea un arc nou amb cost i reverse cost -1

EXECUTE 'select max (pgr_node_id) from amsa_pgr_node'
INTO v_record_id;
EXECUTE 'select max (pgr_arc_id) from amsa_pgr_arc'
INTO v_arc_id;
if v_record_id>v_arc_id then v_id=v_record_id;
else v_id=v_arc_id;
end if;
	
FOR v_record IN 
	SELECT distinct on (n.pgr_node_id) n.pgr_node_id, n.graph_delimiter, a.pgr_arc_id,a.pgr_node_1,a.pgr_node_2
	FROM amsa_pgr_node n 
	join amsa_pgr_arc a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
	where n.graph_delimiter='minsector'
LOOP
	v_id=v_id+1;
	insert into amsa_pgr_node(pgr_node_id, node_id,modif,graph_delimiter) values (v_id, v_record.pgr_node_id::text,true,v_record.graph_delimiter);
	if v_record.pgr_node_id=v_record.pgr_node_1 then
		update amsa_pgr_arc set pgr_node_1=v_id 
		where pgr_arc_id=v_record.pgr_arc_id;
	else
		update amsa_pgr_arc set pgr_node_2=v_id 
		where pgr_arc_id=v_record.pgr_arc_id;
	end if;
	v_id=v_id+1;
	insert into amsa_pgr_arc(pgr_arc_id, arc_id, pgr_node_1,pgr_node_2,node_1,node_2, modif,graph_delimiter, cost, reverse_cost) values (v_id, v_record.pgr_arc_id::text,v_record.pgr_node_id, v_id-1,v_record.pgr_node_id,v_record.pgr_node_id, true,v_record.graph_delimiter, -1, -1); 
END LOOP;

truncate amsa_pgr_connectedcomponents;
insert into  amsa_pgr_connectedComponents
(SELECT * FROM pgr_connectedComponents(
  'SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, cost
FROM amsa_pgr_arc a'
)
);
	
	
-- actualitzar el camp component per els arcs i els nodes
		
UPDATE amsa_pgr_node n SET minsector_id=c.component
FROM amsa_pgr_connectedcomponents c
where n.pgr_node_id =c.node;

UPDATE amsa_pgr_arc a SET minsector_id=c.component
FROM amsa_pgr_connectedcomponents c
where a.pgr_node_1 =c.node;

-- els connecs agafen el mapzone_id de l'arc al que estan associats

v_return_text = 'OK: MINSECTOR';

return v_return_text;
end;
$function$
;