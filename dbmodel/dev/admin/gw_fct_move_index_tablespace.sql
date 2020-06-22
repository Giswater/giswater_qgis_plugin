/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:XXXX

DROP FUNCTION IF EXISTS ws.gw_fct_move_index_tablespace();
CREATE OR REPLACE FUNCTION ws.gw_fct_move_index_tablespace()
  RETURNS void AS
$BODY$

/*
SELECT ws.gw_fct_move_index_tablespace()
*/

DECLARE

v_indexname text;

BEGIN

	--  Search path	
	SET search_path = "ws", public;
	
	FOR v_indexname IN SELECT indexname FROM pg_indexes where schemaname = 'ws'
	LOOP
		EXECUTE ' ALTER INDEX '||quote_ident(v_indexname)||' SET TABLESPACE indexspace';
		
	END LOOP;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;