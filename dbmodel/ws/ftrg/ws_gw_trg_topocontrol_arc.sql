/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 1344

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_topocontrol_arc() RETURNS trigger AS $BODY$
DECLARE
nodeRecord1 record;
nodeRecord2 record;
vnoderec record;
newPoint public.geometry;
connecPoint public.geometry;
v_sys_statetopocontrol boolean;
connec_id_aux varchar;
array_agg varchar [];
v_dsbl_error boolean;
v_samenode_init_end_control boolean;
v_nodeinsert_arcendpoint boolean;
v_arc_searchnodes_control boolean;
v_arc_searchnodes double precision;
v_node2 text;
v_nodecat text;
v_message text;
v_msg boolean = false;
v_check_conflictmapzones boolean = false;
v_zone text;
v_user_disable_statetopocontrol boolean;
v_user_disable_arctopocontrol boolean;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Get system variables
	SELECT ((value::json)->>'activated') INTO v_check_conflictmapzones FROM config_param_system WHERE parameter='edit_arc_check_conflictmapzones';
	SELECT value::boolean INTO v_sys_statetopocontrol FROM config_param_system WHERE parameter='edit_state_topocontrol';
	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_disable_error' ;
	SELECT value::boolean INTO v_samenode_init_end_control FROM config_param_system WHERE parameter='edit_arc_samenode_control' ;
	SELECT ((value::json)->>'activated') INTO v_arc_searchnodes_control FROM config_param_system WHERE parameter='edit_arc_searchnodes';
	SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM config_param_system WHERE parameter='edit_arc_searchnodes';

	-- get user variables
	SELECT value::boolean INTO v_user_disable_statetopocontrol FROM config_param_user WHERE parameter='edit_disable_statetopocontrol' AND cur_user = current_user;
	SELECT value::boolean INTO v_user_disable_arctopocontrol FROM config_param_user WHERE parameter='edit_disable_arctopocontrol' AND cur_user = current_user;
	SELECT value::boolean INTO v_nodeinsert_arcendpoint FROM config_param_user WHERE parameter='edit_arc_insert_automatic_endpoint' AND cur_user = current_user;


	--Check if user has migration mode enabled
	IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_disable_topocontrol' AND cur_user=current_user) IS TRUE THEN
		v_samenode_init_end_control = FALSE;
		v_dsbl_error = TRUE;
	END IF;

	-- disable trigger
	IF v_arc_searchnodes_control IS FALSE OR v_user_disable_arctopocontrol THEN
		RETURN NEW;
	END IF;

	IF v_sys_statetopocontrol IS NOT TRUE OR v_user_disable_statetopocontrol IS TRUE THEN

		-- working without statetopocontrol
		SELECT node.*,node_type INTO nodeRecord1 FROM node
		JOIN cat_node ON cat_node.id=node.nodecat_id
		JOIN cat_feature_node ON cat_feature_node.id = node_type
		WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes) ORDER BY
		(case when isarcdivide is true then 1 else 2 end),
		ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) limit 1;

		SELECT node.*,node_type INTO nodeRecord2 FROM node
		JOIN cat_node ON cat_node.id=node.nodecat_id
		JOIN cat_feature_node ON cat_feature_node.id = node_type
		WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes) ORDER BY
		(case when isarcdivide is true then 1 else 2 end),
		ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) limit 1;

	ELSE
		-- Looking for state control
		PERFORM gw_fct_state_control(json_build_object('parameters', json_build_object('feature_type_aux', 'ARC', 'feature_id_aux', NEW.arc_id, 'state_aux', NEW.state, 'tg_op_aux', TG_OP)));

		-- Lookig for state=0
		IF NEW.state=0 THEN
			RETURN NEW;
		END IF;

		-- Starting process
		IF TG_OP='INSERT' THEN

			SELECT * INTO nodeRecord1 FROM node
			JOIN cat_node ON cat_node.id=node.nodecat_id
			JOIN cat_feature_node ON cat_feature_node.id = node_type
			WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
			AND ((NEW.state=1 AND node.state=1)

						-- looking for existing nodes that not belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=1 AND node_id NOT IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=0 AND psector_id=
								(SELECT value::integer FROM config_param_user
								WHERE parameter='plan_psector_current' AND cur_user="current_user"() LIMIT 1)))

						-- looking for planified nodes that belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=2 AND node_id IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=1 AND psector_id=
								(SELECT value::integer FROM config_param_user
								WHERE parameter='plan_psector_current' AND cur_user="current_user"() LIMIT 1))))

			ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;


			SELECT * INTO nodeRecord2 FROM node
			JOIN cat_node ON cat_node.id=node.nodecat_id
			JOIN cat_feature_node ON cat_feature_node.id = node_type
			WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
			AND ((NEW.state=1 AND node.state=1)

						-- looking for existing nodes that not belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=1 AND node_id NOT IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=0 AND psector_id=
								(SELECT value::integer FROM config_param_user
								WHERE parameter='plan_psector_current' AND cur_user="current_user"() LIMIT 1)))

						-- looking for planified nodes that belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=2 AND node_id IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=1 AND psector_id=
								(SELECT value::integer FROM config_param_user
								WHERE parameter='plan_psector_current' AND cur_user="current_user"() LIMIT 1))))

			ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;

		ELSIF TG_OP='UPDATE' THEN


			SELECT * INTO nodeRecord1 FROM node
			JOIN cat_node ON cat_node.id=node.nodecat_id
			JOIN cat_feature_node ON cat_feature_node.id = node_type
			WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
			AND ((NEW.state=1 AND node.state=1)

						-- looking for existing nodes that not belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=1 AND node_id NOT IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=0 AND psector_id IN
								(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id)))


						-- looking for planified nodes that belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=2 AND node_id IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=1 AND psector_id IN
								(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id))))

			ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;


			SELECT * INTO nodeRecord2 FROM node
			JOIN cat_node ON cat_node.id=node.nodecat_id
			JOIN cat_feature_node ON cat_feature_node.id = node_type
			WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, v_arc_searchnodes)
			AND ((NEW.state=1 AND node.state=1)

						-- looking for existing nodes that not belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=1 AND node_id NOT IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=0 AND psector_id IN
								(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id)))


						-- looking for planified nodes that belongs on the same alternatives that arc
						OR (NEW.state=2 AND node.state=2 AND node_id IN
							(SELECT node_id FROM plan_psector_x_node
							 WHERE plan_psector_x_node.node_id=node.node_id AND state=1 AND psector_id IN
								(SELECT psector_id FROM plan_psector_x_arc WHERE arc_id=NEW.arc_id))))

			ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;
		END IF;
	END IF;

	-- check mapzones conflict
    IF v_check_conflictmapzones IS TRUE then
    	if nodeRecord1.sector_id != nodeRecord2.sector_id and nodeRecord1.sector_id > 0 and nodeRecord2.sector_id > 0 and
    	(nodeRecord1.node_type not in (select id from cat_feature_node where 'SECTOR' = ANY(graph_delimiter)) and
    	nodeRecord2.node_type not in (select id from cat_feature_node where 'SECTOR' = ANY(graph_delimiter))) then
    		v_msg  = true;
    		v_zone = 'SECTOR';
    	end if;

        if nodeRecord1.presszone_id != nodeRecord2.presszone_id and nodeRecord1.presszone_id::integer > 0 and nodeRecord2.presszone_id::integer > 0 and
    	(nodeRecord1.node_type not in (select id from cat_feature_node where 'PRESSZONE' = ANY(graph_delimiter)) and
    	nodeRecord2.node_type not in (select id from cat_feature_node where 'PRESSZONE' = ANY(graph_delimiter))) then
    		v_msg  = true;
    		v_zone = 'PRESSZONE';
    	end if;

        if nodeRecord1.dma_id != nodeRecord2.dma_id and nodeRecord1.dma_id > 0 and nodeRecord2.dma_id > 0 and
    	(nodeRecord1.node_type not in (select id from cat_feature_node where 'DMA' = ANY(graph_delimiter)) and
    	nodeRecord2.node_type not in (select id from cat_feature_node where 'DMA' = ANY(graph_delimiter))) then
    		v_msg  = true;
    		v_zone = 'DMA';
    	end if;

        if nodeRecord1.dqa_id != nodeRecord2.dqa_id and nodeRecord1.dqa_id > 0 and nodeRecord2.dqa_id > 0 and
    	(nodeRecord1.node_type not in (select id from cat_feature_node where 'DQA' = ANY(graph_delimiter)) and
    	nodeRecord2.node_type not in (select id from cat_feature_node where 'DQA' = ANY(graph_delimiter))) then
    		v_msg  = true;
    		v_zone = 'DQA';
    	end if;

    	if v_msg THEN
     			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                "data":{"message":"3236", "function":"1344","parameters":{"zone":"'||v_zone||'"}}}$$);';
		end if;
    end if;


    -- only if user variable is not disabled
    IF v_user_disable_statetopocontrol IS FALSE THEN

        --  Control of start/end node
        IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN

            -- Control of same node initial and final
            IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (v_samenode_init_end_control IS TRUE) THEN
                IF v_dsbl_error IS NOT TRUE THEN
                    EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                    "data":{"message":"1040", "function":"1344","parameters":{"node_id":"'||nodeRecord1.node_id||'"}}}$$);';
                ELSE
                    SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 1040;
                    INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (103, NEW.arc_id, v_message);
                END IF;
            ELSIF ((nodeRecord1.state = 2) OR (nodeRecord2.state = 2)) AND (NEW.state = 1) THEN
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                    "data":{"message":"3192", "function":"1344","parameters":null}}$$);';
            ELSE
                -- Update coordinates
                NEW.the_geom:= ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
                NEW.the_geom:= ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
                NEW.node_1:= nodeRecord1.node_id;
                NEW.node_2:= nodeRecord2.node_id;

            END IF;

        -- Check auto insert end nodes
        ELSIF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NULL) AND v_nodeinsert_arcendpoint THEN
            IF TG_OP = 'INSERT' THEN

                -- getting nodecat user's value
                v_nodecat:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_nodecat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
                -- get first value (last chance)
                IF (v_nodecat IS NULL) THEN
                    v_nodecat := (SELECT id FROM cat_node WHERE active IS TRUE LIMIT 1);
                END IF;

                -- Inserting new node
                INSERT INTO ve_node (node_id, sector_id, state, state_type, dma_id, presszone_id, soilcat_id, workcat_id, builtdate, nodecat_id, ownercat_id, muni_id,
                postcode, district_id, expl_id, the_geom)
                VALUES ((SELECT nextval('urn_id_seq')), NEW.sector_id, NEW.state, NEW.state_type, NEW.dma_id, NEW.presszone_id, NEW.soilcat_id, NEW.workcat_id, NEW.builtdate, v_nodecat,
                NEW.ownercat_id, NEW.muni_id, NEW.postcode, NEW.district_id, NEW.expl_id, st_endpoint(NEW.the_geom))
                RETURNING node_id INTO v_node2;

                -- Update arc
                NEW.node_1:= nodeRecord1.node_id;
                NEW.node_2:= v_node2;
            END IF;

        --Error, no existing nodes
        ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (v_arc_searchnodes_control IS TRUE) THEN
            IF v_dsbl_error IS NOT TRUE THEN
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                    "data":{"message":"1042", "function":"1344","parameters":{"arc_id":"'||NEW.arc_id||'"}}}$$);';
            ELSE
                SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 1042;
                INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (103, NEW.arc_id, v_message);
            END IF;

        --Not existing nodes but accepted insertion
        ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (v_arc_searchnodes_control IS FALSE) THEN
            RETURN NEW;

        ELSE
            IF v_dsbl_error IS NOT TRUE THEN
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                    "data":{"message":"1042", "function":"1344","parameters":{"arc_id":"'||NEW.arc_id||'"}}}$$);';
            ELSE
                SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 1042;
                INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (103, NEW.arc_id, v_message);
            END IF;
        END IF;

		-- if the new arc is equal to an existing arc
      	IF TG_OP = 'INSERT' AND (SELECT EXISTS (SELECT 1 FROM arc WHERE ST_Equals(the_geom, NEW.the_geom) AND arc.state = 1 AND NEW.state=1)) IS TRUE THEN
      
			IF v_dsbl_error IS NOT TRUE THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"4348", "function":"1344","parameters":null}}$$);';
			ELSE
				SELECT concat('ERROR-',id,':',error_message,'.',hint_message) INTO v_message FROM sys_message WHERE id = 4348;
				INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (103, NEW.arc_id, v_message);
			END IF;

		END IF;


    END IF;

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

