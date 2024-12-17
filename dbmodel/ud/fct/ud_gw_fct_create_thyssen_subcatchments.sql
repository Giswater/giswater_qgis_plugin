-- DROP FUNCTION SCHEMA_NAME.gw_fct_create_thyssen_subcatchments(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_thyssen_subcatchments(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
/*

SELECT SCHEMA_NAME.gw_fct_create_thyssen_subcatchments($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"clipLayer":"sector", "deletePrevious":"true"}, "aux_params":null}}$$);

*/

DECLARE
v_clip text;
v_mapzone_id text;
v_delete_previous boolean;
v_hyd integer;
v_rec_subc record;
v_clength numeric;

v_version text;
v_srid integer;
v_result_info text;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get input variables
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT "value" INTO v_hyd FROM config_param_user WHERE "parameter" = 'inp_options_hydrology_current';

	v_clip := (((p_data ->>'data')::json->>'parameters')::json->>'clipLayer')::text;
	v_delete_previous := (((p_data ->>'data')::json->>'parameters')::json->>'deletePrevious')::boolean;


	EXECUTE 'select distinct string_agg('||v_clip||'_id::text, '','') from v_edit_node'
	INTO v_mapzone_id;

	IF v_delete_previous IS TRUE THEN

		DELETE FROM inp_subcatchment WHERE sector_id IN (SELECT distinct sector_id FROM v_edit_sector);

	END IF;

	-- create subcatchments (using node_id as outlet_id and current hydrology scenario)
	execute '
	INSERT INTO inp_subcatchment (subc_id, outlet_id, sector_id, muni_id, hydrology_id, descript, the_geom)
	WITH mec AS (
	    SELECT (ST_Dump(ST_VoronoiPolygons(ST_Collect(the_geom)))).geom AS thy
	    FROM node n
	)
	SELECT concat(''S'', n.node_id), n.node_id, n.sector_id, n.muni_id, '||v_hyd||', ''flag_create_subcatchments'',
	st_intersection(m.thy, t.the_geom)
	FROM node n
	JOIN mec m ON ST_Within(n.the_geom, m.thy)
	LEFT JOIN ext_municipality t using (muni_id)
	WHERE n.epa_type = ''JUNCTION''
	AND NOT st_isempty(st_intersection(m.thy, t.the_geom))
	AND n.'||v_clip||'_id in ('||v_mapzone_id||')';


	-- slope
	UPDATE inp_subcatchment t SET slope = a.slope FROM (
		WITH slope_raster AS (
		SELECT ST_Slope(rast, 1, '32BF', 'PERCENTAGE') AS rast, envelope FROM ext_raster_dem
	), subc AS (
		SELECT subc_id, the_geom FROM inp_subcatchment
	), mec AS (
		SELECT subc_id, (ST_SummaryStats(ST_Clip(s.rast, p.the_geom))).mean AS mean_slope
		FROM subc p
		LEFT JOIN slope_raster s ON ST_Intersects(p.the_geom,  s.envelope)
		GROUP BY p.subc_id, p.the_geom, s.rast
	)
	SELECT subc_id, avg(mean_slope) AS slope FROM mec
	GROUP BY  subc_id
	)a WHERE a.subc_id = t.subc_id AND t.descript = 'flag_create_subcatchments';

	-- area
	UPDATE inp_subcatchment SET "area" = st_area(the_geom) WHERE descript = 'flag_create_subcatchments';

	-- clength
	FOR v_rec_subc IN SELECT subc_id FROM inp_subcatchment WHERE descript = 'flag_create_subcatchments'
	loop
		execute '
		with vertices as (
		SELECT subc_id,
		    (ST_DumpPoints(the_geom)).path[3] AS id,
		    (ST_DumpPoints(the_geom)).geom AS geom
		    from inp_subcatchment WHERE subc_id = '||quote_literal(v_rec_subc.subc_id)||'
		)
		SELECT ST_Distance(v1.geom, v2.geom) AS dist
		FROM vertices v1, vertices v2
		WHERE v1.id != v2.id order by ST_Distance(v1.geom, v2.geom) desc limit 1'
		INTO v_clength;

		UPDATE inp_subcatchment set clength = v_clength	WHERE subc_id = v_rec_subc.subc_id;

	END LOOP;

	-- width
	UPDATE inp_subcatchment set "width" = "area" / clength WHERE descript = 'flag_create_subcatchments';

	-- simp
	UPDATE inp_subcatchment set simp = 0.7696*slope^(-0.49) WHERE descript = 'flag_create_subcatchments';


	-- clean flag
	UPDATE inp_subcatchment set descript = null WHERE descript = 'flag_create_subcatchments';


	-- Control NULL's
	v_version:=COALESCE(v_version,'{}');
	v_result_info:=COALESCE(v_result_info,'{}');

	--return definition for v_audit_check_result
	RETURN '{"status":"Accepted"}';

END;
$function$
;
