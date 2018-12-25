/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_visit_expl()
  RETURNS trigger AS
$BODY$
DECLARE 

expl_id_arg integer;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    SELECT expl_id INTO expl_id_arg FROM exploitation WHERE ST_DWithin(exploitation.the_geom, NEW.the_geom, 0.01);

    IF expl_id_arg IS NOT NULL THEN
	NEW.expl_id=expl_id_arg;	
    END IF;

RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
