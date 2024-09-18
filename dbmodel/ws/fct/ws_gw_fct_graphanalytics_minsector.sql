/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: 2706

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_minsector(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_minsector(p_data json)
RETURNS json AS
$BODY$

/*
TO EXECUTE

SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector('{"data":{"parameters":{"commitChanges":true, "exploitation":"1,2", "updateFeature":"TRUE", "updateMapZone":2 ,"geomParamUpdate":4}}}');

--fid: 125,134


*/

DECLARE

-- claudia
v_query text;
v_hydrometer_service text;

-- old
v_affectedrow numeric;
v_cont1 integer default 0;
v_row1 numeric default 0;
v_total numeric default 0;
v_cont2 integer default 0;
v_class text = 'MINSECTOR';
v_feature record;
v_expl text;
v_data json;
v_fid integer = 134;
v_addparam record;
v_attribute text;
v_arcid text;
v_featureid integer;
v_querytext text;
v_commitchanges boolean;
v_arc text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count integer = 0;
v_version text;
v_updatemapzgeom integer;
v_geomparamupdate float;
v_srid integer;
v_input json;
v_usepsectors boolean;
v_concavehull float = 0.85;
v_error_context text;
v_checkdata boolean;
v_returnerror boolean = false;
v_expl_query text;
v_psectors_query_arc text;
v_psectors_query_node text;
v_psectors_query_connec text;
v_psectors_query_link text;
v_loop record;
v_visible_layer text;
v_ignorebrokenvalves boolean = true;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME";

	-- get variables
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
		
	-- select config values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

	-- creat temp tables
	PERFORM gw_fct_graphanalytics_temptables();

	--old create temp tables
	CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
 	CREATE TEMP TABLE temp_minsector (LIKE SCHEMA_NAME.minsector INCLUDING ALL);
	CREATE TEMP TABLE temp_t_node (LIKE SCHEMA_NAME.node INCLUDING ALL);
	CREATE TEMP TABLE temp_t_connec (LIKE SCHEMA_NAME.connec INCLUDING ALL);
	CREATE TEMP TABLE temp_t_link (LIKE SCHEMA_NAME.link INCLUDING ALL);
	CREATE TEMP TABLE temp_t_arc (LIKE SCHEMA_NAME.arc INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);

	-- Starting process
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

	-- init process
	perform gw_fct_graphanalytics_initnetwork(); 

	-- insert values on temp tables (only used to propagate to those features wich belongs in the expl selected)
	INSERT INTO temp_t_arc SELECT * FROM arc WHERE state=1; -- se debe pulir solo con los isoperative.
	INSERT INTO temp_t_node SELECT * FROM node WHERE state=1;  -- se debe pulir solo con los isoperative.
	INSERT INTO temp_t_connec SELECT * FROM connec WHERE state=1;  -- se debe pulir solo con los isoperative.
	INSERT INTO temp_t_link SELECT * FROM link WHERE state=1;  -- se debe pulir solo con los isoperative.

	-- nodes limits de minsectors: nodes que tenen "graph_delimiter"='MINSECTOR'
	-- també els nodes que apareixen com inicis a la taula "sector" i que tenen "graph_delimiter"='SECTOR' ; 
	-- ull: to_arc esta a la taula man-valve, qualsevol vàlvula podrà arribar a tenir el comportament d'una check-valve, tot i que no hauria de passar això, de forma descontrolada

	update temp_pgr_node n set graph_delimiter=s.graph_delimiter
	from
	(SELECT n.node_id, cf.graph_delimiter
		FROM 
		(select node_id, nodecat_id, state from node) n
		join (select id, nodetype_id from cat_node) cn on cn.id=n.nodecat_id
		join (select id, graph_delimiter from cat_feature_node) cf on cf.id=cn.nodetype_id
		where n.state=1 and (cf.graph_delimiter='MINSECTOR' or cf.graph_delimiter='SECTOR')
	) s
	where n.pgr_node_id=s.node_id::int;

	-- "graph_delimiter"='MINSECTOR'
	update temp_pgr_node n set modif=true
	where n.graph_delimiter='MINSECTOR';

	-- si es volen ignorar les valvules obertes pero avariades
	if v_ignorebrokenvalves then 
		update temp_pgr_node n set modif=FALSE
		from 
		(select node_id from man_valve where (closed =false or closed is null) and broken =true) s
		where n.modif=true and n.node_id=s.node_id;
	end if;

	-- arcs que s'han de desconnectar: un dels 2 arcs que arriben a la valvula

	update temp_pgr_arc a set modif=true, cost=-1, reverse_cost=-1
	from
	(select distinct on (n.pgr_node_id) n.pgr_node_id, a.pgr_arc_id
	from
	(SELECT pgr_node_id from temp_pgr_node where modif=true) n --els nodes que són minsectors
	join (select pgr_arc_id, arc_id, pgr_node_1, pgr_node_2 from temp_pgr_arc) a 
	on n.pgr_node_id in (a.pgr_node_1, pgr_node_2)
	) s
	where a.pgr_arc_id= s.pgr_arc_id;	

	-- "graph_delimiter"='SECTOR' i a més estan a la taula "sector"

	-- nodes 
	update temp_pgr_node n set modif=true
	from
	(SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id
			from sector where graphconfig is not null and active is true
	) s
	where n.pgr_node_id=s.node_id::int and n.graph_delimiter='SECTOR';

	--arcs que s'han de desconnectar: - tots els que serien InletArc per els nodes inicis de sectors i que "graph_delimiter"='SECTOR'
	update temp_pgr_arc a set modif=true, cost=-1, reverse_cost=-1
	from
	(select n.pgr_node_id, a.pgr_arc_id
	from
	(SELECT pgr_node_id from temp_pgr_node where modif=true and graph_delimiter='SECTOR') n
	join (select pgr_arc_id, arc_id, pgr_node_1, pgr_node_2 from temp_pgr_arc) a 
	on n.pgr_node_id in (a.pgr_node_1, pgr_node_2)
	) s
	where a.pgr_arc_id= s.pgr_arc_id;	

	-- generar nous arcs i desconnectar els arcs amb modif=true
	PERFORM gw_fct_graphanalytics_arrangenetwork();

	--generar els minsectors
	truncate temp_pgr_connectedcomponents;
	v_query='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, cost, reverse_cost FROM temp_pgr_arc a';
	insert into  temp_pgr_connectedcomponents(seq,component,node)
	(SELECT seq,component,node FROM pgr_connectedcomponents(v_query)
	);
		
	-- actualitzar el camp zone_id per els arcs i els nodes
	UPDATE temp_pgr_node n SET zone_id=c.component
	FROM temp_pgr_connectedcomponents c
	where n.pgr_node_id =c.node;

	UPDATE temp_pgr_arc a SET zone_id=c.component
	FROM temp_pgr_connectedcomponents c
	where a.pgr_node_1 =c.node and (cost>=0 or reverse_cost>=0);

	truncate temp_pgr_minsector;
	insert into temp_pgr_minsector (pgr_arc_id, node_id, minsector_id_1, minsector_id_2, graph_delimiter)
	(select a.pgr_arc_id, n1.node_id, n1.zone_id, n2.zone_id,  n1.graph_delimiter
	from temp_pgr_arc a
	join temp_pgr_node n1 on a.pgr_node_1 =n1.pgr_node_id 
	join temp_pgr_node n2 on a.pgr_node_2 =n2.pgr_node_id 
	where a.node_1 =a.node_2
	);

	-- posar en '0' els nodes frontera de minsectors
	update temp_pgr_node n set zone_id ='0'
	from 
	(select node_id, count (distinct zone_id)
	from temp_pgr_node
	group by node_id
	having count(distinct zone_id)>1) s 
	where n.node_id =s.node_id;

	-- update feature temporal tables
	UPDATE temp_t_arc a SET minsector_id = zone_id FROM temp_pgr_arc t WHERE t.arc_id = a.arc_id AND graph_delimiter is null;
	UPDATE temp_t_node a SET minsector_id = zone_id FROM temp_pgr_node t WHERE t.node_id = a.node_id;
	UPDATE temp_t_connec c SET minsector_id = a.minsector_id FROM arc a WHERE c.arc_id = a.arc_id;
	UPDATE temp_t_link l SET minsector_id = c.minsector_id FROM connec c WHERE c.connec_id = l.feature_id;

	--insert minsector temporal table
	INSERT INTO temp_minsector SELECT DISTINCT zone_id FROM temp_pgr_arc;

	-- update minsector temporal num_border
	UPDATE temp_minsector SET num_border = a.num FROM 
	(SELECT a.minsector_id, CASE WHEN count(node_id)=1 then 2 else count(node_id) end AS num FROM node n, arc a 
	WHERE  (a.node_1 = n.node_id OR a.node_2 = n.node_id) AND  n.minsector_id = 0
	GROUP BY a.minsector_id)a WHERE a.minsector_id=temp_minsector.minsector_id;

	-- update minsector temporal num_connec
	UPDATE temp_minsector SET num_connec = b.c FROM (SELECT minsector_id, case when count(*) is not null then count(*) else 0 end as c
	FROM connec a GROUP by minsector_id)b WHERE b.minsector_id=temp_minsector.minsector_id;		
	UPDATE minsector a SET num_connec = 0 where num_connec is null;

	-- update minsector temporal num_hydro

	SELECT value::json->>'1' INTO v_hydrometer_service FROM config_param_system WHERE parameter = 'admin_hydrometer_state';

	UPDATE temp_minsector SET num_hydro = a.c FROM (
	select minsector_id, case when count(*) is not null then count(*) else 0 end as c FROM 
	(SELECT hydrometer_id, minsector_id 
	FROM selector_hydrometer,rtc_hydrometer
	LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
	JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
	JOIN connec a ON a.customer_code::text = ext_rtc_hydrometer.connec_id::text	
	--WHERE ext_rtc_hydrometer.state_id ANY (v_hydrometer_service)
	UNION SELECT hydrometer_id, minsector_id 
	FROM selector_hydrometer,rtc_hydrometer
	LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
	JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
	JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
	JOIN node a ON a.node_id::text = man_netwjoin.node_id::text
	--WHERE ext_rtc_hydrometer.state_id ANY (v_hydrometer_service)
	)a GROUP by minsector_id)a WHERE a.minsector_id=temp_minsector.minsector_id;
	UPDATE minsector a SET num_hydro = 0 WHERE num_hydro is null;

	-- update minsector temporal length
	UPDATE temp_minsector SET length = b.length FROM (SELECT minsector_id, sum(st_length2d(a.the_geom)::numeric(12,2)) as length 
	FROM arc a GROUP by minsector_id)b WHERE b.minsector_id=temp_minsector.minsector_id;

	-- update minsector temporal exploitation
	UPDATE temp_minsector t SET expl_id = n.expl_id FROM node n WHERE n.node_id::integer = t.minsector_id;

	-- update minsector temporal geometry
	IF v_updatemapzgeom = 0 OR v_updatemapzgeom IS NULL THEN 

		EXECUTE 'UPDATE temp_minsector m SET the_geom = null FROM temp_t_arc a WHERE a.minsector_id = m.minsector_id';
					
	ELSIF  v_updatemapzgeom = 1 THEN
		

		-- concave polygon
		v_querytext = 'UPDATE temp_minsector set the_geom = st_multi(b.the_geom) 
				FROM (with polygon AS (SELECT st_collect (the_geom) as g, minsector_id FROM temp_t_arc a group by minsector_id)
				SELECT minsector_id, CASE WHEN st_geometrytype(st_concavehull(g, '||v_geomparamupdate||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||
				v_concavehull||'), 3)::geometry(Polygon,'||v_srid||')
				ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon, '||v_srid||') END AS the_geom FROM polygon
				)b WHERE b.minsector_id = temp_minsector.minsector_id';
		EXECUTE v_querytext;
				
	ELSIF  v_updatemapzgeom = 2 THEN
			
		-- pipe buffer
		v_querytext = '	UPDATE temp_minsector set the_geom = st_multi(geom) FROM
				(SELECT minsector_id, (st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from temp_t_arc a where minsector_id > 0 group by minsector_id)b 
				WHERE b.minsector_id = temp_minsector.minsector_id';			
		EXECUTE v_querytext;

		RAISE NOTICE ' %', v_querytext;

	ELSIF  v_updatemapzgeom = 3 THEN

		-- use plot and pipe buffer		
		v_querytext = ' UPDATE temp_minsector set the_geom = geom FROM
					(SELECT minsector_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
					(SELECT minsector_id, st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from temp_t_arc a
					where minsector_id::integer > 0 group by minsector_id 
					UNION
					SELECT minsector_id, st_collect(ext_plot.the_geom) as geom FROM temp_t_connec a, ext_plot
					WHERE minsector_id::integer > 0 AND st_dwithin(a.the_geom, ext_plot.the_geom, 0.001) 
					group by minsector_id
					)c group by minsector_id)b 
				WHERE b.minsector_id=temp_minsector.minsector_id';

		EXECUTE v_querytext;
	END IF;
	
	IF v_commitchanges IS FALSE THEN 
		-- polygons 
		EXECUTE 'SELECT jsonb_agg(features.feature) 
		FROM ( 
	  	SELECT jsonb_build_object(
	    ''type'',       ''Feature'',
	    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
	    ''properties'', to_jsonb(row) - ''the_geom''
	  	) AS feature
	  	FROM (SELECT  * FROM temp_minsector) row) features'
		INTO v_result;

		v_result := COALESCE(v_result, '{}'); 
		v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');

		-- message
		INSERT INTO temp_audit_check_data (fid, error_message)
		VALUES (v_fid, concat('INFO-',v_fid,': Minsector attribute on arc/node/connec/link features have NOT BEEN updated by this process'));
	ELSE 

		-- update minsector
		TRUNCATE minsector;
		INSERT INTO minsector SELECT * FROM temp_minsector;

		-- update minsector graph	
		TRUNCATE minsector_graph;
		INSERT INTO minsector_graph (node_id, minsector_1, minsector_2) SELECT DISTINCT ON (node_id) node_id, minsector_id_1, minsector_id_2 FROM temp_pgr_minsector;

		-- update values (only for those objects that belongs on the exploitations selected
		EXECUTE 'UPDATE arc a SET minsector_id = t.minsector_id FROM temp_t_arc t WHERE a.arc_id = t.arc_id AND a.expl_id IN ('||v_expl||')';
		EXECUTE 'UPDATE node n SET minsector_id = t.minsector_id FROM temp_t_node t WHERE n.node_id = t.node_id AND n.expl_id IN ('||v_expl||')';
		EXECUTE 'UPDATE connec c SET minsector_id = t.minsector_id FROM temp_t_connec t WHERE c.connec_id = t.connec_id AND t.expl_id IN ('||v_expl||')';
		EXECUTE 'UPDATE link l SET minsector_id = t.minsector_id FROM temp_t_link t WHERE l.link_id = t.link_id AND l.expl_id IN ('||v_expl||')';

		v_result = null;
		v_result := COALESCE(v_result, '{}'); 
		v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');
		v_visible_layer = NULL;

		-- message
		INSERT INTO temp_audit_check_data (fid, error_message)
		VALUES (v_fid, concat('INFO-',v_fid,': Minsector attribute on arc/node/connec/link features have been updated by this process'));
	
	END IF;

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}');	

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');

	--lines
	v_result = null;
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');

	-- drop temporal layers (new)
	DROP TABLE IF EXISTS temp_pgr_node;
	DROP TABLE IF EXISTS temp_pgr_arc;
	DROP TABLE IF EXISTS temp_pgr_minsector;
	DROP TABLE IF EXISTS temp_pgr_connectedcomponents;
	DROP TABLE IF EXISTS temp_pgr_drivingdistance;

	--drop temporal layers (old)
	DROP VIEW IF EXISTS v_temp_anlgraph;
	DROP VIEW IF EXISTS v_t_process;
	DROP TABLE IF EXISTS temp_t_anlgraph;
	DROP TABLE IF EXISTS temp_minsector;
	DROP TABLE IF EXISTS temp_t_node;
	DROP TABLE IF EXISTS temp_t_link;
	DROP TABLE IF EXISTS temp_t_connec;
	DROP TABLE IF EXISTS temp_anl_arc;
	DROP TABLE IF EXISTS temp_audit_check_data;
	DROP TABLE IF EXISTS temp_t_arc;

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2706, null,  ('{"visible": ["'||v_visible_layer||'"]}')::json, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
