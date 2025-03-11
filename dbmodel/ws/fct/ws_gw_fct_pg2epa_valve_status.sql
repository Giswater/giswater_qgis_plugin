/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2332

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_valve_status(varchar, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_valve_status(result_id_var varchar)
RETURNS integer AS
$BODY$

DECLARE

v_valverec record;
v_noderec record;
v_valvemode integer;
v_mincutresult integer;
v_networkmode integer;
v_querytext text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- shutoff valves (TCV OR SHORTPIPES)
	IF (SELECT value FROM config_param_system WHERE parameter = 'epa_shutoffvalve') = 'VALVE' THEN
		v_querytext = ' v_edit_inp_valve v WHERE addparam::json->>''valv_type'' = ''TCV''';
	ELSE
		v_querytext = ' v_edit_inp_shortpipe v WHERE node_id IS NOT NULL';
	END IF;

	EXECUTE ' UPDATE temp_t_arc a SET status=v.status FROM '||v_querytext||' AND a.arc_id=concat(v.node_id,''_n2a'')';

	-- all that not are closed are open
	UPDATE temp_t_arc SET status='OPEN' WHERE status IS NULL AND epa_type = 'SHORTPIPE';

	-- mandatory nodarcs
	UPDATE temp_t_arc a SET status=v.status FROM v_edit_inp_valve v WHERE a.arc_id=concat(v.node_id,'_n2a');

	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;