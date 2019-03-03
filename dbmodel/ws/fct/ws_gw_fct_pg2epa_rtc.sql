/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2330


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_rtc(result_id_var character varying)  RETURNS integer AS 
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_rtc('test88')
*/

DECLARE
	v_rec		record;
	v_demand	double precision;
	v_epaunitsfactor double precision;
	v_coefficient text;
	v_units text;
	v_sql text;
      
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa rtc.';

	-- get user values
	v_coefficient = (SELECT value FROM config_param_user WHERE parameter='inp_options_rtc_coefficient' AND cur_user=current_user);
	v_units =  (SELECT value FROM config_param_user WHERE parameter='inp_options_units' AND cur_user=current_user);
	
	-- Reset values of inp_rpt table
	UPDATE rpt_inp_node SET demand=0 WHERE result_id=result_id_var;

	EXECUTE 'SELECT (value::json->>'||quote_literal(v_units)||')::float FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunitsfactor;

	-- Updating values from rtc into inp_rpt table
	IF v_coefficient = 'MIN' THEN
		UPDATE rpt_inp_node SET demand=(lps_min::float*v_epaunitsfactor)::numeric(12,6) FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
	ELSIF v_coefficient = 'AVG' THEN
		UPDATE rpt_inp_node SET demand=(lps_avg::float*v_epaunitsfactor)::numeric(12,6) FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
	ELSIF v_coefficient = 'MAX' THEN
		UPDATE rpt_inp_node SET demand=(lps_max::float*v_epaunitsfactor)::numeric(12,6) FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;

		--v_sql = 'UPDATE rpt_inp_node SET demand=lps_max::numeric(12,6)*'||v_epaunitsfactor||' FROM v_rtc_hydrometer_x_node_period a WHERE result_id='||result_id_var||' AND rpt_inp_node.node_id=a.node_id';
		--raise exception 'v_sql %' ,v_sql;
		
	ELSIF v_coefficient = 'REAL' THEN
		UPDATE rpt_inp_node SET demand=lps_avg::numeric(12,6)*v_epaunitsfactor FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
	END IF;
	
RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;