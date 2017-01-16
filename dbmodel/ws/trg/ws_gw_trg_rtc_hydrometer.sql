/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_rtc_hydrometer()  RETURNS trigger AS $BODY$ 

    

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
   
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
        
        IF NEW.hydrometer_id IN (SELECT hydrometer_id::varchar(16) from ext_rtc_hydrometer) THEN
            RETURN NEW;
        ELSE
            RAISE EXCEPTION 'INSERT IS NOT ALLOWED. THERE IS NOT HYDROMETER_ID ON....';
        END IF;

    ELSIF TG_OP = 'UPDATE' THEN
        RAISE EXCEPTION 'UPDATE IS NOT ALLOWED....';
       
        
    ELSIF TG_OP = 'DELETE' THEN
        
        IF OLD.hydrometer_id NOT IN (SELECT hydrometer_id::varchar(16) from ext_rtc_hydrometer) THEN
            RETURN NEW;
        ELSE
            RAISE EXCEPTION 'DELETE IS NOT ALLOWED. THERE IS HYDROMETER_ID ON....';
        END IF;
    
    END IF;

       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_rtc_hydrometer ON "SCHEMA_NAME".rtc_hydrometer;
CREATE TRIGGER gw_trg_rtc_hydrometer BEFORE INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".rtc_hydrometer FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_rtc_hydrometer();


