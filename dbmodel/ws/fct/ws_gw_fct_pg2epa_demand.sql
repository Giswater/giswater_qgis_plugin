/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2330

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_demand(result_id_var character varying)  RETURNS integer AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_demand('v45')
*/

DECLARE

v_rec record;
v_demand double precision;
v_epaunits double precision;
v_units	text;
v_sql text;
v_patternmethod integer;
v_queryfrom text;
v_networkmode integer;
      
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get user values
	v_units =  (SELECT value FROM config_param_user WHERE parameter='inp_options_units' AND cur_user=current_user);
	v_patternmethod = (SELECT value FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user); 
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user); 


	EXECUTE 'SELECT (value::json->>'||quote_literal(v_units)||')::float FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunits;

	-- Reset values
	UPDATE temp_node SET demand = 0;
	UPDATE temp_node SET pattern_id = null WHERE epa_type = 'JUNCTION';

	-- delete previous results on rpt_inp_pattern_value
	DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;	

	-- save previous values to set hydrometer selector
	DELETE FROM temp_table WHERE fid=435 AND cur_user=current_user;
	INSERT INTO temp_table (fid, text_column)
	SELECT 435, (array_agg(state_id)) FROM selector_hydrometer WHERE cur_user=current_user;

	-- reset selector
	INSERT INTO selector_hydrometer SELECT id, current_user FROM ext_rtc_hydrometer_state
	ON CONFLICT (state_id, cur_user) DO NOTHING;

	
	IF v_networkmode IN (1,2) THEN -- NODE ESTIMATED

		-- demand on nodes
		UPDATE temp_node SET demand=inp_junction.demand FROM inp_junction WHERE temp_node.node_id=inp_junction.node_id;	

		-- pattern
		IF v_patternmethod = 12 THEN -- SECTOR PATTERN (NODE)
			UPDATE temp_node SET pattern_id=sector.pattern_id FROM node JOIN sector ON sector.sector_id=node.sector_id WHERE temp_node.node_id=node.node_id;
		
		ELSIF v_patternmethod = 13 THEN -- DMA PATTERN (NODE)
			UPDATE temp_node SET pattern_id=dma.pattern_id FROM node JOIN dma ON dma.dma_id=node.dma_id WHERE temp_node.node_id=node.node_id;
		
		ELSIF v_patternmethod = 14 THEN -- FEATURE PATTERN (NODE)
			UPDATE temp_node SET pattern_id=a.pattern_id FROM inp_junction a WHERE temp_node.node_id=a.node_id;
		END IF;

	ELSIF v_networkmode = 3 THEN

		-- demand on vnodes from associated connecs
		UPDATE temp_node SET demand=sum::float FROM vi_pjoint WHERE concat('VN', pjoint_id) = node_id ;
		
		-- demand on connecs over arc
		UPDATE temp_node SET demand=a.demand::float FROM v_edit_inp_connec a WHERE concat('VC', connec_id) = node_id;

		-- pattern	
		IF v_patternmethod  = 12 THEN -- SECTOR PATTERN (PJOINT)
			
			UPDATE temp_node SET pattern_id=sector.pattern_id 
			FROM v_edit_inp_connec JOIN sector USING (sector_id) WHERE concat('VN', pjoint_id) = node_id ;
			
			UPDATE temp_node SET pattern_id=sector.pattern_id 
			FROM v_edit_inp_connec JOIN sector USING (sector_id) WHERE concat('VC', connec_id) = node_id;
			
		ELSIF v_patternmethod  = 13 THEN -- DMA PATTERN (PJOINT)			
	
			UPDATE temp_node SET pattern_id=dma.pattern_id 
			FROM v_edit_inp_connec JOIN dma USING (dma_id) WHERE concat('VN', pjoint_id) = node_id ;
			
			UPDATE temp_node SET pattern_id=dma.pattern_id 
			FROM v_edit_inp_connec JOIN dma USING (dma_id) WHERE concat('VC', connec_id) = node_id;

		ELSIF v_patternmethod = 14 THEN -- FEATURE PATTERN (PJOINT)

			INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id, demand_type)
			SELECT 0, node_id, n.demand, c.pattern_id, 'BASE DEMAND' FROM temp_node n JOIN v_edit_inp_connec c ON concat('VN', pjoint_id) = node_id;

			INSERT INTO audit_check_data (fid, criticity, result_id, error_message)
			VALUES (227, 2, '272', concat('WARNING-227: Network export mode and Pattern method used forces to propagate values from [JUNCTION] to [DEMANDS] sections.'));
			INSERT INTO audit_check_data (fid, criticity, result_id, error_message)
			VALUES (227, 2, '272', concat('HINT: See EPANET file for more details.'));
		END IF;	
		
	ELSIF v_networkmode = 4 THEN 

		-- demand on connecs with associated link
		UPDATE temp_node SET demand=v.demand FROM v_edit_inp_connec v WHERE connec_id = node_id;
		
		-- demand on connecs over arc
		UPDATE temp_node SET demand=v.demand FROM v_edit_inp_connec v WHERE concat('VC',connec_id) = node_id;

		-- pattern
		IF v_patternmethod  = 12 THEN -- SECTOR PATTERN (CONNEC)

			-- pattern on connecs with associated link
			UPDATE temp_node SET pattern_id=sector.pattern_id 
			FROM v_edit_inp_connec JOIN sector USING (sector_id) WHERE connec_id = node_id;

			-- pattern on connecs over arc
			UPDATE temp_node SET pattern_id=sector.pattern_id 
			FROM v_edit_inp_connec JOIN sector USING (sector_id) WHERE concat('VC',connec_id) = node_id;

		ELSIF v_patternmethod  = 13 THEN -- DMA PATTERN (CONNEC)

			-- pattern on connecs with associated link
			UPDATE temp_node SET pattern_id=dma.pattern_id 
			FROM v_edit_inp_connec JOIN dma USING (dma_id) WHERE connec_id = node_id;
			
			-- pattern on connecs over arc
			UPDATE temp_node SET pattern_id=dma.pattern_id 
			FROM v_edit_inp_connec JOIN dma USING (dma_id) WHERE concat('VC',connec_id) = node_id;

		ELSIF v_patternmethod = 14 THEN -- FEATURE PATTERN (CONNEC)

			-- pattern on connecs with associated link
			UPDATE temp_node SET pattern_id=c.pattern_id 
			FROM v_edit_inp_connec c WHERE connec_id = node_id;

			-- pattern on connecs over arc
			UPDATE temp_node SET pattern_id=c.pattern_id 
			FROM v_edit_inp_connec c WHERE concat('VC',connec_id) = node_id;
		END IF;	
	END IF;

	-- move patterns from inp_pattern_value to rpt_pattern_value
	INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
		factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
	SELECT result_id_var, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, 
		factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
		FROM inp_pattern_value WHERE pattern_id IN (SELECT DISTINCT pattern_id FROM temp_node)
		ORDER BY id;

	-- restore hydrometer selector
	DELETE FROM selector_hydrometer WHERE cur_user = current_user;
	INSERT INTO selector_hydrometer (state_id, cur_user)
	select unnest(text_column::integer[]), current_user from temp_table where fid=435 and cur_user=current_user
	ON CONFLICT (state_id, cur_user) DO NOTHING;
	
	UPDATE temp_node SET demand = 0 WHERE demand is null;
	
RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;