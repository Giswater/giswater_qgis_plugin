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
v_demandtype integer;
v_patternmethod integer;
v_networkmode integer;
v_uniquepattern text;
v_queryfrom text;
      
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get user values
	v_uniquepattern = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_pattern' and cur_user = current_user);
	v_units =  (SELECT value FROM config_param_user WHERE parameter='inp_options_units' AND cur_user=current_user);
	v_demandtype = (SELECT value FROM config_param_user WHERE parameter='inp_options_demandtype' AND cur_user=current_user);
	v_patternmethod = (SELECT value FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user); 
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);

	EXECUTE 'SELECT (value::json->>'||quote_literal(v_units)||')::float FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunits;

	RAISE NOTICE ' DEMAND TYPE: % PATTERN METHOD: %', v_demandtype, v_patternmethod;

	-- Reset values of inp_rpt table
	UPDATE temp_node SET demand=0, pattern_id=null;

	-- delete previous results on rpt_inp_pattern_value
	DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;	

	-- save previous values to set hydrometer selector
	DELETE FROM temp_table WHERE fid=199 AND cur_user=current_user;
	INSERT INTO temp_table (fid, text_column)
	SELECT 199, (array_agg(state_id)) FROM selector_state WHERE cur_user=current_user;

	DELETE FROM temp_table WHERE fid=357 AND cur_user=current_user;
	INSERT INTO temp_table (fid, text_column)
	SELECT 358, (array_agg(state_id)) FROM selector_hydrometer WHERE cur_user=current_user;

	-- reset selector
	INSERT INTO selector_hydrometer SELECT id, current_user FROM ext_rtc_hydrometer_state
	ON CONFLICT (state_id, cur_user) DO NOTHING;

	
	IF v_demandtype = 1 THEN -- NODE ESTIMATED

		IF v_patternmethod = 11 THEN -- UNIQUE ESTIMATED (NODE)
			-- demand & pattern
			UPDATE temp_node SET demand=inp_junction.demand, pattern_id = v_uniquepattern
			FROM inp_junction WHERE temp_node.node_id=inp_junction.node_id;	
			
		ELSIF v_patternmethod = 12 THEN -- DMA ESTIMATED (NODE)
			-- demand
			UPDATE temp_node SET demand=inp_junction.demand 
			FROM inp_junction WHERE temp_node.node_id=inp_junction.node_id;
			-- pattern
			UPDATE temp_node SET pattern_id=dma.pattern_id 
			FROM node JOIN dma ON dma.dma_id=node.dma_id WHERE temp_node.node_id=node.node_id;
		
		ELSIF v_patternmethod = 13 THEN -- NODE ESTIMATED (NODE)
			-- demand & pattern
			UPDATE temp_node SET pattern_id=a.pattern_id, demand = a.demand
			FROM inp_junction a WHERE temp_node.node_id=a.node_id;
		END IF;

	ELSIF v_demandtype = 2 THEN -- CONNEC ESTIMATED
						
		IF v_patternmethod  = 21 THEN -- UNIQUE ESTIMATED (PJOINT)
			-- demand & pattern
			UPDATE temp_node SET demand=sum::numeric(12,8), pattern_id = v_uniquepattern 
			FROM vi_pjoint WHERE concat('VN', pjoint_id) = node_id;

		ELSIF v_patternmethod  = 22 THEN -- DMA ESTIMATED (PJOINT)
			-- demand
			UPDATE temp_node SET demand=sum::numeric(12,8) 
			FROM vi_pjoint WHERE concat('VN', pjoint_id) = node_id;
			-- pattern
			UPDATE temp_node SET pattern_id=dma.pattern_id 
			FROM v_edit_inp_connec JOIN dma USING (dma_id) WHERE temp_node.node_id=concat('VN',pjoint_id);
		
		ELSIF v_patternmethod = 23 THEN -- CONNEC ESTIMATED (PJOINT)
			-- demand & pattern			
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM vi_pjointpattern JOIN vnode ON pattern_id=concat('VN',vnode_id::text) JOIN v_edit_link ON exit_id::integer = vnode_id
			UNION
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM vi_pjointpattern JOIN node ON pattern_id=node_id ORDER by 3,4;		

			UPDATE temp_node SET demand = 1, pattern_id=node_id FROM vi_pjoint WHERE node_id = concat('VN',pjoint_id) AND pjoint_type = 'VNODE';
			UPDATE temp_node SET demand = 1, pattern_id=node_id FROM vi_pjoint WHERE node_id = pjoint_id AND pjoint_type = 'NODE';
		END IF;	
		
	ELSIF v_demandtype = 3 THEN -- SIMPLIFIED PERIOD (losses as unique multiplier for the whole system)

		IF v_patternmethod = 31 THEN -- UNIQUE PERIOD (NODE)
			-- demand & pattern
			UPDATE temp_node SET demand = ((lps_avg*v_epaunits))::numeric(12,8), pattern_id = v_uniquepattern
			FROM v_rtc_period_node n JOIN ext_rtc_dma_period d ON n.dma_id=d.dma_id AND n.period_id=d.cat_period_id
			WHERE n.node_id=temp_node.node_id;

		ELSIF v_patternmethod = 32 THEN	-- HYDRO PERIOD (NODE)
			-- demand & pattern			
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_nodepattern JOIN vnode ON pattern_id=concat('VN',vnode_id::text) JOIN v_edit_link ON exit_id::integer = vnode_id
			UNION
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_nodepattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE temp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id
			FROM v_rtc_period_nodepattern a WHERE node_id = a.pattern_id;

		ELSIF v_patternmethod = 33 THEN	-- UNIQUE PERIOD (PJOINT)
			-- demand & pattern						
			UPDATE temp_node SET demand = ((lps_avg*v_epaunits))::numeric(12,8), pattern_id = v_uniquepattern 
			FROM v_rtc_period_pjoint 
			WHERE node_id = pjoint_id;

		ELSIF v_patternmethod = 34 THEN	-- HYDRO PERIOD (PJOINT)
			-- demand & pattern			
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN vnode ON pattern_id=concat('VN',vnode_id::text) JOIN v_edit_link ON exit_id::integer = vnode_id
			UNION
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE temp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id 
			FROM v_rtc_period_pjointpattern a WHERE node_id = a.pattern_id;
		END IF;

	ELSIF v_demandtype = 4 THEN  -- DMA EFICIENCY PERIOD (losses as eficiency factor for each dma-period)

		IF v_patternmethod = 41 THEN -- DMA PERIOD (NODE)
			-- demand & pattern
			UPDATE temp_node SET demand=((lps_avg*v_epaunits)/d.effc)::numeric(12,8), pattern_id = d.pattern_id
			FROM v_rtc_period_node n JOIN ext_rtc_dma_period d ON n.dma_id=d.dma_id AND n.period_id=d.cat_period_id
			WHERE n.node_id=temp_node.node_id;

		ELSIF v_patternmethod = 42 THEN	-- HYDRO PERIOD (NODE)
			-- demand & pattern			
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9,
				factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9,
				factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
				FROM v_rtc_period_nodepattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE temp_node SET demand = ((1*v_epaunits))::numeric(12,8), pattern_id = node_id 
			FROM v_rtc_period_nodepattern a WHERE node_id = a.pattern_id;
							 
		ELSIF v_patternmethod = 43 THEN	-- DMA PERIOD (PJOINT)
			-- demand & pattern						
			UPDATE temp_node SET demand = ((lps_avg*v_epaunits)/v.effc)::numeric(12,8), pattern_id = t.pattern_id 
			FROM v_rtc_period_pjoint v, ext_rtc_dma_period t WHERE v.dma_id = t.dma_id AND v.period_id = t.cat_period_id
			AND node_id = pjoint_id;

		ELSIF v_patternmethod = 44 THEN -- HYDRO PERIOD (PJOINT)
			-- demand & pattern			
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN vnode ON pattern_id=concat('VN',vnode_id::text) JOIN v_edit_link ON exit_id::integer = vnode_id
			UNION
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE temp_node SET demand = ((1*v_epaunits)), pattern_id=node_id 
			FROM v_rtc_period_pjointpattern a WHERE node_id = a.pattern_id;
		END IF;
	
	ELSIF v_demandtype = 5	THEN -- DMA PERIOD
	
		IF v_patternmethod = 51 THEN -- DMA PERIOD (NODE)
		
			-- scale pattern from unitary to volumetric
			INSERT INTO rpt_inp_pattern_value (
				result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 				
			SELECT  result_id_var, ext.dma_id::integer, ext.pattern_id, i.id,
				factor_1*pattern_volume, factor_2*pattern_volume, factor_3*pattern_volume, factor_4*pattern_volume, 
				factor_5*pattern_volume, factor_6*pattern_volume, factor_7*pattern_volume, factor_8*pattern_volume, factor_9*pattern_volume, 
				factor_10*pattern_volume, factor_11*pattern_volume, factor_12*pattern_volume, factor_13*pattern_volume, factor_14*pattern_volume, 
				factor_15*pattern_volume, factor_16*pattern_volume, factor_17*pattern_volume, factor_18*pattern_volume 
				FROM v_rtc_period_dma v JOIN ext_rtc_dma_period ext ON v.dma_id=ext.dma_id::integer
				JOIN inp_pattern_value i ON i.pattern_id = v.pattern_id
				WHERE ext.cat_period_id = period_id;
				
			-- demand & pattern
			UPDATE temp_node SET demand=(a.m3_total_period/c.m3_total_period)*v_epaunits::numeric(12,8), pattern_id=c.pattern_id 
			FROM v_rtc_period_node a JOIN v_rtc_period_dma c ON a.dma_id::integer=c.dma_id
			WHERE temp_node.node_id=a.node_id;

		ELSIF v_patternmethod = 52 THEN	-- HYDRO PERIOD (NODE)

			-- set variable to use later to build the query of calibration
			v_queryfrom = 'v_rtc_period_nodepattern join node ON (node_id=pattern_id)';													

			-- demand & pattern
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_nodepattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE temp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id;

		ELSIF v_patternmethod = 53 THEN	-- DMA PERIOD (PJOINT)

			INSERT INTO rpt_inp_pattern_value (
				result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 				
			SELECT  result_id_var, ext.dma_id::integer, ext.pattern_id, i.id,
				factor_1*pattern_volume, factor_2*pattern_volume, factor_3*pattern_volume, factor_4*pattern_volume, 
				factor_5*pattern_volume, factor_6*pattern_volume, factor_7*pattern_volume, factor_8*pattern_volume, factor_9*pattern_volume, 
				factor_10*pattern_volume, factor_11*pattern_volume, factor_12*pattern_volume, factor_13*pattern_volume, factor_14*pattern_volume, 
				factor_15*pattern_volume, factor_16*pattern_volume, factor_17*pattern_volume, factor_18*pattern_volume 
				FROM v_rtc_period_dma v JOIN ext_rtc_dma_period ext ON v.dma_id=ext.dma_id::integer
				JOIN inp_pattern_value i ON i.pattern_id = v.pattern_id
				WHERE ext.cat_period_id = period_id;
				
			-- demand & pattern
			UPDATE temp_node SET demand=(a.m3_total_period*v_epaunits/c.m3_total_period)::numeric(12,8), pattern_id=c.pattern_id 
			FROM v_rtc_period_pjoint a JOIN v_rtc_period_dma c ON a.dma_id::integer=c.dma_id
			WHERE temp_node.node_id=a.pjoint_id;
							

		ELSIF v_patternmethod = 54 THEN -- HYDRO PERIOD (PJOINT)

			-- set variable to use later to build the query of calibration
			v_queryfrom = 'v_rtc_period_pjointpattern join connec ON (pjoint_id=pattern_id)';
		
			-- demand & pattern			
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT 1, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN vnode ON pattern_id=concat('VN',vnode_id::text) JOIN link ON exit_id::integer = vnode_id AND exit_type = 'VNODE' JOIN connec ON link.feature_id = connec_id
			UNION
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE temp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id 
			WHERE node_id IN (SELECT DISTINCT pattern_id FROM rpt_inp_pattern_value WHERE result_id=result_id_var);
	
		END IF;

		IF v_patternmethod IN (52,54) THEN -- pattern need to be calibrated using dma volume pattern values

			EXECUTE '
			UPDATE rpt_inp_pattern_value p SET factor_1=p.factor_1/e.f1,factor_2=p.factor_2/e.f2,factor_3=p.factor_3/e.f3,factor_4=p.factor_4/e.f4,factor_5=p.factor_5/e.f5,factor_6=p.factor_6/e.f6,
			factor_7=p.factor_7/e.f7,factor_8=p.factor_8/e.f8 , factor_9=p.factor_9/e.f9  ,factor_10=p.factor_10/e.f10 ,factor_11=p.factor_11/e.f11, factor_12=p.factor_12/e.f12,factor_13=p.factor_13/e.f13, 
			factor_14=p.factor_14/e.f14 , factor_15=p.factor_15/e.f15,factor_16=p.factor_16/e.f16,factor_17=p.factor_17/e.f17  ,factor_18=p.factor_18/e.f18

			FROM (-- coefficients from a & d. a as sum(nodes from dma) and d as real flow on dma
				SELECT  a.dma_id, a.idrow, a.f1/d.f1 as f1 , a.f2/d.f2 as f2 , a.f3/d.f3 as f3 , 
				a.f4/d.f4 as f4 , a.f5/d.f5 as f5 , a.f6/d.f6 as f6 , a.f7/d.f7 as f7 , 
				a.f8/d.f8 as f8 , a.f9/d.f9 as f9 , a.f10/d.f10 as f10 , a.f11/d.f11 as f11 ,
				a.f12/d.f12 as f12 , a.f13/d.f13 as f13 , a.f14/d.f14 as f14 , 
				a.f15/d.f15 as f15 , a.f16/d.f16 as f16 , a.f17/d.f17 as f17 , a.f18/d.f18 as f18
				
				FROM (
					-- node / pjoint query looking for hydro values group by dma
					SELECT dma_id, period_id, idrow, sum(factor_1) as f1, sum(factor_2) as f2, sum(factor_3) as f3, sum(factor_4) as f4, 
					sum(factor_5) as f5, sum(factor_6) as f6, sum(factor_7) as f7, sum(factor_8) as f8, sum(factor_9) as f9,
					sum(factor_10) as f10, sum(factor_11) as f11, sum(factor_12) as f12, sum(factor_13) as f13, sum(factor_14) as f14, 
					sum(factor_15) as f15, sum(factor_16) as f16, sum(factor_17) as f17, sum(factor_18) as f18
					FROM '||v_queryfrom||' group by idrow, period_id, dma_id order by 1,3
					)a

					-- dma query looking for total flow values for each dma
					JOIN (
						SELECT dma_id,cat_period_id,idrow, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18 
						FROM (
							SELECT ( CASE
							WHEN b.id = ((SELECT min(sub.id) FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 1 
							WHEN b.id = ((SELECT min(sub.id)+1 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 2 
							WHEN b.id = ((SELECT min(sub.id)+2 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 3 
							WHEN b.id = ((SELECT min(sub.id)+3 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 4
							WHEN b.id = ((SELECT min(sub.id)+4 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 5 
							WHEN b.id = ((SELECT min(sub.id)+5 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 6 
							WHEN b.id = ((SELECT min(sub.id)+6 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 7 				
							WHEN b.id = ((SELECT min(sub.id)+7 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 8 				
							WHEN b.id = ((SELECT min(sub.id)+8 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 9 				
							WHEN b.id = ((SELECT min(sub.id)+9 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 10
							WHEN b.id = ((SELECT min(sub.id)+10 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 11
							WHEN b.id = ((SELECT min(sub.id)+11 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 12 
							WHEN b.id = ((SELECT min(sub.id)+12 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 13 
							WHEN b.id = ((SELECT min(sub.id)+13 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 14
							WHEN b.id = ((SELECT min(sub.id)+14 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 15 
							WHEN b.id = ((SELECT min(sub.id)+15 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 16 
							WHEN b.id = ((SELECT min(sub.id)+16 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 17 				
							WHEN b.id = ((SELECT min(sub.id)+17 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 18 				
							WHEN b.id = ((SELECT min(sub.id)+18 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 19 				
							WHEN b.id = ((SELECT min(sub.id)+19 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 20 
							WHEN b.id = ((SELECT min(sub.id)+20 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 21
							WHEN b.id = ((SELECT min(sub.id)+21 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 22 
							WHEN b.id = ((SELECT min(sub.id)+22 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 23 
							WHEN b.id = ((SELECT min(sub.id)+23 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 24
							WHEN b.id = ((SELECT min(sub.id)+24 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 25 
							WHEN b.id = ((SELECT min(sub.id)+25 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 26 
							WHEN b.id = ((SELECT min(sub.id)+26 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 27 				
							WHEN b.id = ((SELECT min(sub.id)+27 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 28 				
							WHEN b.id = ((SELECT min(sub.id)+28 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 29 				
							WHEN b.id = ((SELECT min(sub.id)+29 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 30 	
							END) AS idrow,
							dma_id,
							cat_period_id,
							factor_1*pattern_volume as f1, factor_2*pattern_volume as f2, factor_3*pattern_volume as f3, factor_4*pattern_volume as f4, 
							factor_5*pattern_volume as f5, factor_6*pattern_volume as f6, factor_7*pattern_volume as f7, factor_8*pattern_volume as f8, 
							factor_9*pattern_volume as f9, factor_10*pattern_volume as f10, factor_11*pattern_volume as f11, factor_12*pattern_volume as f12,
							factor_13*pattern_volume as f13, factor_14*pattern_volume as f14, factor_15*pattern_volume as f15, factor_16*pattern_volume as f16, 
							factor_17*pattern_volume as f17, factor_18*pattern_volume as f18 
							FROM ext_rtc_dma_period 
							JOIN inp_pattern_value b USING (pattern_id) 
							WHERE cat_period_id  = (SELECT value FROM config_param_user WHERE parameter = ''inp_options_rtc_period_id'' AND cur_user = current_user)
						) c order by 1,3	
					) d ON a.dma_id=d.dma_id::integer AND a.idrow=d.idrow
				) e
			WHERE p.idrow=e.idrow and p.dma_id=e.dma_id';
		END IF;
	END IF;

	IF v_patternmethod IN (11,12,13,21,22,31,33,41,43) THEN

		-- move patterns from inp_pattern_value to rpt_pattern_value
		INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
		SELECT result_id_var, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, 
			factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
			FROM inp_pattern_value WHERE pattern_id IN (SELECT pattern_id FROM temp_node);
	END IF;

	-- restore state selector
	INSERT INTO selector_state (state_id, cur_user)
	select unnest(text_column::integer[]), current_user from temp_table where fid=199 and cur_user=current_user
	ON CONFLICT (state_id, cur_user) DO NOTHING;

	-- restore hydrometer selector
	INSERT INTO selector_hydrometer (state_id, cur_user)
	select unnest(text_column::integer[]), current_user from temp_table where fid=357 and cur_user=current_user
	ON CONFLICT (state_id, cur_user) DO NOTHING;

	UPDATE rpt_inp_node SET pattern_id = null WHERE demand = 0;

RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;