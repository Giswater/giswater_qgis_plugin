/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1342


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_rtc_hydrometer()  RETURNS trigger AS $BODY$ 

    

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
   
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
        
        --IF NEW.hydrometer_id IN (SELECT id::varchar(16) from ext_rtc_hydrometer) THEN
            RETURN NEW;
        --ELSE
            --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                --"data":{"message":"1102", "function":"1342","debug_msg":null, "variables":null}}$$);
        --END IF;

    ELSIF TG_OP = 'UPDATE' THEN
            RETURN NEW;
       
        
    ELSIF TG_OP = 'DELETE' THEN
        
        --IF OLD.hydrometer_id NOT IN (SELECT id::varchar(16) from ext_rtc_hydrometer) THEN
            RETURN OLD;
        --ELSE
            --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                --"data":{"message":"1106", "function":"1342","debug_msg":null, "variables":null}}$$);
        --END IF;
    
    END IF;

       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

