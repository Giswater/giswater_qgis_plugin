/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2768

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mapzones_advanced(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mapzones_advanced(p_data json)
RETURNS json AS
$BODY$

/*
SELECT gw_fct_graphanalytics_mapzones_advanced('{"data":{"parameters":{"graphClass":"SECTOR", "exploitation": "15",
"updateFeature":"TRUE", "updateMapZone":1, "debug":"FALSE"}}}');

SELECT gw_fct_graphanalytics_mapzones_advanced('{"data":{"parameters":{"graphClass":"DMA", "exploitation": "1",
"updateFeature":"TRUE", "updateMapZone":3}}}');

SELECT gw_fct_graphanalytics_mapzones_advanced('{"data":{"parameters":{"graphClass":"DQA", "exploitation": "2",
"updateFeature":"TRUE", "updateMapZone":0}}}');

*/

DECLARE

	-- dialog variables
	v_netscenario text;
	v_class text;
	v_expl text;
	v_updatemapzone integer;
	v_geom_param_update float;
	v_flood_from_node text;
	v_force_closed text;
	v_force_opne text;
	v_use_plan_psector boolean;
	v_value_for_disconnected integer;
	v_flood_only_mapzone text;
	v_commit_changes boolean;
	v_from_zero boolean;

	-- system variables
	v_mapzones_version integer;

	-- query variables
	v_data json;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_netscenario := p_data->'data'->'parameters'->>'netscenario';
	IF v_netscenario IS NULL THEN
		v_class := p_data->'data'->'parameters'->>'graphClass';
	ELSE
		SELECT netscenario_type INTO v_class FROM plan_netscenario WHERE netscenario_id::text = v_netscenario::TEXT;
	END IF;

	v_expl := p_data->'data'->'parameters'->>'exploitation';
	v_updatemapzone := p_data->'data'->'parameters'->>'updateMapZone';
	v_geom_param_update := p_data->'data'->'parameters'->>'geomParamUpdate';
	v_flood_from_node := p_data->'data'->'parameters'->>'floodFromNode';
	v_force_closed := p_data->'data'->'parameters'->>'forceClosed';
	v_force_opne := p_data->'data'->'parameters'->>'forceOpen';
	v_use_plan_psector := p_data->'data'->'parameters'->>'usePlanPsector';
	v_value_for_disconnected := p_data->'data'->'parameters'->>'valueForDisconnected';
	v_flood_only_mapzone := p_data->'data'->'parameters'->>'floodOnlyMapzone';
	v_commit_changes := p_data->'data'->'parameters'->>'commitChanges';
	v_from_zero := p_data->'data'->'parameters'->>'fromZero';

	SELECT (value::json->>'version')::int2 INTO v_mapzones_version FROM config_param_system WHERE parameter='mapzones_config';

	-- control of null values
	IF v_geom_param_update IS NULL THEN v_geom_param_update = 5; END IF;
	IF v_flood_from_node IS NULL THEN v_flood_from_node = ''; END IF;
	IF v_force_closed IS NULL THEN v_force_closed = ''; END IF;
	IF v_force_opne IS NULL THEN v_force_opne = ''; END IF;
	IF v_use_plan_psector IS NULL THEN v_use_plan_psector = FALSE ; END IF;
	IF v_updatemapzone IS NULL THEN v_updatemapzone = 1; END IF;
	IF v_value_for_disconnected IS NULL THEN v_value_for_disconnected = 0; END IF;
	IF v_flood_only_mapzone IS NULL THEN v_flood_only_mapzone = ''; END IF;
	IF v_commit_changes IS NULL THEN v_commit_changes = FALSE ; END IF;
	IF v_from_zero IS NULL THEN v_from_zero = FALSE ; END IF;

	v_data := json_build_object(
		'data', json_build_object(
			'parameters', json_build_object(
				'graphClass', v_class,
				'exploitation', v_expl,
				'updateFeature', 'TRUE',
				'updateMapZone', v_updatemapzone,
				'geomParamUpdate', v_geom_param_update,
				'floodFromNode', v_flood_from_node,
				'forceOpen', '['||v_force_opne||']',
				'forceClosed', '['||v_force_closed||']',
				'usePlanPsector', v_use_plan_psector,
				'debug', 'FALSE',
				'valueForDisconnected', v_value_for_disconnected,
				'floodOnlyMapzone', v_flood_only_mapzone,
				'commitChanges', v_commit_changes,
				'netscenario', v_netscenario,
				'fromZero', v_from_zero
			)
		)
	);

	IF v_mapzones_version = 1 THEN
		RETURN gw_fct_graphanalytics_mapzones_v1(v_data::jsonb);
	ELSE
		RETURN gw_fct_graphanalytics_mapzones(v_data);
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
