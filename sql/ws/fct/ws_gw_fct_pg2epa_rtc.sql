/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2330


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_rtc(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_rtc(result_id_var character varying)  RETURNS integer AS $BODY$
DECLARE

rec_options 	record;
node_rec	record;
demand_aux	double precision;
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO rec_options FROM inp_options;

	RAISE NOTICE 'Starting pg2epa process.';
	
	-- Reset values of inp_rpt table
	UPDATE rpt_inp_node SET demand=0 WHERE result_id=result_id_var;

	-- Updating values from rtc into inp_rpt table
	FOR node_rec IN SELECT * FROM v_rtc_hydrometer_x_node_period
	LOOP
		IF rec_option.rtc_coefficient='MIN' THEN
			demand_aux:=node_rec.lps_min;
		ELSIF rec_option.rtc_coefficient='AVG' THEN
			demand_aux:=node_rec.lps_avg;
		ELSIF rec_option.rtc_coefficient='MAX' THEN
			demand_aux:=node_rec.lps_max;
		ELSIF rec_option.rtc_coefficient='REAL' THEN
			demand_aux:=node_rec.lps_avg_real;
		END IF;
			
		UPDATE rpt_inp_node SET demand=demand_aux WHERE result_id=result_id_var AND node_id=node_rec.node_id;

	END LOOP;


RETURN 1;

ALTER TABLE SCHEMA_NAME.v_inp_demand
  OWNER TO postgres;












	
	
RETURN 1;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;