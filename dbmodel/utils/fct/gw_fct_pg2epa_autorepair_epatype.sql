/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_autorepair_epatype(p_data json)
RETURNS json AS 
$BODY$

/* example

-- execute
SELECT SCHEMA_NAME.gw_fct_pg2epa_repair_epatype($${"client":{"device":4, "infoType":1, "lang":"ES"}}$$);


ALTER TABLE SCHEMA_NAME.cat_feature_node DROP CONSTRAINT node_type_epa_table_check;

ALTER TABLE SCHEMA_NAME.cat_feature_node
  ADD CONSTRAINT node_type_epa_table_check CHECK (epa_table::text = ANY (ARRAY['inp_virtualvalve'::text, 'inp_inlet'::text, 'not_defined'::text, 'inp_junction'::text, 'inp_pump'::text, 'inp_reservoir'::text, 'inp_tank'::text, 'inp_valve'::text, 'inp_shortpipe'::text]));


-- log
SELECT * FROM ws.audit_check_data where fid = 214 AND criticity  > 1 order by id

-- check
SELECT * FROM 
(SELECT epa_type, count(*) as count_node FROM node where state > 0 group by epa_type order by 2)a
FULL JOIN
(SELECT 'JUNCTION' AS epa_type, count(*) as count_inp FROM inp_junction join node using (node_id ) where state > 0
union
SELECT 'RESERVOIR', count(*) FROM inp_reservoir join node using (node_id ) where state > 0
union
SELECT 'PUMP', count(*) FROM inp_pump join node using (node_id ) where state > 0
union
SELECT 'TANK', count(*) FROM inp_tank join node using (node_id ) where state > 0
union
SELECT 'SHORTPIPE', count(*) FROM inp_shortpipe join node using (node_id ) where state > 0
union
SELECT 'VALVE', count(*) FROM inp_valve join node using (node_id ) where state > 0
union
SELECT 'INLET', count(*) FROM inp_inlet join node using (node_id ) where state > 0)b
USING (epa_type)




SELECT * FROM 
(SELECT epa_type, count(*) as count_node FROM node where state > 0 group by epa_type order by 2)a
FULL JOIN
(SELECT 'JUNCTION' AS epa_type, count(*) as count_inp FROM inp_junction join node using (node_id ) where state > 0
union
SELECT 'STORAGE', count(*) FROM inp_storage join node using (node_id ) where state > 0  
union
SELECT 'DIVIDER', count(*) FROM inp_divider join node using (node_id ) where state > 0 
union
SELECT 'OUTFALL', count(*) FROM inp_outfall join node using (node_id ) where state > 0  )b
USING (epa_type)


SELECT * FROM 
(SELECT epa_type, count(*) as count_node FROM arc where state > 0 group by epa_type order by 2)a
FULL JOIN
(SELECT 'CONDUIT' AS epa_type, count(*) as count_inp FROM inp_conduit join arc using (arc_id ) where state > 0
union
SELECT 'WEIR', count(*) FROM inp_weir join arc using (arc_id ) where state > 0  
union
SELECT 'OUTLET', count(*) FROM inp_outlet join arc using (arc_id ) where state > 0 
union
SELECT 'ORIFICE', count(*) FROM inp_orifice join arc using (arc_id ) where state > 0 
union
SELECT 'VIRTUAL', count(*) FROM inp_virtual join arc using (arc_id ) where state > 0
union
SELECT 'PUMP', count(*) FROM inp_pump join arc using (arc_id ) where state > 0  )b
USING (epa_type)


*/


DECLARE
v_version text;
v_error_context text;
v_projecttype text;
v_affectrow integer;
v_fid integer = 214;
v_criticity integer = 0;

rec_feature record;

