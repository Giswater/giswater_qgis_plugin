/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2652

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_get_version()
RETURNS text AS
$BODY$
DECLARE
	v_version text;
BEGIN
	SET search_path = "SCHEMA_NAME", public;
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	RETURN v_version;
END;
$BODY$
LANGUAGE plpgsql STABLE
COST 100;
