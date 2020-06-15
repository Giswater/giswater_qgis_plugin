/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2934

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_event() RETURNS trigger AS $BODY$
DECLARE 
    event_table varchar;
    v_sql varchar;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    event_table:= TG_ARGV[0];


    IF TG_OP = 'INSERT' THEN


   -- ELSIF TG_OP = 'UPDATE' THEN
        
            --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            -- "data":{"message":"2", "function":"XXX","debug_msg":null, "variables":null}}$$); 
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

            v_sql:= 'DELETE FROM '||event_table||' WHERE id = '||quote_literal(OLD.event_id)||';';
            EXECUTE v_sql;
   
        --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                 -- "data":{"message":"3", "function":"XXX","debug_msg":null, "variables":null}}$$); 
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  

  

