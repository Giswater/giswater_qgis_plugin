/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2496

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_arc( p_arc_id text, counter bigint default 0, total bigint default 0)
RETURNS character varying AS

$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_repair_arc(arc_id, (row_number() over (order by arc_id)), (select count(*) from SCHEMA_NAME.arc)) FROM SCHEMA_NAME.arc
*/

DECLARE

BEGIN
	  -- set search_path
	  SET search_path='SCHEMA_NAME';

      -- Set config parameter
      UPDATE config_param_system SET value = TRUE WHERE parameter = 'edit_topocontrol_dsbl_error' ;

      -- execute
      UPDATE arc SET the_geom = the_geom WHERE arc_id = p_arc_id;

      -- raise notice
      IF counter>0 AND total>0 THEN
        RAISE NOTICE '[%/%] Arc id: %', counter, total, p_arc_id;
      ELSIF counter>0 THEN
        RAISE NOTICE '[%] Arc id: %', counter, p_arc_id;
      ELSE
        RAISE NOTICE 'Arc id: %', p_arc_id;
      END IF;
             

      -- Set config parameter
      UPDATE config_param_system SET value = FALSE WHERE parameter = 'edit_topocontrol_dsbl_error' ;

    
RETURN p_arc_id;

   

END; 

$BODY$

LANGUAGE plpgsql VOLATILE

COST 100;