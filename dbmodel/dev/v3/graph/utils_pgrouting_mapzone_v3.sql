/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/



CREATE OR REPLACE FUNCTION amsa_fct_pgr_mapzone(p_mapzone text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

/* example
SELECT amsa_fct_pgr_mapzone(p_mapzone); p_mapzone in ('sector', 'dma', 'dqa', 'presszone', 'minsector')

Consulta per visualitzar els arcs  amb les seves geometries:

select a.arc_id, mapzone_id, the_geom from amsa_pgr_arc p
join
(select arc_id, the_geom from arc) a on p.arc_id =a.arc_id::int;

Consulta per visualitzar els nodes amb les seves geometries :

select distinct n.node_id, p.mapzone_id , n.the_geom from amsa_pgr_node p
join
(select node_id, the_geom from node) n on p.node_id =n.node_id;

Consulta per calcular el factor per multiplicar cabal suma/resta cabalimetre en una DMA:

select n.node_id, n.mapzone_id as mapzone_node, a.mapzone_id as mapzone_arc,
case when n.mapzone_id =a.mapzone_id then 1
else -1
end as factor_multiplicar
from amsa_pgr_node n
join amsa_pgr_arc a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
where n.graph_delimiter ='dma';

*/

declare

v_query text;
v_node record;
v_node_id integer=0;
v_i integer;
v_return_text text;
v_mapzone_name text;
v_mapzone_field text;



begin

--SET search_path = "ws_github_full", public;

-- no es guarda la geometria, s'ha de fer un join amb la taula node per recuperar-la per els resultats

v_mapzone_name=lower(p_mapzone);

if v_mapzone_name not in ('sector', 'dma', 'dqa', 'presszone', 'minsector') then

	v_return_text='ERROR: use one of these options: ''sector'', ''dma'', ''dqa'', ''presszone'', ''minsector''';
else
	-- PART COMUNA MINSECTORS I LA RESTA DE Mapzone

	drop table if exists amsa_pgr_node;
	CREATE TABLE amsa_pgr_node (
		pgr_node_id int not null,
		node_id varchar(16),
		mapzone_id varchar(30) default '0', -- per defecte és Undefined; és text perque el camp "id" per presszone és text
		component int,
		modif bool default false, -- true si s'han de desconectar els nodes - valvules tancades, inicis de mapzones
		graph_delimiter varchar(30),
		CONSTRAINT amsa_pgr_node_pkey PRIMARY KEY (pgr_node_id)
	);
	CREATE INDEX amsa_pgr_node_node_id ON amsa_pgr_node USING btree (node_id);

	drop table if exists amsa_pgr_arc;
	CREATE TABLE amsa_pgr_arc (
		arc_id int not null,
		pgr_node_1 int,
		pgr_node_2 int,
		node_1 varchar(16),
		node_2 varchar(16),
		mapzone_id varchar(30) default '0', -- per defecte és Undefined; és text perque el camp "id" per presszone és text
		component int,
		graph_delimiter varchar(30),
		cost int default 1,
		reverse_cost int default 1,
		CONSTRAINT amsa_pgr_arc_pkey PRIMARY KEY (arc_id)
	);
	CREATE INDEX amsa_pgr_arc_pgr_node1 ON amsa_pgr_arc USING btree (pgr_node_1);
	CREATE INDEX amsa_pgr_arc_pgr_node2 ON amsa_pgr_arc USING btree (pgr_node_2);
	CREATE INDEX amsa_pgr_arc_node1 ON amsa_pgr_arc USING btree (node_1);
	CREATE INDEX amsa_pgr_arc_node2 ON amsa_pgr_arc USING btree (node_2);

	insert into amsa_pgr_node (pgr_node_id, node_id)
	(SELECT node_id::int, node_id
	 FROM node n
	 join value_state_type s on s.id =n.state_type
	 where n.state=1 and s.is_operative =true
	);

	insert into amsa_pgr_arc (arc_id, pgr_node_1,pgr_node_2, node_1, node_2)
	(SELECT a.arc_id::int, a.node_1::int, a.node_2::int,a.node_1, a.node_2
	 FROM arc a
	 join value_state_type s on s.id =a.state_type
	 where a.state=1 and s.is_operative =true
	  and a.node_1 is not null and a.node_2 is not null -- evita el crash de pgr_connectedComponents
	);
	-- FIN PART COMUNA MINSECTORS I LA RESTA DE Mapzone

	-- la opció de minsectors
	if v_mapzone_name='minsector' then
		update amsa_pgr_node n set modif=true, graph_delimiter='minsector'
		from
		(select node_id
			from node n
			join cat_node c on n.nodecat_id=c.id
			join cat_feature_node cf on c.nodetype_id =cf.id
			where cf.graph_delimiter ='MINSECTOR'
		) s
		where n.node_id=s.node_id;

	-- la resta de mapzones
	else

		--valvules tancades
		update amsa_pgr_node n set modif = true , graph_delimiter='valvula' -- aquest valor a lo millor s'ha de modificar i posar els features que son DELIMITERS DE MINSECTORS
		from
		(select node_id from man_valve where closed=true ) s
		where n.node_id =s.node_id;

		--Mapzone

		v_mapzone_field=v_mapzone_name||'_id';

		--nodes forceClosed, comportament igual que el de les valvules

		v_query=
		'update amsa_pgr_node n set modif = true, graph_delimiter=''forceClosed'' 
		from 
		(SELECT json_array_elements_text((graphconfig->>''forceClosed'')::json) as node_id
		from '||v_mapzone_name||' where graphconfig is not null and active is true ) s 
		where n.node_id =s.node_id';
		execute v_query;

		--nodes inicis de mapzones

		v_query=
		'update amsa_pgr_node n set modif = true, graph_delimiter='''||v_mapzone_name||''', mapzone_id='||v_mapzone_field||
		'::text from 
		(SELECT '||v_mapzone_field||'::int, (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' as node_id
			from '||v_mapzone_name||' where graphconfig is not null and active is true
		) as s 
		where n.node_id =s.node_id';
		execute v_query;

		--arcs inicis de mapzones

		v_query=
		'update amsa_pgr_arc a set graph_delimiter='''||v_mapzone_name||''', mapzone_id='||v_mapzone_field||
		'::text from 
		(select s.'||v_mapzone_field||', s.node_id, array_agg(s.to_arc)::int[] as arc_array
			FROM
			(SELECT '||v_mapzone_field||',(json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' as node_id,
				json_array_elements_text(((json_array_elements_text((graphconfig->>''use'')::json))::json->>''toArc'')::json) as to_arc
				from '||v_mapzone_name||' where graphconfig is not null and active is true
			) as s 
			group by  s.node_id,'||v_mapzone_field||') as s 
		where s.node_id in (a.node_1, a.node_2)  and a.arc_id =any(s.arc_array)';
		execute v_query;

		--nodes "ignore", no s'han de desconnectar

		v_query=
		'update amsa_pgr_node n set modif = true, graph_delimiter=''ignore'' 
		from 
		(SELECT json_array_elements_text((graphconfig->>''ignore'')::json) as node_id
		from '||v_mapzone_name||' where graphconfig is not null and active is true ) s 
		where n.node_id =s.node_id';
		execute v_query;

	end if;

	--comença el proces de desconnectar els arcs en els nodes que tenen valor true en el camp "modif"; es fa per elnr d'arcs - 1;
	--d'aquesta manera al final hi ha tans nodes com arcs que connecten en el node

	-- PART COMUNA PER MINSECTORS i la resta de mapzones

	EXECUTE 'select max (pgr_node_id) from amsa_pgr_node'
	INTO v_node_id;

	FOR v_node IN
		select node_id, mapzone_id, graph_delimiter, array_agg(arc_id)::int[] as arc_array, count(arc_id) as arc_count from
		(SELECT n.node_id,n.mapzone_id, n.graph_delimiter, a.arc_id
		FROM amsa_pgr_node n
		join amsa_pgr_arc a on n.node_id in (a.node_1, a.node_2)
		where n.modif=true) s
		group by node_id,mapzone_id, graph_delimiter
	LOOP
		FOR i IN 1..v_node.arc_count-1 LOOP
	 		v_node_id=v_node_id+1;
			insert into amsa_pgr_node(pgr_node_id, node_id,modif,graph_delimiter, mapzone_id) values (v_node_id, v_node.node_id,true,v_node.graph_delimiter, v_node.mapzone_id);
			update amsa_pgr_arc set pgr_node_1=v_node_id where node_1=v_node.node_id and arc_id=v_node.arc_array[i];
			update amsa_pgr_arc set pgr_node_2=v_node_id where node_2=v_node.node_id and arc_id=v_node.arc_array[i];
		END LOOP;
	END LOOP;

	drop table if exists amsa_pgr_connectedComponents;
	create table amsa_pgr_connectedComponents as
	(SELECT * FROM pgr_connectedComponents(
	  'SELECT arc_id as id, pgr_node_1 as source, pgr_node_2 as target, cost
	FROM amsa_pgr_arc a'
	)
	);

	-- FIN PART COMUNA MINSECTORS I RESTA Mapzone

	-- actualitzar el camp component per els arcs i els nodes

	-- la opció de minsectors - poso per separat tot l'algoritme perquè és molt senzill

	--MINSECTOR

	if v_mapzone_name='minsector' then

		UPDATE amsa_pgr_node n SET component = c.component, mapzone_id=c.component
		FROM amsa_pgr_connectedcomponents c
		where n.pgr_node_id =c.node;

		UPDATE amsa_pgr_arc a SET component = n.component, mapzone_id=n.component
		FROM amsa_pgr_node n
		WHERE a.pgr_node_1 = n.pgr_node_id;

		update amsa_pgr_node set mapzone_id ='0'
		where graph_delimiter='minsector';

		-- els connecs agafen el mapzone_id de l'arc al que estan associats

	-- RESTA MAPZONE
	else

		UPDATE amsa_pgr_node n SET component = c.component
		FROM amsa_pgr_connectedcomponents c
		where n.pgr_node_id =c.node;

		UPDATE amsa_pgr_arc a SET component = n.component
		FROM amsa_pgr_node n
		WHERE a.pgr_node_1 = n.pgr_node_id;

		--ACTUALITZAR EL CAMP MAPZONE_ID primer per arcs i després per nodes;

		--i si el component no té cap mapzone, "mapzone_id" manté el valor que ve per defecte i que és 0 - Undefines

		-- PER ARCS
		-- al principi, els arcs que tenen informat mapzone_id són els "to_arc" del "graphconfig" de les taula d'una mapzone; la resta tenen '0'
		--es sobrescriuen amb el proces i poden arribar a tenir el valor '-1' Conflict

		--s'actualitzen els arcs de forma masiva, per "component"

		-- si un component té només una mapzone, els arcs d'aquest component tindran el id de la mapzone;

		update amsa_pgr_arc a set mapzone_id=p.mapzone_id
		from
		(select component,array_to_string(array_agg(distinct mapzone_id),',') as mapzone_id,count(distinct mapzone_id) as mapzone_count
		from amsa_pgr_arc
		where mapzone_id<>'0'
		group by component) as p
		where a.component =p.component and p.mapzone_count=1;

		--si el component té més d'una mapzone, els arcs d'aquest component tindran mapzone_id='-1', CONFLICT;
		update amsa_pgr_arc a set mapzone_id='-1'
		from
		(select component,array_to_string(array_agg(distinct mapzone_id),',') as mapzone_id,count(distinct mapzone_id) as mapzone_count
		from amsa_pgr_arc
		where mapzone_id<>'0'
		group by component) as p
		where a.component =p.component and p.mapzone_count>1;


		-- els arcs que no s'han actualitzat anteriorment es queden amb el valor que s'ha posat per defecte ('0' - Undefined)

		-- PER NODES
		-- al principi, els nodes que tenen informat mapzone_id són els nodes del "graphconfig" de les taula d'una mapzone (els nodes i els seus clonats que s'han insertat de més)

		-- s'actualitzen els nodes que no tenen informat mapzone_id (són '0', per defecte);

		update amsa_pgr_node n set mapzone_id=a.mapzone_id
		from amsa_pgr_arc a
		where n.mapzone_id='0' and n.pgr_node_id in (a.pgr_node_1 , a.pgr_node_2 );


		-- ara es posen en 0 als que connecten arcs amb mapzone_id diferents
		-- molt xulo: si una valvula tancada, per exemple, esta entre sector 2 i sector 3 vol dir que fa frontera, tindrà '0' com mapzone_id; si esta entre -1 i 2 també tindrà 0;
		-- en canvi, si una valvula tancada esta entre arcs amb el mateix sector, el manté; si esta entre 1 i 1, manté 1, vol dir que no fa frontera; si esta entre -1 i -1, no canvia, manté Conflict

		update amsa_pgr_node n set mapzone_id ='0'
		from
		(select node_id,count (distinct mapzone_id) from amsa_pgr_node
		group by node_id
		having count(distinct mapzone_id )>1) s
		where n.node_id =s.node_id;

		-- els connecs agafen el mapzone_id de l'arc al que estan associats
	end if;

	v_return_text = concat('OK: ', upper(v_mapzone_name));

end if;

return v_return_text;
end;
$function$
;