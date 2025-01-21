/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3368

/*

-- Source execution
SELECT SCHEMA_NAME.gw_fct_setcheckdatabase($${"data":{"parameters":{"omCheck":true, "graphCheck":false, "epaCheck":false, "planCheck":false, "adminCheck":false, "verifiedExceptions":true}}}$$);

-- Executed by gw_fct_setcheckdatabase
SELECT SCHEMA_NAME.gw_fct_create_querytables($${"data":{"parameters":{"fid":604, "omCheck":false, "graphCheck":true, "epaCheck":false, "planCheck":false, "adminCheck":false, "verifiedExceptions":true}}}$$);

-- Executed via Go2EPA
SELECT SCHEMA_NAME.gw_fct_create_querytables($${"data":{"parameters":{"fid":604, "omCheck":false, "graphCheck":false, "epaCheck":true, "planCheck":false, "adminCheck":false, "verifiedExceptions":false}}}$$);

*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_querytables (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_setcheckdatabase($${"data":{"parameters":{"omCheck":true, "graphCheck":false, "epaCheck":false, "planCheck":false, "adminCheck":false, "verifiedExceptions":false}}}$$);

*/

DECLARE
v_fid integer;
v_project_type text;
v_verified_exceptions boolean = true;
v_fprocessname text;
v_filter text;
v_omcheck boolean;
v_graphcheck boolean;
v_epacheck boolean;
v_plancheck boolean;
v_admincheck boolean;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	v_project_type = (SELECT project_type FROM sys_version order by id desc limit 1);

	-- Get input parameters
	v_verified_exceptions := ((p_data ->>'data')::json->>'parameters')::json->>'verifiedExceptions';
	v_fid := (((p_data ->>'data')::json->>'parameters')::json->>'fid');
	v_omcheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'omCheck';
	v_graphcheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'graphCheck';
	v_epacheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'epaCheck';
	v_plancheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'planCheck';
	v_admincheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'adminCheck';

	-- setting verified options
	IF v_verified_exceptions THEN
		v_filter = ' WHERE (verified is null or verified::INTEGER IN (0,1))';
	ELSE
		v_filter = ' WHERE state is not null ';
	END IF;

	-- create query tables for om
	DROP TABLE IF EXISTS t_arc;	EXECUTE 'CREATE TEMP TABLE t_arc AS SELECT * FROM v_edit_arc'||v_filter;
	DROP TABLE IF EXISTS t_node;EXECUTE 'CREATE TEMP TABLE  t_node AS SELECT * FROM v_edit_node'||v_filter;
	DROP TABLE IF EXISTS t_connec;EXECUTE 'CREATE TEMP TABLE t_connec AS SELECT * FROM v_edit_connec'||v_filter;
	DROP TABLE IF EXISTS t_element;	EXECUTE 'CREATE TEMP TABLE t_element AS SELECT * FROM v_edit_element'||v_filter;
	DROP TABLE IF EXISTS t_link;EXECUTE 'CREATE TEMP TABLE t_link AS SELECT * FROM v_edit_link';
	DROP TABLE IF EXISTS t_dma;	CREATE TEMP TABLE t_dma AS SELECT * FROM v_edit_dma;
	IF v_project_type = 'WS' THEN
		DROP TABLE IF EXISTS t_dqa;	CREATE TEMP TABLE t_dqa AS SELECT * FROM v_edit_dqa;
		DROP TABLE IF EXISTS t_presszone; CREATE TEMP TABLE t_presszone AS SELECT * FROM v_edit_presszone;
		DROP TABLE IF EXISTS t_sector; CREATE TEMP TABLE t_sector AS SELECT * FROM v_edit_sector;
	ELSIF v_project_type  = 'UD' THEN
		DROP TABLE IF EXISTS t_gully;EXECUTE 'CREATE TEMP TABLE t_gully AS SELECT * FROM v_edit_gully'||v_filter;
		DROP TABLE IF EXISTS t_drainzone; CREATE TEMP TABLE t_drainzone AS SELECT * FROM v_edit_drainzone;
	END IF;


	-- create query table for check-epa
	IF v_epacheck THEN
		v_filter = concat(v_filter, ' AND sector_id IN (select sector_id from selector_sector where cur_user = current_user)');

		DROP TABLE IF EXISTS t_inp_pump; EXECUTE 'CREATE TEMP TABLE t_inp_pump AS SELECT * FROM v_edit_inp_pump'||v_filter;
		IF v_project_type = 'WS' THEN
			DROP TABLE IF EXISTS t_inp_pipe; EXECUTE 'CREATE TEMP TABLE t_inp_pipe AS SELECT * FROM v_edit_inp_pipe'||v_filter;
			DROP TABLE IF EXISTS t_inp_valve; EXECUTE 'CREATE TEMP TABLE t_inp_valve AS SELECT * FROM v_edit_inp_valve'||v_filter;
			DROP TABLE IF EXISTS t_inp_junction; EXECUTE 'CREATE TEMP TABLE t_inp_junction AS SELECT * FROM v_edit_inp_junction'||v_filter;
			DROP TABLE IF EXISTS t_inp_reservoir; EXECUTE 'CREATE TEMP TABLE t_inp_reservoir AS SELECT * FROM v_edit_inp_reservoir'||v_filter;
			DROP TABLE IF EXISTS t_inp_tank; EXECUTE 'CREATE TEMP TABLE t_inp_tank AS SELECT * FROM v_edit_inp_tank'||v_filter;
			DROP TABLE IF EXISTS t_inp_inlet; EXECUTE 'CREATE TEMP TABLE t_inp_inlet AS SELECT * FROM v_edit_inp_inlet'||v_filter;
			DROP TABLE IF EXISTS t_inp_virtualvalve; EXECUTE 'CREATE TEMP TABLE t_inp_virtualvalve AS SELECT * FROM v_edit_inp_virtualvalve'||v_filter;
			DROP TABLE IF EXISTS t_inp_virtualpump; EXECUTE 'CREATE TEMP TABLE t_inp_virtualpump AS SELECT * FROM v_edit_inp_virtualpump'||v_filter;

		ELSIF  v_project_type  = 'UD' THEN
			DROP TABLE IF EXISTS t_inp_conduit; EXECUTE 'CREATE TEMP TABLE t_inp_conduit AS SELECT * FROM v_edit_inp_conduit'||v_filter;
			DROP TABLE IF EXISTS t_inp_outlet; EXECUTE 'CREATE TEMP TABLE t_inp_outlet AS SELECT * FROM v_edit_inp_outlet'||v_filter;
			DROP TABLE IF EXISTS t_inp_orifice; EXECUTE 'CREATE TEMP TABLE t_inp_orifice AS SELECT * FROM v_edit_inp_orifice'||v_filter;
			DROP TABLE IF EXISTS t_inp_weir; EXECUTE 'CREATE TEMP TABLE t_inp_weir AS SELECT * FROM v_edit_inp_weir'||v_filter;
			DROP TABLE IF EXISTS t_inp_virtual; EXECUTE 'CREATE TEMP TABLE t_inp_virtual AS SELECT * FROM v_edit_inp_virtual'||v_filter;
			DROP TABLE IF EXISTS t_inp_storage; EXECUTE 'CREATE TEMP TABLE t_inp_storage AS SELECT * FROM v_edit_inp_storage'||v_filter;
			DROP TABLE IF EXISTS t_inp_subcatchment; EXECUTE 'CREATE TEMP TABLE t_inp_subcatchment AS SELECT * FROM v_edit_inp_subcatchment';
			DROP TABLE IF EXISTS t_inp_junction; EXECUTE 'CREATE TEMP TABLE t_inp_junction AS SELECT * FROM v_edit_inp_junction'||v_filter;
			DROP TABLE IF EXISTS t_inp_outfall; EXECUTE 'CREATE TEMP TABLE t_inp_outfall AS SELECT * FROM v_edit_inp_outfall'||v_filter;
			DROP TABLE IF EXISTS t_inp_divider; EXECUTE 'CREATE TEMP TABLE t_inp_divider AS SELECT * FROM v_edit_inp_divider'||v_filter;
			DROP TABLE IF EXISTS t_inp_subc2outlet; EXECUTE 'CREATE TEMP TABLE t_inp_subc2outlet AS SELECT * FROM v_edit_inp_subc2outlet';
			DROP TABLE IF EXISTS t_inp_netgully; EXECUTE 'CREATE TEMP TABLE t_inp_netgully AS SELECT * FROM v_edit_inp_netgully'||v_filter;
			DROP TABLE IF EXISTS t_inp_gully; EXECUTE 'CREATE TEMP TABLE t_inp_gully AS SELECT * FROM v_edit_inp_gully'||v_filter;
			DROP TABLE IF EXISTS t_raingage; EXECUTE 'CREATE TEMP TABLE t_raingage AS SELECT * FROM v_edit_raingage';
		END IF;
	END IF;

	-- create log tables
	DROP TABLE IF EXISTS t_audit_check_data; EXECUTE 'CREATE TEMP TABLE t_audit_check_data AS SELECT * FROM audit_check_data';
	DROP TABLE IF EXISTS t_audit_check_project;	EXECUTE 'CREATE TEMP TABLE t_audit_check_project AS SELECT * FROM audit_check_project';



	-- create anl tables
	DROP TABLE IF EXISTS t_anl_node; EXECUTE 'CREATE TEMP TABLE t_anl_node AS SELECT * FROM anl_node WHERE cur_user = current_user';
	DROP TABLE IF EXISTS t_anl_arc;	EXECUTE 'CREATE TEMP TABLE t_anl_arc AS SELECT * FROM anl_arc WHERE cur_user = current_user';
	DROP TABLE IF EXISTS t_anl_connec; EXECUTE 'CREATE TEMP TABLE t_anl_connec AS SELECT * FROM anl_connec WHERE cur_user = current_user';
	DROP TABLE IF EXISTS t_anl_polygon; EXECUTE 'CREATE TEMP TABLE t_anl_polygon AS SELECT * FROM anl_polygon WHERE cur_user = current_user';

	ALTER TABLE t_audit_check_data ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.audit_check_data_id_seq'::regclass);
	ALTER TABLE t_anl_node ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.anl_node_id_seq'::regclass);
	ALTER TABLE t_anl_node ALTER COLUMN cur_user SET DEFAULT '"current_user"()';
	ALTER TABLE t_anl_arc ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.anl_arc_id_seq'::regclass);
	ALTER TABLE t_anl_arc ALTER COLUMN cur_user SET DEFAULT '"current_user"()';
	ALTER TABLE t_anl_connec ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.anl_connec_id_seq'::regclass);
	ALTER TABLE t_anl_connec ALTER COLUMN cur_user SET DEFAULT '"current_user"()';
	ALTER TABLE t_anl_polygon ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.anl_polygon_id_seq'::regclass);
	ALTER TABLE t_anl_polygon ALTER COLUMN cur_user SET DEFAULT '"current_user"()';


	--  Return
	RETURN '{"status":"ok"}';

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;