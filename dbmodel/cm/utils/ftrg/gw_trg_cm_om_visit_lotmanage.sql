/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3462

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_om_visit_lotmanage()
  RETURNS trigger AS
$BODY$
DECLARE

v_project_type text;
v_featuretype text;
v_id text;
v_lottable text;
v_featureid text;
v_visittable text;
v_querytext text;
v_visit record;
v_triggerfromtable text;
v_lot integer;
v_code text;

v_prev_search_path text;

BEGIN

    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', format('%I, public', TG_TABLE_SCHEMA), true);
    v_featuretype:= TG_ARGV[0];
    v_project_type = (SELECT project_type FROM sys_version ORDER by 1 desc LIMIT 1);
    v_lot = (SELECT lot_id FROM om_visit_lot_x_user WHERE endtime IS NULL AND user_id=current_user);


    IF v_featuretype IS NULL THEN
        v_triggerfromtable = 'om_visit';
    ELSE
        v_triggerfromtable = 'om_visit_x_feature';
    END IF;

    IF TG_OP='INSERT' THEN

		IF v_triggerfromtable = 'om_visit' THEN -- we need workflow when function is triggered by om_visit (for this reason when parameter is null)

			-- get if its first visit of lot to set it with status (ON GOING)
			IF (SELECT count (*) FROM om_visit WHERE lot_id=NEW.lot_id) = 1 THEN
				UPDATE om_visit_lot SET status = 4, real_startdate = NOW() WHERE id=NEW.lot_id;
			END IF;


		ELSIF v_triggerfromtable ='om_visit_x_feature' THEN -- change feature_x_lot status (when function is triggered by om_visit_x_*

			--TODO: when visit is inserted via QGIS, we need to set class_id (adding this widget in the form of the new visit)

			SELECT * INTO v_visit FROM om_visit WHERE id=NEW.visit_id;

			-- insert element into lot_x_element table in case if doesn't exist when visit is planned(lot created in web)
			IF v_lot IS NOT NULL AND v_visit.visit_type=1 THEN

				IF v_featuretype ='arc' THEN
				    IF (SELECT arc_id FROM om_visit_lot_x_arc where arc_id=NEW.arc_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM arc WHERE arc_id=NEW.arc_id);
                        INSERT INTO om_visit_lot_x_arc VALUES (v_lot, NEW.arc_id, v_code, 1);
				    END IF;
				ELSIF v_featuretype ='node' THEN
				    IF (SELECT node_id FROM om_visit_lot_x_node where node_id=NEW.node_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM node WHERE node_id=NEW.node_id);
                        INSERT INTO om_visit_lot_x_node VALUES (v_lot, NEW.node_id, v_code, 1);
				    END IF;
				ELSIF v_featuretype ='connec' THEN
				    IF (SELECT connec_id FROM om_visit_lot_x_connec where connec_id=NEW.connec_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM connec WHERE connec_id=NEW.connec_id);
                        INSERT INTO om_visit_lot_x_connec VALUES (v_lot, NEW.connec_id, v_code, 1);
				    END IF;
				ELSIF v_featuretype ='gully' THEN
				    IF (SELECT gully_id FROM om_visit_lot_x_gully where gully_id=NEW.gully_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM gully WHERE gully_id=NEW.gully_id);
                        INSERT INTO om_visit_lot_x_gully VALUES (v_lot, NEW.gully_id, v_code, 1);
				    END IF;
				END IF;


				-- move status of lot element to status=0 (visited)

				IF v_featuretype ='arc' THEN
				    v_querytext= 'UPDATE om_visit_lot_x_arc SET status=0 WHERE lot_id::text=' || quote_literal (v_visit.lot_id) ||' AND arc_id::text ='||quote_literal(NEW.arc_id);

				ELSIF v_featuretype ='node' THEN
				    v_querytext= 'UPDATE om_visit_lot_x_node SET status=0 WHERE lot_id::text=' || quote_literal (v_visit.lot_id) ||' AND node_id::text ='||quote_literal(NEW.node_id);

				ELSIF v_featuretype ='connec' THEN
				    v_querytext= 'UPDATE om_visit_lot_x_connec SET status=0 WHERE lot_id::text=' || quote_literal (v_visit.lot_id) ||' AND connec_id::text ='||quote_literal(NEW.connec_id);

				ELSIF v_featuretype ='gully' THEN
				    v_querytext= 'UPDATE om_visit_lot_x_gully SET status=0 WHERE lot_id::text=' || quote_literal (v_visit.lot_id) ||' AND gully_id::text ='||quote_literal(NEW.gully_id);
				END IF;

				IF v_querytext IS NOT NULL THEN
				    EXECUTE v_querytext;
				END IF;

			END IF;
		END IF;

		PERFORM set_config('search_path', v_prev_search_path, true);
		RETURN NEW;


    ELSIF TG_OP='UPDATE' AND v_triggerfromtable ='om_visit' THEN -- we need workflow when function is triggered by om_visit (for this reason when parameter is null)


		-- move status of lot element to status=0 (visited)

		IF NEW.status = 4 AND OLD.status < 4 THEN

			v_featuretype = (SELECT lower(feature_type) FROM om_visit_lot WHERE id = NEW.lot_id LIMIT 1);

            IF v_featuretype  = 'arc' THEN
                v_id = (SELECT arc_id FROM om_visit_x_arc WHERE visit_id=NEW.visit_id);
                v_visittable = 'om_visit_x_arc';
                v_lottable = 'om_visit_lot_x_arc';
                v_featureid = 'arc_id';

            ELSIF v_featuretype  = 'node' THEN
				v_id = (SELECT node_id FROM om_visit_x_node WHERE visit_id=NEW.id);
				v_visittable = 'om_visit_x_node';
				v_lottable = 'om_visit_lot_x_node';
				v_featureid = 'node_id';

            ELSIF v_featuretype  = 'connec' THEN
				v_id = (SELECT connec_id FROM om_visit_x_connec WHERE visit_id=NEW.id);
				v_visittable = 'om_visit_x_connec';
				v_lottable = 'om_visit_lot_x_connec';
				v_featureid = 'connec_id';

            ELSIF v_featuretype  = 'gully' THEN
				v_id = (SELECT gully_id FROM om_visit_x_gully WHERE visit_id=NEW.id);
				v_visittable = 'om_visit_x_gully';
				v_lottable = 'om_visit_lot_x_gully';
				v_featureid = 'gully_id';

            END IF;

		    v_querytext= 'UPDATE '||quote_ident(v_lottable) ||' SET status=0 WHERE lot_id::text=' || quote_literal (NEW.lot_id) ||' AND '||quote_ident(v_featureid)||'::text ='||quote_literal(v_id);
		    IF v_querytext IS NOT NULL THEN
                EXECUTE v_querytext;
		    END IF;

		    -- when visit is finished and it has not lot_id assigned visit is automatic published
		    IF NEW.lot_id IS NULL THEN
                UPDATE om_visit SET publish=TRUE WHERE id=NEW.id;
		    END IF;


		END IF;

		PERFORM set_config('search_path', v_prev_search_path, true);
		RETURN NEW;


    END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


