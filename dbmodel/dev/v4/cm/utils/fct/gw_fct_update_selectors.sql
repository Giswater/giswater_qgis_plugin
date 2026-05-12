/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION cm.gw_fct_update_selectors()
  RETURNS json AS
$BODY$

BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    selector_name := TG_ARGV[0];

	IF selector_name = 'campaign' THEN

		IF TG_OP = 'INSERT' THEN

		    FOR rec IN
		        SELECT DISTINCT user_id
		        FROM om_campaign oc
		        JOIN om_organization_x_user ocxu USING(organization_id)
		        WHERE oc.id = NEW.id
		    LOOP
		        INSERT INTO cm.selector_campaign (id, campaign_id, cur_user)
		        VALUES (
		            nextval('cm.selector_campaign_id_seq'::regclass),
		            NEW.id,
		            rec.user_id
		        );
		    END LOOP;

			RETURN NEW;

		ELSIF TG_OP = 'UPDATE' THEN

			IF NEW.organization_id != OLD.organization_id THEN
				FOR rec IN
			        SELECT DISTINCT user_id
			        FROM om_campaign oc
			        JOIN om_organization_x_user ocxu ON OLD.organization_id = ocxu.organization_id
			        WHERE oc.id = NEW.id
			    LOOP
			        DELETE FROM cm.selector_campaign WHERE campaign_id = OLD.id;
			    END LOOP;

				FOR rec IN
			        SELECT DISTINCT user_id
			        FROM om_campaign oc
			        JOIN om_organization_x_user ocxu USING(organization_id)
			        WHERE oc.id = NEW.id
			    LOOP
			        INSERT INTO cm.selector_campaign (id, campaign_id, cur_user)
			        VALUES (
			            nextval('cm.selector_campaign_id_seq'::regclass),
			            NEW.id,
			            rec.user_id
			        );
			    END LOOP;
			END IF;

			RETURN NEW;

		ELSIF TG_OP = 'DELETE' THEN

			FOR rec IN
		        SELECT DISTINCT user_id
		        FROM om_campaign oc
		        JOIN om_organization_x_user ocxu ON OLD.organization_id = ocxu.organization_id
		        WHERE oc.id = NEW.id
		    LOOP
		        DELETE FROM cm.selector_campaign WHERE campaign_id = OLD.id;
		    END LOOP;

		   	RETURN NULL;

		END IF;

	ELSIF selector_name = 'campaign_lot' THEN

		IF TG_OP = 'INSERT' THEN

		    FOR rec IN
		        SELECT DISTINCT user_id FROM om_campaign_lot ocl
		        JOIN om_team_x_user otxu USING (team_id)
		        WHERE ocl.id = NEW.lot_id
		    LOOP
		        INSERT INTO cm.selector_campaign_lot (id, lot_id, cur_user)
		        VALUES (
		            nextval('cm.selector_campaign_lot_id_seq'::regclass),
		            NEW.lot_id,
		            rec.user_id
		        );
		    END LOOP;

			RETURN NEW;

		ELSIF TG_OP = 'UPDATE' THEN

			IF NEW.campaign_id != OLD.campaign_id THEN
				FOR rec IN
					SELECT DISTINCT user_id FROM om_campaign_lot ocl
		        	JOIN om_team_x_user otxu USING (team_id)
		       		WHERE ocl.id = OLD.lot_id
			    LOOP
			        DELETE FROM cm.selector_campaign_lot WHERE lot_id = OLD.lot_id AND user_id = rec.user_id;
			    END LOOP;

				FOR rec IN
			        SELECT DISTINCT user_id FROM om_campaign_lot ocl
			        JOIN om_team_x_user otxu USING (team_id)
			        WHERE ocl.id = NEW.lot_id
			    LOOP
			        INSERT INTO cm.selector_campaign_lot (id, lot_id, cur_user)
			        VALUES (
			            nextval('cm.selector_campaign_lot_id_seq'::regclass),
			            NEW.lot_id,
			            rec.user_id
			        );
			    END LOOP;
			END IF;

			RETURN NEW;

		ELSIF TG_OP = 'DELETE' THEN

			FOR rec IN
		        SELECT DISTINCT user_id FROM om_campaign_lot ocl
		        JOIN om_team_x_user otxu USING (team_id)
		        WHERE ocl.id = OLD.lot_id
		    LOOP
		        DELETE FROM cm.selector_campaign_lot WHERE lot_id = OLD.lot_id AND user_id = rec.user_id;
		    END LOOP;

		   	RETURN NULL;

		END IF;

	END IF;

    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
