/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2962


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_trg_ui_mincut_result_cat();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_mincut() RETURNS trigger AS $BODY$
DECLARE 
v_sql text;

    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    IF TG_OP = 'INSERT' THEN
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_sql:= 'DELETE FROM om_mincut WHERE id = '||quote_literal(OLD.id);
        EXECUTE v_sql;
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
     