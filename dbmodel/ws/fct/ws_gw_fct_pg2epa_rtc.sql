/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2330


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_rtc(result_id_var character varying)  RETURNS integer AS 
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_rtc('r1')
*/

DECLARE
	v_rec		record;
	v_demand	double precision;
	v_epaunits	double precision;
	v_units 	text;
	v_sql 		text;
	v_demandtype 	text;
	v_patternmethod text;
	v_timestep	text;
      
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa rtc.';

	-- get user values
	v_units =  (SELECT value FROM config_param_user WHERE parameter='inp_options_units' AND cur_user=current_user);
	v_demandtype = (SELECT value FROM config_param_user WHERE parameter='inp_options_demandtype' AND cur_user=current_user);
	v_patternmethod = (SELECT value FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user); 
	v_timestep = (SELECT value FROM config_param_user WHERE parameter='inp_times_duration' AND cur_user=current_user); 
	EXECUTE 'SELECT (value::json->>'||quote_literal(v_units)||')::float FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunits;

	-- profilactic control of null demands (because epanet cmd does not runs with null demands
	UPDATE rpt_inp_node SET demand=0 WHERE result_id=result_id_var AND demand IS NULL;

	-- reset pattern method if 11 is not used (unique estimated pattern)
	IF v_patternmethod::integer > 11 THEN
		UPDATE config_param_user SET value=null WHERE parameter='inp_options_pattern' and cur_user=current_user;
	END IF;

	-- starting pattern methods
	IF v_demandtype = '1' THEN
	
		IF v_patternmethod = '12' THEN
			UPDATE rpt_inp_node SET pattern_id=dma.pattern_id FROM node JOIN dma ON dma.dma_id=node.dma_id WHERE rpt_inp_node.node_id=node.node_id AND result_id=result_id_var;
		END IF;

	ELSIF v_demandtype = '2' THEN

		-- Reset values of inp_rpt table
		UPDATE rpt_inp_node SET demand=0, pattern_id=null WHERE result_id=result_id_var;

		IF v_patternmethod = '21' THEN
			UPDATE rpt_inp_node SET demand=(lps_min::float*v_epaunits)::numeric(12,8), pattern_id=NULL FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
			
		ELSIF v_patternmethod = '22' THEN
			UPDATE rpt_inp_node SET demand=(lps_max::float*v_epaunits)::numeric(12,8), pattern_id=NULL FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
			
		ELSIF v_patternmethod = '23' THEN  --pattern Blanes model

			-- update demands & patterns
			UPDATE rpt_inp_node SET demand=(1*v_epaunits)::numeric(12,8), pattern_id=concat('pat_',a.node_id) -- normalized demand and transformed by units factor
				FROM v_rtc_period_node a
				WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;

				
		ELSIF v_patternmethod = '24' THEN -- pattern Manresa model
			UPDATE rpt_inp_node SET demand=(lps_avg_real*v_epaunits/m3_total_period)::numeric(12,8), pattern_id=b.pattern_id -- m3_hydrometer from hydrometer and m3_total_period from dma
				FROM v_rtc_period_node a
				JOIN v_rtc_period_dma b ON a.dma_id=b.dma_id AND a.period_id=b.period_id
				WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;

		ELSIF v_patternmethod = '25' THEN -- pattern Manresa + Blanes mixed models
			-- TODO....
		END IF;


	ELSIF v_demandtype = '3' THEN

		-- TODO....

	END IF;
	
	
RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;