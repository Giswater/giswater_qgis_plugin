/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION gw_trg_update_selectors()
  RETURNS json AS
$BODY$

DECLARE
    rec RECORD;
   	selector_name TEXT;
  	table_name TEXT;
BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    selector_name := TG_ARGV[0];

	IF selector_name = 'campaign' THEN

		IF TG_OP = 'INSERT' THEN

		    FOR rec IN
		        SELECT DISTINCT user_id
				FROM om_campaign oc
				JOIN cat_organization co USING(organization_id)
				JOIN cat_team ct USING(organization_id)
				JOIN cat_user cu USING(team_id)
				WHERE ct.role_id IN ('role_admin', 'role_manager')
				AND oc.id = NEW.id
		    LOOP
		        INSERT INTO SCHEMA_NAME.selector_campaign (id, campaign_id, cur_user)
		        VALUES (
		            nextval('SCHEMA_NAME.selector_campaign_id_seq'::regclass),
		            NEW.id,
		            rec.user_id
		        );
		    END LOOP;

			RETURN NEW;

		ELSIF TG_OP = 'UPDATE' THEN

			IF NEW.organization_id != OLD.organization_id THEN
			    DELETE FROM SCHEMA_NAME.selector_campaign WHERE campaign_id = OLD.id;

				FOR rec IN
			        SELECT DISTINCT user_id
					FROM om_campaign oc
					JOIN cat_organization co USING(organization_id)
					JOIN cat_team ct USING(organization_id)
					JOIN cat_user cu USING(team_id)
					WHERE ct.role_id IN ('role_admin', 'role_manager')
					AND oc.id = NEW.id
			    LOOP
			        INSERT INTO SCHEMA_NAME.selector_campaign (id, campaign_id, cur_user)
			        VALUES (
			            nextval('SCHEMA_NAME.selector_campaign_id_seq'::regclass),
			            NEW.id,
			            rec.user_id
			        );
			    END LOOP;
			END IF;

			RETURN NEW;

		ELSIF TG_OP = 'DELETE' THEN
		    DELETE FROM SCHEMA_NAME.selector_campaign WHERE campaign_id = OLD.id;
		   	RETURN NULL;

		END IF;

	ELSIF selector_name = 'campaign_lot' THEN

		IF TG_OP = 'INSERT' THEN

		    FOR rec IN
		        SELECT DISTINCT user_id
				FROM om_campaign oc
				JOIN cat_organization co USING(organization_id)
				JOIN cat_team ct USING(organization_id)
				JOIN cat_user cu USING(team_id)
				WHERE ct.role_id IN ('role_admin', 'role_manager', 'role_field')
				AND oc.id = NEW.id
		    LOOP
		        INSERT INTO SCHEMA_NAME.selector_campaign_lot (id, lot_id, cur_user)
		        VALUES (
		            nextval('SCHEMA_NAME.selector_campaign_lot_id_seq'::regclass),
		            NEW.lot_id,
		            rec.user_id
		        );
		    END LOOP;

			RETURN NEW;

		ELSIF TG_OP = 'UPDATE' THEN

			IF NEW.campaign_id != OLD.campaign_id THEN
			    DELETE FROM SCHEMA_NAME.selector_campaign_lot WHERE lot_id = OLD.lot_id AND user_id = rec.user_id;

				FOR rec IN
			        SELECT DISTINCT user_id
					FROM om_campaign oc
					JOIN cat_organization co USING(organization_id)
					JOIN cat_team ct USING(organization_id)
					JOIN cat_user cu USING(team_id)
					WHERE ct.role_id IN ('role_admin', 'role_manager', 'role_field')
					AND oc.id = NEW.id
			    LOOP
			        INSERT INTO SCHEMA_NAME.selector_campaign_lot (id, lot_id, cur_user)
			        VALUES (
			            nextval('SCHEMA_NAME.selector_campaign_lot_id_seq'::regclass),
			            NEW.lot_id,
			            rec.user_id
			        );
			    END LOOP;
			END IF;

			RETURN NEW;

		ELSIF TG_OP = 'DELETE' THEN
		   DELETE FROM SCHEMA_NAME.selector_campaign_lot WHERE lot_id = OLD.lot_id AND user_id = rec.user_id;

		   	RETURN NULL;

		END IF;

	END IF;

    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
