/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2330

/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2330


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_rtc(result_id_var character varying)  RETURNS integer AS 
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_rtc('p1')
*/

DECLARE
	v_rec		record;
	v_demand	double precision;
	v_epaunits	double precision;
	v_units 	text;
	v_sql 		text;
	v_demandtype 	integer;
	v_patternmethod integer;
	v_timestep	text;
	v_networkmode   integer;
      
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa rtc.';

	-- get user values
	v_units =  (SELECT value FROM config_param_user WHERE parameter='inp_options_units' AND cur_user=current_user);
	v_demandtype = (SELECT value FROM config_param_user WHERE parameter='inp_options_demandtype' AND cur_user=current_user);
	v_patternmethod = (SELECT value FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user); 
	v_timestep = (SELECT value FROM config_param_user WHERE parameter='inp_times_duration' AND cur_user=current_user); 
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);

	EXECUTE 'SELECT (value::json->>'||quote_literal(v_units)||')::float FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunits;


	RAISE NOTICE ' DEMAND TYPE: % PATTERN METHOD: %', v_demandtype, v_patternmethod;

	-- starting pattern methods
	IF v_demandtype = 1 THEN

		IF v_patternmethod = 11 THEN	-- UNIQUE ESTIMATED 
		
	
		ELSIF v_patternmethod = 12 THEN -- DMA ESTIMATED
						-- Unique pattern applied to the whole dma
						
			UPDATE rpt_inp_node SET pattern_id=dma.pattern_id 
			FROM node JOIN dma ON dma.dma_id=node.dma_id WHERE rpt_inp_node.node_id=node.node_id AND result_id=result_id_var;

		ELSIF v_patternmethod = 13 THEN -- NODE ESTIMATED
		
			
		ELSIF v_patternmethod = 14 THEN -- CONNEC ESTIMATED
						-- update demands & patterns, demand is calculated on pattern. Only need units factor. Patterns are sumatory of demands by pattern. 
						-- Values patterns are expressed on l/s. Due this v_epaunits is mandatory to convert values
			
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, concat('VN',pattern_id::text), idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_inp_pjointpattern JOIN vnode ON pattern_id=vnode_id::text
			UNION
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_inp_pjointpattern JOIN node ON pattern_id=node_id ORDER by 3,4;		

			UPDATE rpt_inp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id 
			WHERE node_id IN (SELECT DISTINCT pattern_id FROM rpt_inp_pattern_value WHERE result_id=result_id_var) AND result_id=result_id_var;
		
		END IF;
	

	ELSIF v_demandtype = 2 THEN

		-- Reset values of inp_rpt table
		UPDATE rpt_inp_node SET demand=0, pattern_id=null WHERE result_id=result_id_var;

		IF v_patternmethod = 21 THEN		-- NODE MINC PERIOD
			UPDATE rpt_inp_node SET demand=(lps_min::float*v_epaunits)::numeric(12,8), pattern_id=NULL 
			FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
			
		ELSIF v_patternmethod = 22 THEN		-- NODE MAXC PERIOD
			UPDATE rpt_inp_node SET demand=(lps_max::float*v_epaunits)::numeric(12,8), pattern_id=NULL 
			FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;

		ELSIF v_patternmethod = 23 THEN  	-- DMA PERIOD (Vilablareix model)
							-- Demand is real demand (l/s). Need units factor and DMAxPERIOD efficiency
							-- Patterns is estimated unitary pattern for dma applied to each node of that dma.
			UPDATE rpt_inp_node SET demand=((lps_avg*v_epaunits)/d.effc)::numeric(12,8), pattern_id = d.pattern_id
						FROM v_rtc_period_node n 
						JOIN ext_rtc_scada_dma_period d ON n.dma_id=d.dma_id AND n.period_id=d.cat_period_id
						WHERE n.node_id=rpt_inp_node.node_id AND result_id=result_id_var;		

		ELSIF v_patternmethod = 24 THEN  	-- NODE PERIOD (Blanes model)
							-- Demand is calculated on pattern. Need units factor and DMAxPERIOD efficiency
							-- Patterns are sumatory(demand*pattern) of all hydrometers for each node and are expressed on l/s. It's mandatory to convert values

			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9,
				factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9,
				factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
				 FROM v_rtc_period_nodepattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE rpt_inp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id 
			WHERE node_id IN (SELECT DISTINCT pattern_id FROM rpt_inp_pattern_value WHERE result_id=result_id_var) AND result_id=result_id_var;				
		
	
		ELSIF v_patternmethod = 25 THEN 	-- DMA INTERVAL (Manresa model)
							-- Demand is weight factor on dma and are normalized (total node / total dma). 
							-- Patterns is the same for the whole dma and it's real flow from scada. Values are expressed on l/s. It's mandatory to convert values
					
			UPDATE rpt_inp_node SET demand=(a.m3_total_period*v_epaunits/c.m3_total_period)::numeric(12,8), pattern_id=c.pattern_id 
			FROM v_rtc_period_node a JOIN v_rtc_period_dma c ON a.dma_id::integer=c.dma_id
			WHERE rpt_inp_node.node_id=a.node_id AND result_id = result_id_var;	

		ELSIF v_patternmethod = 26 THEN 	-- NODE PERIOD - DMA INTERVAL (Manresa + Blanes mixed model)
							-- Demand is calculated on pattern. Only need units factor.
							-- Patterns are sumatory(demand*pattern) of all hydrometers for each node and are expressed on l/s. 
							-- It's mandatory to convert values
							-- The dma pattern it's used to calibrate 
																								
			-- insert into rpt_inp_pattern table values 
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_nodepattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE rpt_inp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id
			WHERE node_id IN (SELECT DISTINCT pattern_id FROM rpt_inp_pattern_value WHERE result_id=result_id_var) AND result_id=result_id_var;						

			-- calibration comparing dma pattern with node patterns
			UPDATE rpt_inp_pattern_value f SET factor_1=f.factor_1/e.factor_1, factor_2=f.factor_2/e.factor_2 , factor_3=f.factor_3/e.factor_3 , 
				factor_4=f.factor_4/e.factor_4 , factor_5=f.factor_5/e.factor_5 , factor_6=f.factor_6/e.factor_6 , factor_7=f.factor_7/e.factor_7 , 
				factor_8=f.factor_8/e.factor_8 , factor_9=f.factor_9/e.factor_9  ,factor_10=f.factor_10/e.factor_10 ,factor_11=f.factor_11/e.factor_11,
				factor_12=f.factor_12/e.factor_12 , factor_13=f.factor_13/e.factor_13 , factor_14=f.factor_14/e.factor_14 , factor_15=f.factor_15/e.factor_15 , 
				factor_16=f.factor_16/e.factor_16,factor_17=f.factor_17/e.factor_17  ,factor_18=f.factor_18/e.factor_18
				FROM 
				-- coefficients from a & d. a as sum(nodes from dma) and d as real flow on dma
				(SELECT  a.dma_id, a.idrow, a.factor_1/d.factor_1 as factor_1 , a.factor_2/d.factor_2 as factor_2 , a.factor_3/d.factor_3 as factor_3 , 
				a.factor_4/d.factor_4 as factor_4 , a.factor_5/d.factor_5 as factor_5 , a.factor_6/d.factor_6 as factor_6 , a.factor_7/d.factor_7 as factor_7 , 
				a.factor_8/d.factor_8 as factor_8 , a.factor_9/d.factor_9 as factor_9 , a.factor_10/d.factor_10 as factor_10 , a.factor_11/d.factor_11 as factor_11 ,
				a.factor_12/d.factor_12 as factor_12 , a.factor_13/d.factor_13 as factor_13 , a.factor_14/d.factor_14 as factor_14 , 
				a.factor_15/d.factor_15 as factor_15 , a.factor_16/d.factor_16 as factor_16 , a.factor_17/d.factor_17 as factor_17 , a.factor_18/d.factor_18 as factor_18
				-- a query
				FROM (select dma_id, period_id, idrow, sum(factor_1) as factor_1, sum(factor_2) as factor_2, sum(factor_3) as factor_3, sum(factor_4) as factor_4, 
				sum(factor_5) as factor_5, sum(factor_6) as factor_6, sum(factor_7) as factor_7, sum(factor_8) as factor_8, sum(factor_9) as factor_9,
				sum(factor_10) as factor_10, sum(factor_11) as factor_11, sum(factor_12) as factor_12, sum(factor_13) as factor_13, sum(factor_14) as factor_14, 
				sum(factor_15) as factor_15, sum(factor_16) as factor_16, sum(factor_17) as factor_17, sum(factor_18) as factor_18
						FROM v_rtc_period_nodepattern join node ON (node_id=pattern_id) group by idrow, period_id, dma_id order by 1,3)a
				-- d query
				JOIN (SELECT dma_id, cat_period_id ,  idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
					factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 FROM  
					(SELECT ( CASE
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
					END) AS idrow,dma_id,cat_period_id,
					factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
					factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
					FROM ext_rtc_scada_dma_period 
					JOIN inp_pattern_value b USING (pattern_id)) c order by 1,3) d ON a.dma_id=d.dma_id::integer AND a.idrow=d.idrow) e

			WHERE f.idrow=e.idrow and f.dma_id=e.dma_id;
	
		ELSIF v_patternmethod = 27 THEN 	-- CONNEC PERIOD (Guipuzkoako urak model)
							-- Demand is calculated on pattern. Only need units factor. 
							-- Patterns are sumatory(demand*pattern) of all hydrometers for each pjoint (VNODE or NODE) are expressed on l/s. 
							-- It's mandatory to convert values
	
			DELETE FROM rpt_inp_pattern_value WHERE result_id=result_id_var;
			INSERT INTO rpt_inp_pattern_value (
				   result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) 
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN vnode ON pattern_id=concat('VN',vnode_id::text)
			UNION
			SELECT result_id_var, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
				   factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
				   FROM v_rtc_period_pjointpattern JOIN node ON pattern_id=node_id ORDER by 3,4;

			UPDATE rpt_inp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=node_id 
			WHERE node_id IN (SELECT DISTINCT pattern_id FROM rpt_inp_pattern_value WHERE result_id=result_id_var) AND result_id=result_id_var;

		ELSIF v_patternmethod = 28 THEN
		
			-- TODO: pattern Blanes + Gipuzkoako Urak (using vnodes) + Manresa models

		END IF;

	ELSIF v_demandtype = 3 THEN

			IF v_patternmethod = 31 THEN -- TODO

			ELSIF v_patternmethod = 32 THEN -- TODO
			
			END IF;
	END IF;
	
	-- profilactic control of null demands (because epanet cmd does not runs with null demands
	UPDATE rpt_inp_node SET demand=0 WHERE result_id=result_id_var AND demand IS NULL;
	
RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;