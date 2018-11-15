/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2452

--DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_trg_selector_expl();
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_selector_expl()
  RETURNS trigger AS
$BODY$
DECLARE 


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
    IF TG_OP = 'INSERT' THEN

		DELETE FROM inp_selector_sector WHERE cur_user=current_user;
		INSERT INTO inp_selector_sector (sector_id, cur_user) 
		SELECT DISTINCT ON (sector_id) sector_id, current_user FROM sector, exploitation WHERE st_dwithin(exploitation.the_geom, sector.the_geom,0) 
		AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ;
	
		RETURN NEW;
		

    ELSIF TG_OP = 'UPDATE' THEN

		DELETE FROM inp_selector_sector WHERE cur_user=current_user;
		INSERT INTO inp_selector_sector (sector_id, cur_user) 
		SELECT DISTINCT ON (sector_id) sector_id, current_user FROM sector, exploitation WHERE st_dwithin(exploitation.the_geom, sector.the_geom,0) 
		AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ;
					
		RETURN NEW;


    ELSIF TG_OP = 'DELETE' THEN  

		DELETE FROM inp_selector_sector WHERE cur_user=current_user;
		INSERT INTO inp_selector_sector (sector_id, cur_user) 
		SELECT DISTINCT ON (sector_id) sector_id, current_user FROM sector, exploitation WHERE st_dwithin(exploitation.the_geom, sector.the_geom,0) 
		AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ;
	
		RETURN OLD;
 
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  


DROP TRIGGER IF EXISTS gw_trg_selector_expl ON "SCHEMA_NAME".selector_expl;
CREATE TRIGGER gw_trg_selector_expl AFTER INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".selector_expl FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_selector_expl();

ALTER TABLE selector_expl DISABLE TRIGGER gw_trg_selector_expl;