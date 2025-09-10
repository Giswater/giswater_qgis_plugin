/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3464

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_update_selectors()
  RETURNS json AS
$BODY$

DECLARE
    rec RECORD;
   	selector_name TEXT;
  	table_name TEXT;
    v_prev_search_path text;
BEGIN
	v_prev_search_path := current_setting('search_path');
	PERFORM set_config('search_path', format('%I, public', TG_TABLE_SCHEMA), true);
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
		        INSERT INTO cm.selector_campaign (id, campaign_id, cur_user)
		        VALUES (
		            nextval('cm.selector_campaign_id_seq'::regclass),
		            NEW.id,
		            rec.user_id
		        );
		    END LOOP;

			PERFORM set_config('search_path', v_prev_search_path, true);
			RETURN NEW;

		ELSIF TG_OP = 'UPDATE' THEN

			IF NEW.organization_id != OLD.organization_id THEN
			    DELETE FROM cm.selector_campaign WHERE campaign_id = OLD.id;

				FOR rec IN
			        SELECT DISTINCT user_id
					FROM om_campaign oc
					JOIN cat_organization co USING(organization_id)
					JOIN cat_team ct USING(organization_id)
					JOIN cat_user cu USING(team_id)
					WHERE ct.role_id IN ('role_admin', 'role_manager')
					AND oc.id = NEW.id
			    LOOP
			        INSERT INTO cm.selector_campaign (id, campaign_id, cur_user)
			        VALUES (
			            nextval('cm.selector_campaign_id_seq'::regclass),
			            NEW.id,
			            rec.user_id
			        );
			    END LOOP;
			END IF;

			PERFORM set_config('search_path', v_prev_search_path, true);
			RETURN NEW;

		ELSIF TG_OP = 'DELETE' THEN
		    DELETE FROM cm.selector_campaign WHERE campaign_id = OLD.id;
		    	PERFORM set_config('search_path', v_prev_search_path, true);
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
		        INSERT INTO cm.selector_campaign_lot (id, lot_id, cur_user)
		        VALUES (
		            nextval('cm.selector_campaign_lot_id_seq'::regclass),
		            NEW.lot_id,
		            rec.user_id
		        );
		    END LOOP;

			PERFORM set_config('search_path', v_prev_search_path, true);
			RETURN NEW;

		ELSIF TG_OP = 'UPDATE' THEN

			IF NEW.campaign_id != OLD.campaign_id THEN
			    DELETE FROM cm.selector_campaign_lot WHERE lot_id = OLD.lot_id AND user_id = rec.user_id;

				FOR rec IN
			        SELECT DISTINCT user_id
					FROM om_campaign oc
					JOIN cat_organization co USING(organization_id)
					JOIN cat_team ct USING(organization_id)
					JOIN cat_user cu USING(team_id)
					WHERE ct.role_id IN ('role_admin', 'role_manager', 'role_field')
					AND oc.id = NEW.id
			    LOOP
			        INSERT INTO cm.selector_campaign_lot (id, lot_id, cur_user)
			        VALUES (
			            nextval('cm.selector_campaign_lot_id_seq'::regclass),
			            NEW.lot_id,
			            rec.user_id
			        );
			    END LOOP;
			END IF;

			PERFORM set_config('search_path', v_prev_search_path, true);
			RETURN NEW;

		ELSIF TG_OP = 'DELETE' THEN
		   DELETE FROM cm.selector_campaign_lot WHERE lot_id = OLD.lot_id AND user_id = rec.user_id;

		    	PERFORM set_config('search_path', v_prev_search_path, true);
		    	RETURN NULL;

		END IF;

	END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN NEW;

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
