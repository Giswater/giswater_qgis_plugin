-- DROP FUNCTION SCHEMA_NAME.gw_fct_create_thyssen_subcatchments(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_thyssen_subcatchments(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
/*

id: 3360
SELECT gw_fct_create_thyssen_subcatchments($${"client":{"device":4, "lang":"", "version":"4.4.0", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"clipLayer":"sector", "deletePrevious":"true"}, "aux_params":null}}$$);

*/

DECLARE
  v_clip text;
  v_delete_previous boolean;
  v_hyd integer;
  v_version text;
  v_srid integer;
  v_result_info text;
  v_result json;
  v_fid integer := 640;
  v_sql text;
  v_fprocessname TEXT;
BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get input variables
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT "value" INTO v_hyd FROM config_param_user WHERE "parameter" = 'inp_options_hydrology_current';

	v_clip := (p_data->'data'->'parameters'->>'clipLayer')::text;
	v_delete_previous := (p_data->'data'->'parameters'->>'deletePrevious')::boolean;
	v_fprocessname = (SELECT UPPER(fprocess_name) FROM sys_fprocess where fid = v_fid);

	-- Reset previous logs
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":"'||v_fid||'", "project_type":"UD", "action":"CREATE", "group":"LOG"}}}$$)';

    INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, v_fprocessname);
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4338", "function":"3142", "fid":"'||v_fid||'","criticity":"3", "tempTable":"t_", "cur_user":"current_user", "is_process":true, "is_header":true, "label_id":"1004"}}$$)';-- CRITICAL ERRORS
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4338", "function":"3142", "fid":"'||v_fid||'","criticity":"2", "tempTable":"t_", "cur_user":"current_user", "is_process":true, "is_header":true, "label_id":"3002"}}$$)';-- WARNINGS
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4338", "function":"3142", "fid":"'||v_fid||'","criticity":"1", "tempTable":"t_", "cur_user":"current_user", "is_process":true, "is_header":true, "label_id":"3001"}}$$)';-- INFO
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, '-------------------------------');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, ''); 

	-- Optional cleanup
	IF v_delete_previous IS TRUE THEN
		DELETE FROM inp_subcatchment
		WHERE sector_id IN (SELECT DISTINCT sector_id FROM ve_sector);
	END IF;
	
	raise notice 'fast subc';

	/* ----------------------------------------------------------------------------
		FAST SUBCATCHMENTS:
		- Voronoi per municipality (smaller point sets)
		- Clip integrated via ST_VoronoiPolygons(..., extend_to := m.the_geom)
		- Avoid repeated ST_Intersection
		- Semi-join to ve_node using the chosen clip layer (no giant IN lists)
		- Assign cells to nodes with && + ST_Contains (index-friendly)
		---------------------------------------------------------------------------*/
	v_sql := format($FMT$
		INSERT INTO inp_subcatchment (subc_id, outlet_id, sector_id, muni_id, hydrology_id, descript, the_geom)
		WITH junc AS (
		SELECT n.node_id, n.sector_id, n.muni_id, n.the_geom
		FROM node n
		JOIN (SELECT DISTINCT %1$I_id FROM ve_node) f
			ON f.%1$I_id = n.%1$I_id
		WHERE n.epa_type = 'JUNCTION'
		),
		voro AS (
		SELECT j.muni_id,
				(ST_Dump(
					ST_VoronoiPolygons(
					ST_Collect(j.the_geom),
					0.0,
					m.the_geom   -- extend_to: already clipped to municipality
					)
				)).geom AS cell
		FROM junc j
		JOIN ext_municipality m ON m.muni_id = j.muni_id
		GROUP BY j.muni_id, m.the_geom
		),
		assigned AS (
		SELECT j.node_id, j.sector_id, j.muni_id, v.cell
		FROM junc j
		JOIN voro v ON v.muni_id = j.muni_id
		WHERE v.cell && j.the_geom
			AND ST_Contains(v.cell, j.the_geom)
		)
		SELECT 'S' || node_id, node_id, sector_id, muni_id, $1, 'flag_create_subcatchments', cell
		FROM assigned
	$FMT$, v_clip);

	EXECUTE v_sql USING v_hyd;


	/* ATTRIBUTES */

	raise notice 'attributes';

    WITH z AS (
		SELECT subc_id, 
		(ST_SummaryStatsAgg(ST_Clip(ST_Slope(rast, 1, '32BF', 'DEGREES'), s.the_geom), 1, TRUE)).mean AS slope 
		FROM ext_raster_dem r JOIN inp_subcatchment s ON st_intersects(r.rast, s.the_geom) 
		WHERE s.descript = 'flag_create_subcatchments'
		--AND (stats).count > 0     -- evita NULLs cuando el clip no pisa pixeles
		GROUP BY s.subc_id
	)
	UPDATE inp_subcatchment t
	SET slope = z.slope
	FROM z
	WHERE t.subc_id = z.subc_id;     
              
              
              
	-- clip
	CREATE TEMP TABLE tmp_subc ON COMMIT DROP AS
	SELECT
	s.subc_id || '_' || v.sector_id              AS subc_id,
	s.outlet_id,
	v.sector_id,
	s.muni_id,
	s.hydrology_id,
	ST_CollectionExtract(
		ST_MakeValid(
		ST_Intersection(s.the_geom, v.the_geom)
		), 3
	) AS the_geom
	FROM inp_subcatchment s
	JOIN ve_sector v
	ON s.the_geom && v.the_geom
	AND ST_Intersects(s.the_geom, v.the_geom);

	-- Remove empty spaces and noisy data
	DELETE FROM tmp_subc
	WHERE ST_IsEmpty(the_geom) OR ST_Area(the_geom) < 1.0;

	-- Keep a flag in order to clip the new created subcatchments
	DELETE FROM inp_subcatchment
	WHERE descript = 'flag_create_subcatchments';

	INSERT INTO inp_subcatchment (subc_id, outlet_id, sector_id, muni_id, hydrology_id, the_geom)
	SELECT subc_id, outlet_id, sector_id, muni_id, hydrology_id, the_geom
	FROM tmp_subc;

	-- Clean empty geometries
	DELETE FROM inp_subcatchment
	WHERE ST_IsEmpty(the_geom) OR ST_Area(the_geom) < 1.0;

	delete from ve_inp_subcatchment where subc_id in 
	(select subc_id from ve_inp_subcatchment s join node n on node_id::text = outlet_id where n.sector_id <>s.sector_id);

	-- Area (planar units)
	UPDATE inp_subcatchment
	SET area = ST_Area(the_geom), --slope = 2, 
	rg_id = 'RG-01'
	WHERE descript = 'flag_create_subcatchments';

	-- Characteristic length: use LongestLine (no per-row quadratic point pairs)
	UPDATE inp_subcatchment
	SET clength = ST_Length(ST_LongestLine(the_geom, the_geom))
	WHERE descript = 'flag_create_subcatchments';

	-- Width (avoid divide by zero)
	UPDATE inp_subcatchment
	SET width = CASE WHEN clength > 0 THEN area / clength ELSE NULL END
	WHERE descript = 'flag_create_subcatchments';

	-- SCS Curve Number "simp" (same formula)
	UPDATE inp_subcatchment
	SET simp = 0.7696 * slope ^ (-0.49)
	WHERE descript = 'flag_create_subcatchments';

	-- Clean creation flag
	UPDATE inp_subcatchment
	SET descript = NULL
	WHERE descript = 'flag_create_subcatchments';
	
	raise notice 'return';


	/* RETURN */

	INSERT INTO t_audit_check_data (fid, error_message, cur_user, criticity)
	SELECT v_fid, error_message, current_user, log_level FROM sys_message WHERE id = 3700;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (
		SELECT id, error_message AS message
		FROM t_audit_check_data
		WHERE cur_user="current_user"() AND fid=v_fid
		ORDER BY criticity DESC, id ASC
	) row;

	v_result := COALESCE(v_result, '[]'::json);
	v_result_info := concat('{"geometryType":"", "values":', v_result, '}');
	v_version := COALESCE(v_version,'{}');
	v_result_info := COALESCE(v_result_info,'{}');

	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":"'||v_fid||'", "project_type":"UD", "action":"DROP", "group":"LOG"}}}$$)';


	RETURN gw_fct_json_create_return((
		'{"status":"Accepted","message":{"level":1,"text":"Analysis done successfully"},"version":"'
		|| v_version || '","body":{"form":{},"data":{"info":' || v_result_info || '}}}'
	)::json, 3360, NULL, NULL, NULL);

END;
$function$
;
