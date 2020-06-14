/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2464

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setvalurn();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setvalurn()
  RETURNS int8 AS
$BODY$

DECLARE 

v_max int8;
v_projecttype text;

BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;
	
	--urn
	IF v_projecttype='WS' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO v_max;
	ELSIF v_projecttype='UD' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(gully_id::int8) FROM gully WHERE gully_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO v_max;
	END IF;	
	
return v_max;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;