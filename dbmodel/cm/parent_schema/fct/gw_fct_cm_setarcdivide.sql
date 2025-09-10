/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3498

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_setarcdivide(p_data json) RETURNS json AS
$BODY$
DECLARE
    -- Simplified declarations
    v_node_geom public.geometry;
    v_arc_id integer;
    v_arc_geom public.geometry;
    v_line1 public.geometry;
    v_line2 public.geometry;
    v_intersect_loc double precision;
    v_project_type text;
    v_state_arc integer;
    v_state_node integer;
    v_arc_divide_tolerance float = 0.05;
    v_arc_searchnodes float;
    v_schemaname text;
    rec_aux1 "PARENT_SCHEMA".arc;
    rec_aux2 "PARENT_SCHEMA".arc;
    v_node_id integer;
    v_arc_closest integer;
    v_set_arc_obsolete boolean;
    v_obsoletetype integer;
    rec_link record;
    rec_connec record;
    rec_gully record;
    v_sql text;
    v_arc_type text;
    v_manquerytext text;
    v_manquerytext1 text;
    v_manquerytext2 text;
    v_epaquerytext text;
    v_epaquerytext1 text;
    v_epaquerytext2 text;
    v_mantable text;
    v_epatable text;
    v_arc_childtable_name text;
    rec_addfields record;
    v_query_string_update text;
    v_code varchar;
    v_isarcdivide boolean;
    v_node_type text;

    -- For result
    v_status text := 'Failed';
    v_message text;
    v_new_arc1_id integer;
    v_new_arc2_id integer;

    v_prev_search_path text;

