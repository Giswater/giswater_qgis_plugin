/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_connec_update_connec() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    arcrec Record;
    rec Record;

BEGIN 

    RETURN NEW; 
    
END; 
$$  


-- CREATE TRIGGER gw_trg_connec_update_connec BEFORE UPDATE ON "SCHEMA_NAME"."connec" FOR EACH ROW  WHEN (((old.the_geom IS DISTINCT FROM new.the_geom) )) EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_connec_update_connec"();

