/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2754


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_cat_manager()
  RETURNS trigger AS
$BODY$
DECLARE
	rec_sector integer;
	rec_role text;
	rec_expl integer;
	rec_user text;
	v_new_id integer;
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';


	-- Delete orphan nodes
	IF (TG_OP = 'INSERT' AND NEW.rolename !='{}') THEN

			INSERT INTO config_user_x_expl (expl_id, username, manager_id)
			SELECT expl, COALESCE(m.rolname, s.rolname) AS usern, NEW.id
			FROM (SELECT unnest(expl_id) AS expl FROM cat_manager WHERE id = NEW.id) p
			CROSS JOIN (SELECT unnest(rolename) AS role FROM cat_manager WHERE id = NEW.id) q
			LEFT JOIN pg_roles r ON q.role = r.rolname
			LEFT JOIN pg_auth_members am ON r.oid = am.roleid
			LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE
			LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE
			WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
			ON CONFLICT (expl_id, username) DO NOTHING;

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
	
			--if rolename was empty insert config_user_x_expl or combinations for this manager 
			IF OLD.rolename ='{}' THEN

				INSERT INTO config_user_x_expl (expl_id, username, manager_id)
				SELECT expl, COALESCE(m.rolname, s.rolname) AS usern, NEW.id
				FROM (SELECT unnest(expl_id) AS expl FROM cat_manager WHERE id = NEW.id) p
				CROSS JOIN (SELECT unnest(rolename) AS role FROM cat_manager WHERE id = NEW.id) q
				LEFT JOIN pg_roles r ON q.role = r.rolname
				LEFT JOIN pg_auth_members am ON r.oid = am.roleid
				LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE
				LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE
				WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
				ON CONFLICT (expl_id, username) DO NOTHING;

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
			
			--if the role was removed from the cat_manager, replace assignation	if exists the same relation user - expl for another manager
			ELSIF array_length(NEW.rolename,1) < array_length(OLD.rolename,1) or NEW.rolename ='{}'  THEN 


				FOREACH rec_role IN ARRAY OLD.rolename LOOP

					-- search all users that have assigned the actual rolname
					FOR rec_user IN
						SELECT m.rolname
						FROM pg_roles r
						JOIN pg_auth_members am ON r.oid = am.roleid
						JOIN pg_roles m ON am.member = m.oid
						WHERE r.rolname = rec_role AND m.rolcanlogin = TRUE
						UNION
						-- Include roles that are individual users
						SELECT s.rolname
						FROM pg_roles s
						WHERE s.rolname = rec_role AND s.rolcanlogin = TRUE
					LOOP

						FOREACH rec_expl IN ARRAY OLD.expl_id LOOP

							IF (SELECT count(id) FROM cat_manager WHERE rec_user = ANY(username) AND rec_expl::integer = ANY(expl_id))>0 THEN
						
								SELECT id INTO v_new_id FROM cat_manager WHERE rec_user = ANY(username) AND rec_expl::integer = ANY(expl_id);
								
								--if there is a different manager with the same expl assigned change the manager_id and maintain relation
								--if not, remove it	
								IF (SELECT count(*) FROM config_user_x_expl WHERE username=rec_user and expl_id=rec_expl AND active IS TRUE) > 0 THEN
									UPDATE config_user_x_expl set manager_id = v_new_id WHERE username=rec_user and expl_id=rec_expl;
								END IF;
							ELSE
								DELETE FROM config_user_x_expl WHERE rec_user=username and expl_id=rec_expl and manager_id=NEW.id;
							END IF;

						END LOOP;

						FOREACH rec_sector IN ARRAY OLD.sector_id LOOP
							IF (SELECT count(id) FROM cat_manager WHERE rec_user = ANY(username) AND rec_sector::integer = ANY(sector_id))>0 THEN
							
								SELECT id INTO v_new_id FROM cat_manager WHERE rec_user = ANY(username) AND rec_sector::integer = ANY(sector_id);
								
								--if there is a different manager with the same sector assigned change the manager_id and maintain relation
								--if not, remove it	
								IF (SELECT count(*) FROM config_user_x_sector WHERE username=rec_user and sector_id=rec_sector AND active IS TRUE) > 0 THEN
									UPDATE config_user_x_sector set manager_id = v_new_id WHERE username=rec_user and sector_id=rec_sector;
								END IF;
							ELSE
								DELETE FROM config_user_x_sector WHERE rec_user=username and sector_id=rec_sector and manager_id=NEW.id;
							END IF;
						END LOOP;
						
					END LOOP;
					
				END LOOP;
				
			--if role was added insetr new relation into config_user_x_expl
			ELSIF array_length(NEW.rolename,1) > array_length(OLD.rolename,1) THEN
					
				INSERT INTO config_user_x_expl (expl_id, username, manager_id)
				SELECT expl, COALESCE(m.rolname, s.rolname) AS usern, NEW.id
				FROM (SELECT unnest(expl_id) AS expl FROM cat_manager WHERE id = NEW.id) p
				CROSS JOIN (SELECT unnest(rolename) AS role FROM cat_manager WHERE id = NEW.id) q
				LEFT JOIN pg_roles r ON q.role = r.rolname
				LEFT JOIN pg_auth_members am ON r.oid = am.roleid
				LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE
				LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE
				WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
				ON CONFLICT (expl_id, username) DO NOTHING;

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

			END IF;
			
			--if the expl was removed from the cat_manager, replace assignation if exists the same relation user - expl for another manager
			IF array_length(NEW.expl_id,1) < array_length(OLD.expl_id,1) THEN
		
				FOREACH rec_role IN ARRAY OLD.rolename LOOP
					FOR rec_user IN
						SELECT m.rolname
						FROM pg_roles r
						JOIN pg_auth_members am ON r.oid = am.roleid
						JOIN pg_roles m ON am.member = m.oid
						WHERE r.rolname = rec_role AND m.rolcanlogin = TRUE
						UNION
						-- Include roles that are individual users
						SELECT s.rolname
						FROM pg_roles s
						WHERE s.rolname = rec_role AND s.rolcanlogin = TRUE
					LOOP
						FOREACH rec_expl IN ARRAY OLD.expl_id LOOP
							IF (SELECT count(id) FROM cat_manager WHERE rec_user = ANY(username) AND rec_expl::integer = ANY(expl_id))>0 THEN
								SELECT id INTO v_new_id FROM cat_manager WHERE rec_user = ANY(username) AND rec_expl::integer = ANY(expl_id);
								
								IF (SELECT count(*) FROM config_user_x_expl WHERE username=rec_user and expl_id=rec_expl AND active IS TRUE) > 0 THEN
									UPDATE config_user_x_expl set manager_id = v_new_id WHERE username=rec_user and expl_id=rec_expl;
								END IF;
							ELSE
								DELETE FROM config_user_x_expl WHERE rec_user=username and expl_id=rec_expl and manager_id=NEW.id;
							END IF;
						END LOOP;
					END LOOP;
				END LOOP;
			
			--if exploitation was added insert new posible relations into config_user_x_expl
			ELSIF array_length(NEW.expl_id,1) > array_length(OLD.expl_id,1) OR OLD.expl_id IS NULL THEN 

				INSERT INTO config_user_x_expl (expl_id, username, manager_id)
				SELECT expl, COALESCE(m.rolname, s.rolname) AS usern, NEW.id
				FROM (SELECT unnest(expl_id) AS expl FROM cat_manager WHERE id = NEW.id) p
				CROSS JOIN (SELECT unnest(rolename) AS role FROM cat_manager WHERE id = NEW.id) q
				LEFT JOIN pg_roles r ON q.role = r.rolname
				LEFT JOIN pg_auth_members am ON r.oid = am.roleid
				LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE
				LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE
				WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
				ON CONFLICT (expl_id, username) DO NOTHING;


			
			END IF;

			--if the sector was removed from the cat_manager, replace assignation if exists the same relation user - expl for another manager
			IF array_length(NEW.sector_id,1) < array_length(OLD.sector_id,1) THEN
		
				FOREACH rec_role IN ARRAY OLD.rolename LOOP
					FOR rec_user IN
						SELECT m.rolname
						FROM pg_roles r
						JOIN pg_auth_members am ON r.oid = am.roleid
						JOIN pg_roles m ON am.member = m.oid
						WHERE r.rolname = rec_role AND m.rolcanlogin = TRUE
						UNION
						-- Include roles that are individual users
						SELECT s.rolname
						FROM pg_roles s
						WHERE s.rolname = rec_role AND s.rolcanlogin = TRUE
					LOOP
						FOREACH rec_sector IN ARRAY OLD.sector_id LOOP
							IF (SELECT count(id) FROM cat_manager WHERE rec_user = ANY(username) AND rec_sector::integer = ANY(sector_id))>0 THEN
								SELECT id INTO v_new_id FROM cat_manager WHERE rec_user = ANY(username) AND rec_sector::integer = ANY(sector_id);
								
								IF (SELECT count(*) FROM config_user_x_sector WHERE username=rec_user and sector_id=rec_sector AND active IS TRUE) > 0 THEN
									UPDATE config_user_x_sector set manager_id = v_new_id WHERE username=rec_user and sector_id=rec_sector;
								END IF;
							ELSE
								DELETE FROM config_user_x_sector WHERE rec_user=username and sector_id=rec_sector and manager_id=NEW.id;
							END IF;
						END LOOP;
					END LOOP;
				END LOOP;
			
			--if sector was added insert new posible relations into config_user_x_sector
			ELSIF array_length(NEW.sector_id,1) > array_length(OLD.sector_id,1) OR OLD.sector_id IS NULL THEN 

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
				
			END IF;
			
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN

		FOREACH rec_role IN ARRAY OLD.rolename LOOP

			-- search all users that have assigned the actual rolname
			FOR rec_user IN
				SELECT m.rolname
				FROM pg_roles r
				JOIN pg_auth_members am ON r.oid = am.roleid
				JOIN pg_roles m ON am.member = m.oid
				WHERE r.rolname = rec_role AND m.rolcanlogin = TRUE
				UNION
				-- Include roles that are individual users
				SELECT s.rolname
				FROM pg_roles s
				WHERE s.rolname = rec_role AND s.rolcanlogin = TRUE
			LOOP
				FOREACH rec_expl IN ARRAY OLD.expl_id LOOP
					IF (SELECT count(id) FROM cat_manager WHERE rec_user = ANY(username) AND rec_expl::integer = ANY(expl_id))>0 THEN
						SELECT id INTO v_new_id FROM cat_manager WHERE rec_user = ANY(username) AND rec_expl::integer = ANY(expl_id);
						
						INSERT INTO config_user_x_expl (expl_id, username, manager_id) VALUES (rec_expl, rec_user, v_new_id);
					END IF;

				END LOOP;

				FOREACH rec_sector IN ARRAY OLD.sector_id LOOP
					IF (SELECT count(id) FROM cat_manager WHERE rec_user = ANY(username) AND rec_sector::integer = ANY(sector_id))>0 THEN
						SELECT id INTO v_new_id FROM cat_manager WHERE rec_user = ANY(username) AND rec_sector::integer = ANY(sector_id);
						
						INSERT INTO config_user_x_sector (sector_id, username, manager_id) VALUES (rec_sector, rec_user, v_new_id);
					END IF;
				END LOOP;
			END LOOP;
		END LOOP;
		
		RETURN OLD;

	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
