/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3528

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_epa_result_families(v_result_id text)
RETURNS json AS
$BODY$
DECLARE

v_version text;
v_features json;
v_families json;
v_mapzones json;


rec TEXT;
sql TEXT;
result jsonb := '[]'::jsonb;
zone_json jsonb;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Create temp table with features
	CREATE TEMP TABLE temp_features AS
	WITH arcs AS (
		SELECT arc_id,
		CASE
			WHEN epa_type = 'VALVE' OR epa_type = 'VIRTUALVALVE' THEN 'VALVE'
			WHEN epa_type = 'PUMP' OR epa_type = 'VIRTUALPUMP' THEN 'PUMP'
			ELSE 'PIPE'
		END AS epa_type,
		arccat_id,
		CASE
			WHEN epa_type = 'VALVE' OR epa_type = 'VIRTUALVALVE' THEN addparam::json->>'valve_type'
			WHEN epa_type = 'PUMP' OR epa_type = 'VIRTUALPUMP' THEN addparam::json->>'pump_type'
			ELSE "family"
		END AS "family",
		CASE
			WHEN builtdate IS NULL THEN NULL
			WHEN builtdate > CURRENT_DATE - (f.age || ' years')::INTERVAL THEN 'NEW'
			ELSE 'OLD'
		END AS cal_age,
		dma_id,
		presszone_id
		FROM rpt_inp_arc
		LEFT JOIN inp_family f ON "family" = family_id AND f.age IS NOT NULL
		WHERE result_id = v_result_id
	),
	nodes AS (
		SELECT node_id,
		CASE
			WHEN epa_type = 'TANK' OR epa_type = 'RESERVOIR' THEN epa_type
			ELSE 'JUNCTION'
		END AS epa_type,
		nodecat_id,
		CASE
			WHEN epa_type = 'TANK' OR epa_type = 'RESERVOIR' THEN epa_type
			ELSE 'JUNCTION'
		END AS "family",
		dma_id,
		presszone_id
		FROM rpt_inp_node
		WHERE result_id = v_result_id
	)
	SELECT 
		arc_id AS feature_id, 
		epa_type AS feature_epa_type, 
		arccat_id AS feature_catalog,
		CASE
			WHEN "family" IS NULL THEN NULL
			WHEN cal_age IS NULL THEN "family"
			ELSE concat("family", '_', cal_age)
		END AS cal_family,
		dma_id,
		presszone_id
	FROM arcs
	UNION ALL
	SELECT 
		node_id AS feature_id, 
		epa_type AS feature_epa_type, 
		nodecat_id AS feature_catalog, 
		epa_type AS cal_family, 
		dma_id, 
		presszone_id
	FROM nodes;

	-- JSON with features
	SELECT json_agg(
		json_build_object(
			'id', split_part(feature_id, '_', 1),
			'epaId', feature_id,
			'epaType', feature_epa_type,
			'catalog', feature_catalog,
			'family', cal_family,
			'zones', json_build_object(
				'dma', dma_id,
				'presszone', presszone_id
			)
		)
	) INTO v_features
	FROM temp_features;

	-- JSON with all families that are in features
	WITH existing_families AS (
		SELECT DISTINCT cal_family
		FROM temp_features
		WHERE cal_family IS NOT NULL
	),
	families AS (
		SELECT DISTINCT
			ef.cal_family AS family_id,
			COALESCE(
				if_new.descript,
				if_old.descript,
				if_base.descript,
				ef.cal_family
			) AS descript
		FROM existing_families ef
		LEFT JOIN inp_family if_base ON ef.cal_family = if_base.family_id AND if_base.age IS NULL
		LEFT JOIN inp_family if_new ON ef.cal_family = concat(if_new.family_id, '_NEW') AND if_new.age IS NOT NULL
		LEFT JOIN inp_family if_old ON ef.cal_family = concat(if_old.family_id, '_OLD') AND if_old.age IS NOT NULL
	)
	SELECT json_agg(
		json_build_object(
			'name', family_id,
			'descript', descript
		)
	) INTO v_families
	FROM families;

	-- JSON with all mapzones that are in features
	FOR rec IN SELECT unnest(ARRAY['presszone', 'dma'])
    LOOP
        -- Build dynamic SQL to get JSON for this table
        sql := format($f$
            SELECT json_build_object(
                '%s',
                json_agg(json_build_object(
                    'id', %I,
                    'name', name,
                    'descript', descript,
                    'geometry', ST_AsGeoJSON(the_geom, 4326)::json
                ))
            )
            FROM %I t
            WHERE EXISTS (
                SELECT 1 FROM temp_features r WHERE r.%I = t.%I
            )
        $f$,
        rec,                 -- key: "presszone" or "dma"
        rec || '_id',        -- id column
        rec,                 -- table
        rec || '_id',        -- column in temp_features
        rec || '_id'         -- column in mapzone table
        );

        -- Execute SQL and store JSON for this table
        EXECUTE sql INTO zone_json;

        -- Append to cumulative result
        IF zone_json IS NOT NULL THEN
            result := result || zone_json;
        END IF;
    END LOOP;

	v_mapzones := result;
	
	-- Drop temp table
	DROP TABLE IF EXISTS temp_features;
	
	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
			',"body":{"form":{}'||
			',"data":{"result_id": "'||v_result_id||'", "features":'||v_features||', "families":'||v_families||', "mapzones":'||v_mapzones||
		'}}'||
	'}')::json, 2302, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;