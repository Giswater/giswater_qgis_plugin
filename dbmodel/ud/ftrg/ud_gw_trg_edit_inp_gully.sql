/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3072
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_gully() 
RETURNS trigger AS 
$BODY$
DECLARE 
    v_epa_table varchar;
    v_man_table varchar;
    v_sql varchar;
    v_old_arctype varchar;
    v_new_arctype varchar;  

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_epa_table:= TG_ARGV[0];
    
    IF TG_OP = 'INSERT' THEN

    ELSIF TG_OP = 'UPDATE' THEN

		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN


    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
   