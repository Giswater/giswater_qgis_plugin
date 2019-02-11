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

v_options 	record;
v_rec		record;
v_demand	double precision;
v_epaunitsfactor double precision;
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO v_options FROM inp_options;

	RAISE NOTICE 'Starting pg2epa rtc.';
	
	-- Reset values of inp_rpt table
	UPDATE rpt_inp_node SET demand=0 WHERE result_id=result_id_var;

	EXECUTE 'SELECT value::json->>'||quote_literal(v_options.units)||' FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunitsfactor;

	-- Updating values from rtc into inp_rpt table
	IF v_options.rtc_coefficient='MIN' THEN
		UPDATE rpt_inp_node SET demand=lps_min::numeric(12,6)*v_epaunitsfactor FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
	ELSIF v_options.rtc_coefficient='AVG' THEN
		UPDATE rpt_inp_node SET demand=lps_avg::numeric(12,6)*v_epaunitsfactor FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
	ELSIF v_options.rtc_coefficient='MAX' THEN
		UPDATE rpt_inp_node SET demand=lps_max::numeric(12,6)*v_epaunitsfactor FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
	ELSIF v_options.rtc_coefficient='REAL' THEN
		UPDATE rpt_inp_node SET demand=lps_avg::numeric(12,6)*v_epaunitsfactor FROM v_rtc_hydrometer_x_node_period a WHERE result_id=result_id_var AND rpt_inp_node.node_id=a.node_id;
	END IF;
	
RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;