/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2754


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_cat_manager() 
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
 
 
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Delete orphan nodes
	IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND (NEW.expl_id::text != OLD.expl_id::text OR NEW.username::text != OLD.username::text )) THEN


		--Upsert values on exploitation_x_user according exploitation_x_user info
		DELETE FROM exploitation_x_user WHERE manager_id=NEW.id;
		INSERT INTO exploitation_x_user (expl_id, username, manager_id)
		SELECT expl, usern, NEW.id  FROM (SELECT unnest(expl_id) expl FROM cat_manager WHERE id=NEW.id) p CROSS JOIN 
		(SELECT unnest(username) usern FROM cat_manager WHERE id=NEW.id) q;

		RETURN NEW;
	
	ELSIF TG_OP = 'DELETE' THEN

		--Upsert values on exploitation_x_user according exploitation_x_user info
		DELETE FROM exploitation_x_user WHERE manager_id=OLD.id;
		INSERT INTO exploitation_x_user (expl_id, username, manager_id)
		SELECT expl, usern, OLD.id  FROM (SELECT unnest(expl_id) expl FROM cat_manager WHERE id=OLD.id) p CROSS JOIN 
		(SELECT reverse(substring(reverse(substring((unnest(username)) from 2)),2)) usern FROM cat_manager WHERE id=OLD.id) q;
		
		RETURN OLD;

	END IF;

	RETURN NEW;

END;
$$;