BEGIN


	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	--  get version
	SELECT project_type, giswater INTO v_projecttype, v_version FROM sys_version;

	-- delete auxiliar tables
	DELETE FROM audit_check_data WHERE fid = v_fid;
	
	IF v_projecttype  = 'WS' THEN
	
		-- node ws
		INSERT INTO inp_junction
		SELECT node_id FROM node WHERE state >0 and epa_type = 'JUNCTION'
		ON CONFLICT (node_id) DO NOTHING;

		INSERT INTO inp_reservoir
		SELECT node_id FROM node WHERE state >0 and epa_type = 'RESERVOIR'
		ON CONFLICT (node_id) DO NOTHING;

		INSERT INTO inp_tank
		SELECT node_id FROM node WHERE state >0 and epa_type = 'TANK'
		ON CONFLICT (node_id) DO NOTHING;
		
		INSERT INTO inp_inlet
		SELECT node_id FROM node WHERE state >0 and epa_type = 'INLET'
		ON CONFLICT (node_id) DO NOTHING;
		
		INSERT INTO inp_valve
		SELECT node_id FROM node WHERE state >0 and epa_type = 'VALVE'
		ON CONFLICT (node_id) DO NOTHING;
		
		INSERT INTO inp_pump
		SELECT node_id FROM node WHERE state >0 and epa_type = 'PUMP'
		ON CONFLICT (node_id) DO NOTHING;

		INSERT INTO inp_shortpipe
		SELECT node_id FROM node WHERE state >0 and epa_type = 'SHORTPIPE'
		ON CONFLICT (node_id) DO NOTHING;
		

		DELETE FROM inp_junction WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_reservoir WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_tank WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_inlet WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_valve WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_pump WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_shortpipe WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');


		DELETE FROM inp_junction WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'JUNCTION');
		DELETE FROM inp_reservoir WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'RESERVOIR');
		DELETE FROM inp_tank WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'TANK');
		DELETE FROM inp_inlet WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'INLET');
		DELETE FROM inp_valve WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'VALVE');
		DELETE FROM inp_pump WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'PUMP');
		DELETE FROM inp_shortpipe WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'SHORTPIPE');
		
		-- connec ws
		INSERT INTO inp_connec
		SELECT connec_id FROM connec WHERE state >0
		ON CONFLICT (connec_id) DO NOTHING;

		DELETE FROM inp_connec WHERE connec_id NOT IN (SELECT connec_id FROM connec);
		
		-- arc ws
		INSERT INTO inp_virtualvalve
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'VIRTUALVALVE'
		ON CONFLICT (arc_id) DO NOTHING;

		INSERT INTO inp_pump_importinp
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'PUMP-IMPORTINP'
		ON CONFLICT (arc_id) DO NOTHING;

		INSERT INTO inp_valve_importinp
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'VALVE-IMPORTINP'
		ON CONFLICT (arc_id) DO NOTHING;
		
		INSERT INTO inp_pipe
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'PIPE'
		ON CONFLICT (arc_id) DO NOTHING;

		DELETE FROM inp_virtualvalve WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_pump_importinp WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_valve_importinp WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_pipe WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');

		DELETE FROM inp_virtualvalve WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'VIRTUALVALVE');
		DELETE FROM inp_pump_importinp WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'PUMP-IMPORTINP');
		DELETE FROM inp_valve_importinp WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'VALVE-IMPORTINP');
		DELETE FROM inp_pipe WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'PIPE');	

	ELSE 
		-- node ud
		INSERT INTO inp_junction
		SELECT node_id FROM node WHERE state >0 and epa_type = 'JUNCTION'
		ON CONFLICT (node_id) DO NOTHING;

		INSERT INTO inp_storage
		SELECT node_id FROM node WHERE state >0 and epa_type = 'STORAGE'
		ON CONFLICT (node_id) DO NOTHING;

		INSERT INTO inp_outfall
		SELECT node_id FROM node WHERE state >0 and epa_type = 'OUTFALL'
		ON CONFLICT (node_id) DO NOTHING;
		
		INSERT INTO inp_divider
		SELECT node_id FROM node WHERE state >0 and epa_type = 'DIVIDER'
		ON CONFLICT (node_id) DO NOTHING;
		
		DELETE FROM inp_junction WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_storage WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_outfall WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_divider WHERE node_id IN (SELECT node_id FROM node WHERE epa_type = 'UNDEFINED');

		DELETE FROM inp_junction WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'JUNCTION');
		DELETE FROM inp_storage WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'STORAGE');
		DELETE FROM inp_outfall WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'OUTFALL');
		DELETE FROM inp_divider WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = 'DIVIDER');

		-- arc ud
		INSERT INTO inp_conduit
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'CONDUIT'
		ON CONFLICT (arc_id) DO NOTHING;

		INSERT INTO inp_pump
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'PUMP'
		ON CONFLICT (arc_id) DO NOTHING;

		INSERT INTO inp_virtual
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'VIRTUAL'
		ON CONFLICT (arc_id) DO NOTHING;
		
		INSERT INTO inp_weir
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'WEIR'
		ON CONFLICT (arc_id) DO NOTHING;

		INSERT INTO inp_orifice
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'ORIFICE'
		ON CONFLICT (arc_id) DO NOTHING;

		INSERT INTO inp_outlet
		SELECT arc_id FROM arc WHERE state >0 and epa_type = 'OUTLET'
		ON CONFLICT (arc_id) DO NOTHING;
		
		DELETE FROM inp_conduit WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_pump WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_virtual WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_weir WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_orifice WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');
		DELETE FROM inp_outlet WHERE arc_id IN (SELECT arc_id FROM arc WHERE epa_type = 'UNDEFINED');

		DELETE FROM inp_conduit WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'CONDUIT');
		DELETE FROM inp_pump WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'PUMP');
		DELETE FROM inp_virtual WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'VIRTUAL');
		DELETE FROM inp_weir WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'WEIR');
		DELETE FROM inp_orifice WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'ORIFICE');
		DELETE FROM inp_outlet WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = 'OUTLET');
		
	END IF;
	     
	-- Return
	RETURN '{"status":"Accepted"}';


	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


