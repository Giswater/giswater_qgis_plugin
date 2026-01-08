/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3530
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_exception_others (v_status text, v_nosqlerr text, v_message_level text, v_message_text text, v_sqlcontext text)
RETURNS json AS
$BODY$
DECLARE

v_level integer;

BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	-- Set status to Accepted or Failed
	IF v_status NOT IN ('Accepted', 'Failed') OR v_status IS NULL THEN
		v_status := 'Failed';
	END IF;

	-- Determine the message level based on SQLSTATE
	IF v_message_level LIKE 'GW%' THEN
		v_level := right(v_message_level, 1)::integer;
	ELSE
		v_level := 2;
	END IF;

	-- Return
	RETURN json_build_object('status', v_status, 'NOSQLERR', v_nosqlerr, 'message', json_build_object('level', v_level, 'text', v_message_text), 'SQLSTATE', v_message_level, 'SQLCONTEXT', v_sqlcontext)::json;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