BEGIN
    -- Search path (transaction-local)
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'cm,public', true);
    v_schemaname = 'cm';

    v_node_id := (p_data->'feature'->'id'->>0)::integer;

    -- Basic checks and data retrieval
    SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;
    
    SELECT the_geom, state INTO v_node_geom, v_state_node FROM PARENT_SCHEMA.node WHERE node_id = v_node_id;
    IF v_node_geom IS NULL THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN json_build_object('status', 'Failed', 'message', 'Node not found');
    END IF;

    IF v_state_node = 0 THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN json_build_object('status', 'Failed', 'message', 'Node state is 0');
    END IF;

    -- For CM project type, we need to get node_type from the CM campaign table
    IF v_project_type = 'WS' THEN
        SELECT isarcdivide INTO v_isarcdivide
        FROM PARENT_SCHEMA.cat_feature_node JOIN PARENT_SCHEMA.cat_node ON cat_node.node_type=cat_feature_node.id
        JOIN PARENT_SCHEMA.node ON node.nodecat_id = cat_node.id WHERE node.node_id=v_node_id;
    ELSE
        -- For CM, get node_type from the campaign table since PARENT_SCHEMA.node doesn't have node_type
        SELECT isarcdivide INTO v_isarcdivide
        FROM PARENT_SCHEMA.cat_feature_node cfn 
        JOIN cm.om_campaign_x_node cxn ON cxn.node_type = cfn.id 
        WHERE cxn.node_id = v_node_id;
    END IF;
    
    IF v_isarcdivide IS NOT TRUE THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN json_build_object('status', 'Failed', 'message', 'Node type is not configured to divide arcs');
    END IF;

    -- Config parameters
    SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM PARENT_SCHEMA.config_param_system WHERE parameter='edit_arc_searchnodes';
    v_set_arc_obsolete := (SELECT json_extract_path_text (value::json,'setArcObsolete')::boolean FROM PARENT_SCHEMA.config_param_system WHERE parameter='edit_arc_divide');
    SELECT value::smallint INTO v_obsoletetype FROM PARENT_SCHEMA.config_param_user where parameter='edit_statetype_0_vdefault' AND cur_user=current_user;
    IF v_obsoletetype IS NULL THEN
        SELECT id INTO v_obsoletetype FROM PARENT_SCHEMA.value_state_type WHERE state=0 LIMIT 1;
    END IF;

    -- update arc_id null in case the node has related the arc_id
    UPDATE PARENT_SCHEMA.node set arc_id = null where node_id = v_node_id and arc_id is not NULL;

    -- Find closest arc inside tolerance (check both campaign and lot arcs)
    SELECT arc_id, state, the_geom, code INTO v_arc_id, v_state_arc, v_arc_geom, v_code  
    FROM PARENT_SCHEMA.ve_arc AS a
    WHERE ST_DWithin(v_node_geom, a.the_geom, v_arc_divide_tolerance) 
      AND node_1 != v_node_id 
      AND node_2 != v_node_id
      AND arc_id IN (
          SELECT arc_id FROM cm.om_campaign_x_arc
          UNION
          SELECT arc_id FROM cm.om_campaign_lot_x_arc
      )
    ORDER BY ST_Distance(v_node_geom, a.the_geom) LIMIT 1;

    IF v_arc_id IS NULL THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN json_build_object('status', 'Failed', 'message', 'No arc found to divide within tolerance');
    END IF;

    IF v_state_arc = 0 THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN json_build_object('status', 'Failed', 'message', 'Arc state is 0');
    END IF;
    
    --  Locate position of the nearest point
    v_intersect_loc := ST_LineLocatePoint(v_arc_geom, v_node_geom);

    -- Compute pieces
    v_line1 := ST_LineSubstring(v_arc_geom, 0.0, v_intersect_loc);
    v_line2 := ST_LineSubstring(v_arc_geom, v_intersect_loc, 1.0);

    IF (ST_GeometryType(v_line1) = 'ST_Point') OR (ST_GeometryType(v_line2) = 'ST_Point') THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN json_build_object('status', 'Failed', 'message', 'Division point is at the start or end of the arc');
    END IF;

    -- Get arc data
    SELECT * INTO rec_aux1 FROM PARENT_SCHEMA.arc WHERE arc_id = v_arc_id;
    SELECT * INTO rec_aux2 FROM PARENT_SCHEMA.arc WHERE arc_id = v_arc_id;

    -- Update values of new arc_id (1)
    rec_aux1.arc_id := nextval('PARENT_SCHEMA.urn_id_seq');
    rec_aux1.code := rec_aux1.arc_id; -- Simplified code generation
    rec_aux1.node_2 := v_node_id;
    rec_aux1.the_geom := v_line1;

    -- Update values of new arc_id (2)
    rec_aux2.arc_id := nextval('PARENT_SCHEMA.urn_id_seq');
    rec_aux2.code := rec_aux2.arc_id; -- Simplified code generation
    rec_aux2.node_1 := v_node_id;
    rec_aux2.the_geom := v_line2;

    -- Insert new records into arc table
    INSERT INTO PARENT_SCHEMA.arc SELECT rec_aux1.*;
    INSERT INTO PARENT_SCHEMA.arc SELECT rec_aux2.*;

    v_new_arc1_id := rec_aux1.arc_id;
    v_new_arc2_id := rec_aux2.arc_id;
    
    -- Child tables duplication
    v_sql := 'SELECT arc_type FROM PARENT_SCHEMA.cat_arc WHERE id = (SELECT arccat_id FROM PARENT_SCHEMA.arc WHERE arc_id = '||v_arc_id||');';
    EXECUTE v_sql INTO v_arc_type;
    
    v_mantable = (SELECT man_table FROM PARENT_SCHEMA.cat_feature_arc c JOIN PARENT_SCHEMA.cat_feature cf ON c.id = cf.id JOIN PARENT_SCHEMA.sys_feature_class s ON cf.feature_class = s.id JOIN PARENT_SCHEMA.ve_arc ON c.id=arc_type WHERE arc_id=v_arc_id);
    v_epatable = (SELECT epa_table FROM PARENT_SCHEMA.cat_feature_arc c JOIN PARENT_SCHEMA.sys_feature_epa_type s ON epa_default = s.id JOIN PARENT_SCHEMA.ve_arc ON c.id=arc_type WHERE arc_id=v_arc_id);
    
    -- building querytext for man_table
    IF v_mantable IS NOT NULL THEN
        v_manquerytext:= (SELECT replace (replace (array_agg(column_name::text)::text,'{',','),'}','') FROM (SELECT column_name FROM information_schema.columns
        WHERE table_name=v_mantable AND table_schema='PARENT_SCHEMA' AND column_name !='arc_id' ORDER BY ordinal_position)a);
        IF v_manquerytext IS NULL THEN
            v_manquerytext='';
        END IF;
        v_manquerytext1 = 'INSERT INTO '||'PARENT_SCHEMA'||'.'||v_mantable||' SELECT ';
        v_manquerytext2 = v_manquerytext||' FROM '||'PARENT_SCHEMA'||'.'||v_mantable||' WHERE arc_id= '||v_arc_id||'';
        EXECUTE v_manquerytext1||rec_aux1.arc_id||v_manquerytext2;
        EXECUTE v_manquerytext1||rec_aux2.arc_id||v_manquerytext2;
    END IF;

    -- building querytext for epa_table
    IF v_epatable IS NOT NULL THEN
        v_epaquerytext:= (SELECT replace (replace (array_agg(column_name::text)::text,'{',','),'}','') FROM (SELECT column_name FROM information_schema.columns
        WHERE table_name=v_epatable AND table_schema='PARENT_SCHEMA' AND column_name !='arc_id' ORDER BY ordinal_position)a);
        IF  v_epaquerytext IS NULL THEN
            v_epaquerytext='';
        END IF;
        v_epaquerytext1 =  'INSERT INTO '||'PARENT_SCHEMA'||'.'||v_epatable||' SELECT ';
        v_epaquerytext2 =  v_epaquerytext||' FROM '||'PARENT_SCHEMA'||'.'||v_epatable||' WHERE arc_id= '||v_arc_id||'';
        EXECUTE v_epaquerytext1||rec_aux1.arc_id||v_epaquerytext2;
        EXECUTE v_epaquerytext1||rec_aux2.arc_id||v_epaquerytext2;
    END IF;

    -- update node_1 and node_2 because it's not possible to pass using parameters
    UPDATE PARENT_SCHEMA.arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
    UPDATE PARENT_SCHEMA.arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;
    
    v_arc_childtable_name := 'man_arc_' || lower(v_arc_type);
    IF (SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = 'PARENT_SCHEMA' AND table_name = v_arc_childtable_name)) IS TRUE THEN
        EXECUTE 'INSERT INTO '||'PARENT_SCHEMA'||'.'||v_arc_childtable_name||' (arc_id) VALUES ('''||rec_aux1.arc_id||''');';
        EXECUTE 'INSERT INTO '||'PARENT_SCHEMA'||'.'||v_arc_childtable_name||' (arc_id) VALUES ('''||rec_aux2.arc_id||''');';

        v_sql := 'SELECT column_name FROM information_schema.columns 
                WHERE table_schema = '''||'PARENT_SCHEMA'||''' 
                AND table_name = '''||v_arc_childtable_name||''' 
                AND column_name !=''id'' AND column_name != ''arc_id'' ;';

        FOR rec_addfields IN EXECUTE v_sql
        LOOP
            v_query_string_update = 'UPDATE '||'PARENT_SCHEMA'||'.'||v_arc_childtable_name||' SET '||rec_addfields.column_name|| ' = '
                                    '( SELECT '||rec_addfields.column_name||' FROM '||'PARENT_SCHEMA'||'.'||v_arc_childtable_name||' WHERE arc_id = '||quote_literal(v_arc_id)||' ) '
                                    'WHERE '||v_arc_childtable_name||'.arc_id = '||quote_literal(rec_aux1.arc_id)||';';
            EXECUTE v_query_string_update;
            
            v_query_string_update = 'UPDATE '||'PARENT_SCHEMA'||'.'||v_arc_childtable_name||' SET '||rec_addfields.column_name|| ' = '
                                    '( SELECT '||rec_addfields.column_name||' FROM '||'PARENT_SCHEMA'||'.'||v_arc_childtable_name||' WHERE arc_id = '||quote_literal(v_arc_id)||' ) '
                                    'WHERE '||v_arc_childtable_name||'.arc_id = '||quote_literal(rec_aux2.arc_id)||';';
            EXECUTE v_query_string_update;
        END LOOP;
    END IF;
    
    -- Reconnect connecs and gullies
    -- reconnect operative connec links
    FOR rec_link IN SELECT * FROM PARENT_SCHEMA.link WHERE exit_type = 'ARC' AND exit_id = v_arc_id AND state = 1 AND feature_type  ='CONNEC'
    LOOP
        SELECT arc_id INTO v_arc_closest FROM PARENT_SCHEMA.link l, PARENT_SCHEMA.ve_arc a WHERE st_dwithin(a.the_geom, st_endpoint(l.the_geom),1) AND l.link_id = rec_link.link_id
        AND arc_id IN (rec_aux1.arc_id, rec_aux2.arc_id) LIMIT 1;
        UPDATE PARENT_SCHEMA.connec SET arc_id = v_arc_closest WHERE arc_id = v_arc_id AND connec_id = rec_link.feature_id;
        UPDATE PARENT_SCHEMA.link SET exit_id = v_arc_closest WHERE link_id = rec_link.link_id;
    END LOOP;

    -- reconnect operative gully links
    IF v_project_type = 'UD' THEN
        FOR rec_link IN SELECT * FROM PARENT_SCHEMA.link WHERE exit_type = 'ARC' AND exit_id = v_arc_id AND state = 1 AND feature_type  ='GULLY'
        LOOP
            SELECT arc_id INTO v_arc_closest FROM PARENT_SCHEMA.link l, PARENT_SCHEMA.ve_arc a WHERE st_dwithin(a.the_geom, st_endpoint(l.the_geom),1) AND l.link_id = rec_link.link_id
            AND arc_id IN (rec_aux1.arc_id, rec_aux2.arc_id) LIMIT 1;
            UPDATE PARENT_SCHEMA.gully SET arc_id = v_arc_closest WHERE arc_id = v_arc_id AND gully_id = rec_link.feature_id;
            UPDATE PARENT_SCHEMA.link SET exit_id = v_arc_closest WHERE link_id = rec_link.link_id;
        END LOOP;
    END IF;
    
    -- reconnect connecs without link but with arc_id
    FOR rec_connec IN SELECT connec_id FROM PARENT_SCHEMA.connec WHERE arc_id=v_arc_id AND state = 1 AND pjoint_type='ARC'
    AND connec_id NOT IN (SELECT DISTINCT feature_id FROM PARENT_SCHEMA.link WHERE exit_id=v_arc_id)
    LOOP
        SELECT a.arc_id INTO v_arc_closest FROM PARENT_SCHEMA.connec c, PARENT_SCHEMA.ve_arc a WHERE st_dwithin(a.the_geom, c.the_geom, 100) AND c.connec_id = rec_connec.connec_id
        AND a.arc_id IN (rec_aux1.arc_id, rec_aux2.arc_id) LIMIT 1;
        UPDATE PARENT_SCHEMA.connec SET arc_id = v_arc_closest WHERE arc_id = v_arc_id AND connec_id = rec_connec.connec_id;
        v_arc_closest = null;
    END LOOP;

    -- reconnec operative gully without link but with arc_id
    IF v_project_type='UD' THEN
        FOR rec_gully IN SELECT gully_id FROM PARENT_SCHEMA.gully WHERE arc_id=v_arc_id AND state = 1 AND pjoint_type='ARC'
        AND gully_id NOT IN (SELECT DISTINCT feature_id FROM PARENT_SCHEMA.link WHERE exit_id=v_arc_id)
        LOOP
            SELECT a.arc_id INTO v_arc_closest FROM PARENT_SCHEMA.gully g, PARENT_SCHEMA.ve_arc a WHERE st_dwithin(a.the_geom, g.the_geom, 100) AND g.gully_id = rec_gully.gully_id
            AND a.arc_id IN (rec_aux1.arc_id, rec_aux2.arc_id) LIMIT 1;
            UPDATE PARENT_SCHEMA.gully SET arc_id = v_arc_closest WHERE arc_id = v_arc_id AND gully_id = rec_gully.gully_id;
            v_arc_closest = null;
        END LOOP;
    END IF;

    --set arc to obsolete or delete it
    IF v_set_arc_obsolete IS TRUE THEN
        UPDATE PARENT_SCHEMA.arc SET state=0, state_type=v_obsoletetype  WHERE arc_id=v_arc_id;
    ELSE
        DELETE FROM PARENT_SCHEMA.arc WHERE arc_id=v_arc_id;
    END IF;
    
    -- set values of node
    UPDATE PARENT_SCHEMA.node SET sector_id = rec_aux1.sector_id, omzone_id = rec_aux1.omzone_id WHERE node_id = v_node_id;

    IF v_project_type ='WS' THEN
        UPDATE PARENT_SCHEMA.node SET presszone_id = rec_aux1.presszone_id, dqa_id = rec_aux1.dqa_id, dma_id = rec_aux1.dma_id,
        minsector_id = rec_aux1.minsector_id WHERE node_id = v_node_id;
    ELSIF v_project_type ='UD' THEN
        -- set y1/y2 to null for those values related to new node
        UPDATE PARENT_SCHEMA.arc SET y2=null, custom_y2=null WHERE arc_id = rec_aux1.arc_id;
        UPDATE PARENT_SCHEMA.arc SET y1=null, custom_y1=null WHERE arc_id = rec_aux2.arc_id;
    END IF;

    v_status := 'Accepted';
    v_message := 'Arc ' || v_arc_id || ' divided into ' || v_new_arc1_id || ' and ' || v_new_arc2_id;

    -- Return
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN json_build_object(
        'status', v_status, 
        'message', v_message,
        'new_arc1_id', v_new_arc1_id,
        'new_arc2_id', v_new_arc2_id
    );

EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_message = PG_EXCEPTION_CONTEXT;
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN json_build_object('status', 'Failed', 'message', SQLERRM, 'context', v_message);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
