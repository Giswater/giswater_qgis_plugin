/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_om_visit_lotmanage()
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
v_unit integer;
v_compare_lot integer;
v_status integer;
v_vehicle integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_featuretype:= TG_ARGV[0];
    v_project_type = (SELECT project_type FROM sys_version ORDER by 1 desc LIMIT 1);
    v_lot = (SELECT lot_id FROM om_visit_lot_x_user WHERE endtime IS NULL AND user_id=current_user);
   	v_vehicle = (SELECT vehicle_id FROM om_visit_lot_x_user WHERE endtime IS NULL AND user_id=current_user);


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
					-- select values in order to know if a unit related to v_lot exists. If not, lot will be CREATED ON WEB
				   	EXECUTE 'SELECT v.unit_id, v.status FROM om_visit v JOIN om_visit_x_arc f ON f.visit_id=v.id
					WHERE v.lot_id='||v_lot||' AND arc_id='||quote_literal(NEW.arc_id)||' LIMIT 1'
					INTO v_unit, v_status;
					
					IF v_unit IS NOT NULL THEN
						EXECUTE 'SELECT lot_id FROM om_visit_lot_x_unit
						WHERE lot_id='||v_lot||' AND unit_id='||v_unit||' LIMIT 1' 
						INTO v_compare_lot;
					END IF;
				
				    IF (SELECT arc_id FROM om_visit_lot_x_arc where arc_id=NEW.arc_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM arc WHERE arc_id=NEW.arc_id);
                       	-- insert missing arc because lot is created from web
                        INSERT INTO om_visit_lot_x_arc VALUES (v_lot, NEW.arc_id, v_code, 1, NULL, v_unit);
                       	
                       	-- insert other arcs related to unit
                       	INSERT INTO om_visit_lot_x_arc SELECT v_lot, arc_id, code, 1, NULL, unit_id FROM om_visit_lot_x_arc 
                       	WHERE unit_id=v_unit and arc_id<>NEW.arc_id and lot_id=(select lot_id from om_visit_lot_x_arc WHERE unit_id=v_unit order by lot_id desc offset 1 limit 1);
                       
				    END IF;				
				ELSIF v_featuretype ='node' THEN
					-- select values in order to know if a unit related to v_lot exists. If not, lot will be CREATED ON WEB
				   	EXECUTE 'SELECT v.unit_id, v.status FROM om_visit v JOIN om_visit_x_node f ON f.visit_id=v.id
					WHERE v.lot_id='||v_lot||' AND node_id='||quote_literal(NEW.node_id)||' LIMIT 1'
					INTO v_unit, v_status;
					
					IF v_unit IS NOT NULL THEN
						EXECUTE 'SELECT lot_id FROM om_visit_lot_x_unit
						WHERE lot_id='||v_lot||' AND unit_id='||v_unit||' LIMIT 1' 
						INTO v_compare_lot;
					END IF;
				
				    IF (SELECT node_id FROM om_visit_lot_x_node where node_id=NEW.node_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM node WHERE node_id=NEW.node_id);
                        INSERT INTO om_visit_lot_x_node VALUES (v_lot, NEW.node_id, v_code, 1, NULL, v_unit);
				    END IF;	
				ELSIF v_featuretype ='connec' THEN	
					-- select values in order to know if a unit related to v_lot exists. If not, lot will be CREATED ON WEB
				   	EXECUTE 'SELECT v.unit_id, v.status FROM om_visit v JOIN om_visit_x_connec f ON f.visit_id=v.id
					WHERE v.lot_id='||v_lot||' AND connec_id='||quote_literal(NEW.connec_id)||' LIMIT 1'
					INTO v_unit, v_status;
					
					IF v_unit IS NOT NULL THEN
						EXECUTE 'SELECT lot_id FROM om_visit_lot_x_unit
						WHERE lot_id='||v_lot||' AND unit_id='||v_unit||' LIMIT 1' 
						INTO v_compare_lot;
					END IF;
				
				    IF (SELECT connec_id FROM om_visit_lot_x_connec where connec_id=NEW.connec_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM connec WHERE connec_id=NEW.connec_id);
                        INSERT INTO om_visit_lot_x_connec VALUES (v_lot, NEW.connec_id, v_code, 1, NULL, v_unit);
				    END IF;	
				ELSIF v_featuretype ='gully' THEN	
					-- select values in order to know if a unit related to v_lot exists. If not, lot will be CREATED ON WEB
				   	EXECUTE 'SELECT v.unit_id, v.status FROM om_visit v JOIN om_visit_x_gully f ON f.visit_id=v.id
					WHERE v.lot_id='||v_lot||' AND gully_id='||quote_literal(NEW.gully_id)||' LIMIT 1'
					INTO v_unit, v_status;
				
					IF v_unit IS NOT NULL THEN
						EXECUTE 'SELECT lot_id FROM om_visit_lot_x_unit
						WHERE lot_id='||v_lot||' AND unit_id='||v_unit||' LIMIT 1' 
						INTO v_compare_lot;
					END IF;
				
				    IF (SELECT gully_id FROM om_visit_lot_x_gully where gully_id=NEW.gully_id AND lot_id=v_lot) IS NULL THEN
                        v_code = (SELECT code FROM gully WHERE gully_id=NEW.gully_id);
                        INSERT INTO om_visit_lot_x_gully VALUES (v_lot, NEW.gully_id, v_code, 1, NULL, v_unit);
				    END IF;				
				END IF;
			
				IF v_project_type='UD' THEN
					-- if compare_lot is null that will mean this is a LOT CREATED ON WEB without planification, so insert into om_visit_lot_x_unit is needed
					IF v_lot IS NOT NULL AND v_compare_lot IS NULL THEN
						INSERT INTO om_visit_lot_x_unit 
						SELECT unit_id, v_lot, v_status, NULL, the_geom, unit_type, length, way_type, way_in, way_out, macrounit_id, trace_type, trace_id, node_1, node_2
						FROM om_visit_lot_x_unit WHERE unit_id=v_unit ON CONFLICT (unit_id, lot_id) DO NOTHING;
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
		
			UPDATE om_visit set vehicle_id=v_vehicle WHERE id=v_visit.id;
		
		END IF;

		RETURN NEW;


    ELSIF TG_OP='UPDATE' AND v_triggerfromtable ='om_visit' THEN -- we need workflow when function is triggered by om_visit (for this reason when parameter is null)


		-- move status of lot element to status=0 (visited)

		IF NEW.status = 4 THEN 
		
			v_featuretype = (SELECT lower(feature_type) FROM om_visit_lot WHERE id = NEW.lot_id LIMIT 1);

            IF v_featuretype  = 'arc' THEN
                v_id = (SELECT arc_id FROM om_visit_x_arc WHERE visit_id=NEW.id);
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


	RETURN NEW;
				
		
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


