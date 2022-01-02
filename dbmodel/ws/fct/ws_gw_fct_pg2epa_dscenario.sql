/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2456

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_dscenario (result_id_var character varying)  
RETURNS integer AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_dscenario('prognosi')
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"data":{ "resultId":"test_bgeo_b1", "useNetworkGeom":"false"}}$$)

SELECT * FROM SCHEMA_NAME.temp_node WHERE node_id = 'VN257816';
*/

DECLARE
v_demandpriority integer; 
v_querytext text;
v_patternmethod integer;
v_userscenario integer[];
v_networkmode integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa for filling demand scenario';

	IF (SELECT count(*) FROM selector_inp_dscenario WHERE cur_user = current_user) > 0 THEN

		v_networkmode = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
		v_demandpriority = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_dscenario_priority' AND cur_user=current_user);
		v_patternmethod = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user);
		v_userscenario = (SELECT array_agg(dscenario_id) FROM selector_inp_dscenario where cur_user=current_user);

		-- moving connec demands to linked object which is exported	
		IF v_networkmode IN(1,2) THEN

			INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id, demand_type, source)
			SELECT dscenario_id, node_1 AS node_id, d.demand/2 as demand, d.pattern_id, demand_type, source FROM temp_arc JOIN v_edit_inp_connec USING (arc_id)
			JOIN inp_dscenario_demand d ON feature_id = connec_id WHERE dscenario_id IN (SELECT unnest(v_userscenario))
			UNION ALL
			SELECT dscenario_id, node_2 AS node_id, d.demand/2 as demand, d.pattern_id, demand_type, source  FROM temp_arc JOIN v_edit_inp_connec USING (arc_id)
			JOIN inp_dscenario_demand d ON feature_id = connec_id WHERE dscenario_id IN (SELECT unnest(v_userscenario));
			
		ELSIF v_networkmode = 3 THEN
		
			INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id,  demand_type, source)
			SELECT dscenario_id, n.node_id, d.demand, d.pattern_id, demand_type, source 
			FROM  inp_dscenario_demand d ,temp_node n
			JOIN connec c ON concat('VN',c.pjoint_id) =  n.node_id
			WHERE c.connec_id = d.feature_id AND d.demand IS NOT NULL AND d.demand <> 0  
			AND dscenario_id IN (SELECT unnest(v_userscenario));

		ELSIF v_networkmode = 4 THEN
			-- nothing to do because it is automatic. Connec exists as feature exported
		END IF;

		-- remove those demands which for some reason linked node is not exported
		DELETE FROM temp_demand WHERE feature_id IN (SELECT feature_id FROM temp_demand EXCEPT select node_id FROM temp_node);

		-- demands for virtual connec (3 , 4 only)
		INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id,  demand_type, source)
		SELECT dscenario_id, n.node_id, d.demand, d.pattern_id, demand_type, source 
		FROM  inp_dscenario_demand d ,temp_node n
		JOIN connec c ON concat('VC',c.pjoint_id) =  n.node_id
		WHERE c.connec_id = d.feature_id AND d.demand IS NOT NULL AND d.demand <> 0  
		AND dscenario_id IN (SELECT unnest(v_userscenario));

		-- update demands
		IF v_demandpriority = 1 THEN -- Dscenario overwrites base demand
			-- EPANET standard 
			
		ELSIF v_demandpriority = 2 THEN -- Dscenario and base demand are joined,  moving to temp_demand in order to do not lose base demand (because EPANET does)

			-- moving node demands to temp_demand
			INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id)
			SELECT DISTINCT ON (node_id) 0, node_id, n.demand, n.pattern_id 
			FROM temp_node n
			JOIN temp_demand ON node_id = feature_id
			WHERE n.demand IS NOT NULL AND n.demand <> 0;
		END IF;
	
		-- update patterns in function of pattern method choosed
		IF v_patternmethod = 11 THEN
			UPDATE temp_demand SET pattern_id = null;

		ELSIF v_patternmethod = 12 THEN
			UPDATE temp_demand d SET pattern_id = s.pattern_id
			FROM sector s JOIN temp_node n USING (sector_id)
			WHERE d.feature_id = n.node_id;
		
		ELSIF v_patternmethod = 13 THEN
			UPDATE temp_demand d SET pattern_id = s.pattern_id
			FROM dma s JOIN temp_node n USING (dma_id)
			WHERE d.feature_id = n.node_id;

		ELSIF v_patternmethod = 14 THEN
			--do nothing
		END IF;
				
		-- move patterns used demands scenario table
		INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
		SELECT  result_id_var, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
			from inp_pattern_value p 
			WHERE 
			pattern_id IN (SELECT distinct (pattern_id) FROM inp_dscenario_demand d, selector_inp_dscenario s WHERE cur_user = current_user AND d.dscenario_id = s.dscenario_id) AND 
			pattern_id NOT IN (SELECT distinct (pattern_id) FROM temp_node WHERE pattern_id IS NOT NULL)
			order by pattern_id, id;	

		-- set cero where null in order to prevent user's null values on demand table
		UPDATE temp_node SET demand=0 WHERE demand IS NULL;

		-- updating values for pipes
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET minorloss = d.minorloss FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;
		UPDATE temp_arc t SET diameter = d.dint FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.dint IS NOT NULL;
		UPDATE temp_arc t SET roughness = d.roughness FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.roughness IS NOT NULL;

		-- updating values for shortpipes
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_shortpipe d 
		WHERE t.arc_id = concat(d.node_id, '_n2a') AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET minorloss = d.minorloss FROM v_edit_inp_dscenario_shortpipe d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;

		-- updating values for pumps
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a') AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'power',d.power) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.power IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'speed',d.speed) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.speed IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'pattern',d.pattern) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern IS NOT NULL;	

		-- updating values for valves
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a') AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'valv_type',d.valv_type) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.valv_type IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'pressure',d.pressure) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pressure IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'flow',d.flow) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flow IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'coef_loss',d.coef_loss) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.coef_loss IS NOT NULL;		
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minorloss',d.minorloss) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;		

		-- updating values for reservoir
		UPDATE temp_node t SET pattern_id = d.pattern_id FROM v_edit_inp_dscenario_reservoir d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern_id IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'head',d.head) FROM v_edit_inp_dscenario_reservoir d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.head IS NOT NULL;

		-- updating values for tanks
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'initlevel',d.initlevel) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.initlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minlevel',d.minlevel) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'maxlevel',d.maxlevel) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.maxlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'diameter',d.diameter) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.diameter IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minvol',d.minvol) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minvol IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;

	END IF;

	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;