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
        
        IF NEW.hydrometer_id IN (SELECT id::varchar(16) from ext_rtc_hydrometer) THEN
            RETURN NEW;
        ELSE
            PERFORM audit_function(1102,1342);
        END IF;

    ELSIF TG_OP = 'UPDATE' THEN
            RETURN NEW;
       
        
    ELSIF TG_OP = 'DELETE' THEN
        
        IF OLD.hydrometer_id NOT IN (SELECT id::varchar(16) from ext_rtc_hydrometer) THEN
            RETURN NEW;
        ELSE
            PERFORM audit_function(1106,1342);
        END IF;
    
    END IF;

       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_rtc_hydrometer ON "SCHEMA_NAME".rtc_hydrometer;
CREATE TRIGGER gw_trg_rtc_hydrometer BEFORE INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".rtc_hydrometer FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_rtc_hydrometer();


