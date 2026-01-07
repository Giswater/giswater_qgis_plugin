/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3528

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_epa_result_families(v_result_id text, v_age integer)
RETURNS json AS
$BODY$
DECLARE

v_version text;
v_result json;
v_date_limit date;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_date_limit := CURRENT_DATE - (v_age || ' years')::INTERVAL;

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
			WHEN builtdate > v_date_limit THEN 'NEW'
			ELSE 'OLD'
		END AS cal_age,
		dma_id,
		presszone_id
		FROM rpt_inp_arc
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
	),
	features AS (SELECT arc_id AS feature_id, epa_type AS feature_epa_type, arccat_id AS feature_catalog,
	CASE
		WHEN "family" IS NULL THEN NULL
		WHEN cal_age IS NULL THEN "family"
		ELSE concat("family", '_', cal_age)
	END AS cal_family,
	dma_id,
	presszone_id
	FROM arcs
	UNION ALL
	SELECT node_id AS feature_id, epa_type AS feature_epa_type, nodecat_id AS feature_catalog, epa_type AS cal_family, dma_id, presszone_id
	FROM nodes
	)
	SELECT json_agg(
		json_build_object(
			'featureId', split_part(feature_id, '_', 1),
			'featureEpaId', feature_id,
			'featureEpaType', feature_epa_type,
			'featureCatalog', feature_catalog,
			'family', cal_family,
			'zones', json_build_object(
				'dma', dma_id,
				'presszone', presszone_id
			)
		)
	) AS result INTO v_result
	FROM features;
	
	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
			',"body":{"form":{}'||
			',"data":{"result_id": "'||v_result_id||'", "age": "'||v_age||'", "features":'||v_result||
		'}}'||
	'}')::json, 2302, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;