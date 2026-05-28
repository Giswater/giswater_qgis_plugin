/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2653

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_satellite_enabled(p_kind text)
RETURNS boolean AS
$BODY$
DECLARE
	v_addparam jsonb;
	v_enabled boolean;
BEGIN
	SET search_path = "SCHEMA_NAME", public;
	SELECT addparam INTO v_addparam FROM sys_version ORDER BY id DESC LIMIT 1;
	IF v_addparam IS NULL OR NOT (v_addparam ? 'satellites') THEN
		RETURN FALSE;
	END IF;
	EXECUTE format(
		'SELECT ($1 -> ''satellites'' -> %L ->> ''enabled'')::boolean',
		lower(p_kind)
	) INTO v_enabled USING v_addparam;
	RETURN COALESCE(v_enabled, FALSE);
END;
$BODY$
LANGUAGE plpgsql STABLE
COST 100;
