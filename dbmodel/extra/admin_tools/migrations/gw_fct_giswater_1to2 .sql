/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE FUNCTION gw_fct_giswater_1to2()
RETURNS void 
AS $BODY$

DECLARE
 rec_table 	record;
 id_last   	bigint;
 ym1_var 	float;
 ym2_var 	float;
 
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    --Initiation of the process
	FOR rec_table IN SELECT * FROM arc
    LOOP
		--y1
		SELECT ymax INTO ym1_var FROM node WHERE rec_table.node_1=node_id;
		UPDATE arc SET y1 = ym1_var-y1 WHERE arc_id=rec_table.arc_id;
	
		--y2
		SELECT ymax INTO ym2_var FROM node WHERE rec_table.node_2=node_id;
		UPDATE arc SET y2 = ym2_var-y2 WHERE arc_id=rec_table.arc_id;
		
    END LOOP;

RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;