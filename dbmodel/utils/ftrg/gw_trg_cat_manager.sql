/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2754


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_cat_manager()
  RETURNS trigger AS
$BODY$
DECLARE
	rec_manager record;
	rec_sector integer;
	rec_role text;
	rec_user text;
	v_new_id integer;
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF (TG_OP = 'INSERT' AND NEW.rolename != '{}') THEN
		INSERT INTO config_user_x_sector (sector_id, username, manager_id)
		SELECT sector_id, COALESCE(m.rolname, s.rolname) AS usern, NEW.id 
		FROM (SELECT unnest(sector_id) sector_id FROM cat_manager WHERE id=NEW.id) p 
		CROSS JOIN (SELECT unnest(rolename) AS role FROM cat_manager WHERE id = NEW.id) q
		LEFT JOIN pg_roles r ON q.role = r.rolname
		LEFT JOIN pg_auth_members am ON r.oid = am.roleid
		LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE
		LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE
		WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
		ON CONFLICT (sector_id, username) DO NOTHING;
			
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		-- REMOVE All old references, and add new ones
		FOREACH rec_role IN ARRAY OLD.rolename LOOP
			FOR rec_user IN
				SELECT m.rolname
				FROM pg_roles r
				JOIN pg_auth_members am ON r.oid = am.roleid
				JOIN pg_roles m ON am.member = m.oid
				WHERE r.rolname = rec_role AND m.rolcanlogin = TRUE
				UNION
				SELECT s.rolname
				FROM pg_roles s
				WHERE s.rolname = rec_role AND s.rolcanlogin = TRUE
			LOOP
				FOREACH rec_sector IN ARRAY OLD.sector_id LOOP
					DELETE FROM config_user_x_sector WHERE rec_user=username and sector_id=rec_sector and manager_id=OLD.id;
				END LOOP;

			END LOOP;
		END LOOP;

		-- ADD new references
		INSERT INTO config_user_x_sector (sector_id, username, manager_id)
		SELECT sector_id, COALESCE(m.rolname, s.rolname) AS usern, NEW.id 
		FROM (SELECT unnest(sector_id) sector_id FROM cat_manager WHERE id=NEW.id) p 
		CROSS JOIN (SELECT unnest(rolename) AS role FROM cat_manager WHERE id = NEW.id) q
		LEFT JOIN pg_roles r ON q.role = r.rolname
		LEFT JOIN pg_auth_members am ON r.oid = am.roleid
		LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE
		LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE
		WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
		ON CONFLICT (sector_id, username) DO NOTHING;
			
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN

		-- REMOVE All old references, and add new ones
		FOREACH rec_role IN ARRAY OLD.rolename LOOP
			FOR rec_user IN
				SELECT m.rolname
				FROM pg_roles r
				JOIN pg_auth_members am ON r.oid = am.roleid
				JOIN pg_roles m ON am.member = m.oid
				WHERE r.rolname = rec_role AND m.rolcanlogin = TRUE
				UNION
				SELECT s.rolname
				FROM pg_roles s
				WHERE s.rolname = rec_role AND s.rolcanlogin = TRUE
			LOOP
				FOREACH rec_sector IN ARRAY OLD.sector_id LOOP
					DELETE FROM config_user_x_sector WHERE rec_user=username and sector_id=rec_sector and manager_id=OLD.id;
				END LOOP;

			END LOOP;
		END LOOP;

		-- Check for others managers missing references
		FOR rec_manager IN
			SELECT id, expl_id, rolename, sector_id
			FROM cat_manager
		LOOP

			INSERT INTO config_user_x_sector (sector_id, username, manager_id)
			SELECT sector_id, COALESCE(m.rolname, s.rolname) AS usern, rec_manager.id
			FROM (SELECT unnest(sector_id) AS sector_id FROM cat_manager WHERE id = rec_manager.id) p 
			CROSS JOIN (SELECT unnest(rolename) AS role FROM cat_manager WHERE id = rec_manager.id) q
			LEFT JOIN pg_roles r ON q.role = r.rolname
			LEFT JOIN pg_auth_members am ON r.oid = am.roleid
			LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE
			LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE
			WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
			ON CONFLICT (sector_id, username) DO NOTHING;
		
		END LOOP;

		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
