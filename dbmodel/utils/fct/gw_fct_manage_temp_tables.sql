/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_manage_temp_tables(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_manage_temp_tables(p_data json)
RETURNS json AS
$BODY$

/*

 * PARAMETERS OPTIONS:
 * * fid: integer (mandatory)
 * * project_type: string -> 'WS' | 'UD' (mandatory)
 * * action: string -> 'CREATE' | 'DROP' (mandatory)
 * * verifiedExceptions: boolean (optional)
 * * group: string -> 'LOG' | 'ANL' | 'MAPZONES' | 'EPA' | 'OMCHECK' | 'ADMIN' | 'PLANCHECK' | 'EPAMAIN' | 'CHECKPROJECT' | 'GRAPHANALYTICSCHECK', 'USERCHECK' (mandatory)
 * * subGroup: string[] -> ['ALL' | 'DMA' | 'DQA' | 'PRESSZONE' | 'SECTOR' | 'DRAINZONE'] (optional)

 * EXAMPLE CALLS:
 * * SELECT SCHEMA_NAME.gw_fct_manage_temp_tables('{"data":{"parameters":{"fid":XXX, "project_type":"UD", "action":"CREATE", "group":"LOG"}}}');
 * * SELECT SCHEMA_NAME.gw_fct_manage_temp_tables('{"data":{"parameters":{"fid":XXX, "project_type":"UD", "action":"DROP", "group":"ADMIN"}}}');
 * GROUPS THAT REQUIERE A SUBGROUP:
 * * SELECT SCHEMA_NAME.gw_fct_manage_temp_tables('{"data":{"parameters":{"fid":XXX, "project_type":"UD", "action":"CREATE", "group":"MAPZONES", "subGroup":"DMA"}}}');
 * * SELECT SCHEMA_NAME.gw_fct_manage_temp_tables('{"data":{"parameters":{"fid":XXX, "project_type":"WS", "action":"CREATE", "group":"MAPZONES", "subGroup":"DQA"}}}');
 * * WITH SUBGROUP 'ALL' (ONLY FOR MAPZONES):
 * * * SELECT SCHEMA_NAME.gw_fct_manage_temp_tables('{"data":{"parameters":{"fid":XXX, "project_type":"WS", "action":"CREATE", "group":"MAPZONES", "subGroup":"ALL"}}}');
 * GROUPS THAT CREATE A GROUP OF TABLES:
 * * SELECT SCHEMA_NAME.gw_fct_manage_temp_tables('{"data":{"parameters":{"fid":XXX, "project_type":"UD", "action":"CREATE", "group":"CHECKPROJECT"}}}');
 * * SELECT SCHEMA_NAME.gw_fct_manage_temp_tables('{"data":{"parameters":{"fid":XXX, "project_type":"UD", "action":"CREATE", "group":"EPAMAIN"}}}');

*/

DECLARE

    v_fid integer;
    v_project_type text;

    v_filter text;

    -- parameters
    v_parameters json;
    v_action text;
    v_verifiedExceptions boolean;
    v_group text;
    v_subGroup text;
    v_exceptionTables text[];

    -- test
    v_group_array text[];
    v_subGroup_array text[];

BEGIN

    -- set search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_parameters := (((p_data ->>'data')::json->>'parameters')::json);
    v_fid := v_parameters->>'fid';
    v_project_type = UPPER(v_parameters->>'project_type');
    v_action = UPPER(v_parameters->>'action');
    v_verifiedExceptions = v_parameters->>'verifiedExceptions';
    v_group = UPPER(v_parameters->>'group');
    v_subGroup = UPPER(v_parameters->>'subGroup');

    -- validate parameters
    IF v_fid IS NULL THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"fid is required"}}')::json;
    END IF;

    IF v_project_type IS NULL THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"project_type is required"}}')::json;
    END IF;

    IF v_action IS NULL THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"action is required"}}')::json;
    END IF;

    IF v_group IS NULL THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"group is required"}}')::json;
    END IF;

    -- validate action
    IF v_action NOT IN ('CREATE', 'DROP') THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"action is invalid"}}')::json;
    END IF;

    -- validate project_type
    IF v_project_type NOT IN ('WS', 'UD') THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"project_type is invalid"}}')::json;
    END IF;

    -- validate group
    IF v_group NOT IN ('LOG', 'ANL', 'MAPZONES', 'EPA', 'OMCHECK', 'ADMIN', 'PLANCHECK', 'EPAMAIN', 'CHECKPROJECT', 'GRAPHANALYTICSCHECK', 'USERCHECK') THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"group is invalid"}}')::json;
    END IF;

    -- validate subGroup for mapzones
    IF v_subGroup IS NOT NULL AND v_group = 'MAPZONES' AND v_subGroup NOT IN ('ALL', 'DMA', 'DQA', 'PRESSZONE', 'SECTOR', 'DRAINZONE', 'SUPPLYZONE', 'DWFZONE', 'OMZONE') THEN
        RETURN ('{"status":"Failed","message":{"level":1, "text":"subGroup is invalid"}}')::json;
    END IF;

    -- test
    IF v_group = 'EPAMAIN' THEN
        v_group_array = ARRAY['LOG', 'ANL', 'MAPZONES', 'EPA', 'OMCHECK', 'ADMIN'];
        IF v_project_type = 'WS' THEN
            v_subGroup_array = ARRAY['DMA', 'DQA', 'PRESSZONE', 'SECTOR', 'SUPPLYZONE', 'OMZONE'];
        ELSIF v_project_type = 'UD' THEN
            v_subGroup_array = ARRAY['DRAINZONE', 'DWFZONE', 'OMZONE'];
        END IF;
    ELSIF v_group = 'GRAPHANALYTICSCHECK' THEN
        v_group_array = ARRAY['LOG', 'ANL', 'MAPZONES', 'OMCHECK'];
        v_subGroup_array = ARRAY['DMA', 'DQA', 'PRESSZONE', 'SECTOR', 'SUPPLYZONE', 'DWFZONE', 'OMZONE'];
    ELSIF v_group = 'USERCHECK' THEN
        v_group_array = ARRAY['LOG', 'ANL'];
    ELSIF v_group = 'CHECKPROJECT' THEN
        v_group_array = ARRAY['LOG', 'ANL'];
    ELSIF v_group = 'PLANCHECK' THEN
        v_group_array = ARRAY['LOG', 'ANL', 'OMCHECK'];
    ELSE
        v_group_array = ARRAY[v_group];
        v_subGroup_array = ARRAY[v_subGroup];
    END IF;

    -- LOGIC FOR THE DIFFERENT ACTIONS
    IF v_action = 'CREATE' THEN
        IF v_verifiedExceptions THEN
            v_filter = ' WHERE (verified IS NULL OR verified IN (0,1))';
        ELSE
            v_filter = ' WHERE state IS NOT NULL ';
        END IF;


        IF 'LOG' = ANY(v_group_array) THEN
            CREATE TEMP TABLE t_audit_check_data (LIKE audit_check_data INCLUDING ALL);
            CREATE TEMP TABLE t_audit_check_project (LIKE audit_check_project INCLUDING ALL);
            CREATE TEMP TABLE t_audit_log_data (LIKE audit_log_data INCLUDING ALL);
        END IF;

        IF 'ANL' = ANY(v_group_array) THEN
            CREATE TEMP TABLE t_anl_arc (LIKE anl_arc INCLUDING ALL);
            CREATE TEMP TABLE t_anl_node (LIKE anl_node INCLUDING ALL);
            CREATE TEMP TABLE t_anl_connec (LIKE anl_connec INCLUDING ALL);
            CREATE TEMP TABLE t_anl_polygon (LIKE anl_polygon INCLUDING ALL);
        END IF;

        IF 'MAPZONES' = ANY(v_group_array) THEN

            IF 'SECTOR' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array) THEN
                CREATE TEMP TABLE t_sector AS SELECT * FROM v_edit_sector;
            END IF;

            IF 'OMZONE' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array) THEN
                CREATE TEMP TABLE t_omzone AS SELECT * FROM v_edit_omzone;
            END IF;

            IF v_project_type = 'WS' THEN
            	IF 'PRESSZONE' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array) THEN
                    CREATE TEMP TABLE t_presszone AS SELECT * FROM v_edit_presszone;
            	END IF;

	            IF 'DQA' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array)THEN
	                CREATE TEMP TABLE t_dqa AS SELECT * FROM v_edit_dqa;
	            END IF;

                IF 'DMA' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array) THEN
                    CREATE TEMP TABLE t_dma AS SELECT * FROM v_edit_dma;
                END IF;

                IF 'SUPPLYZONE' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array) THEN
                    CREATE TEMP TABLE t_supplyzone AS SELECT * FROM v_edit_supplyzone;
                END IF;

            ELSIF v_project_type = 'UD' THEN
                IF 'DRAINZONE' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array) THEN
                    CREATE TEMP TABLE t_drainzone AS SELECT * FROM v_edit_drainzone;
                END IF;

                IF 'DWFZONE' = ANY(v_subGroup_array) OR 'ALL' = ANY(v_subGroup_array) THEN
                    CREATE TEMP TABLE t_dwfzone AS SELECT * FROM v_edit_dwfzone;
                END IF;
            END IF;
        END IF;

        IF 'EPA' = ANY(v_group_array) THEN
            v_filter = concat(v_filter, ' AND sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user = current_user)');

            IF v_project_type = 'WS' THEN
                CREATE TEMP TABLE IF NOT EXISTS temp_vnode(
                    id serial NOT NULL,
                    l1 integer,
                    v1 integer,
                    l2 integer,
                    v2 integer,
                    CONSTRAINT temp_vnode_pkey PRIMARY KEY (id)
                );

                CREATE TEMP TABLE IF NOT EXISTS temp_link(
                    link_id integer NOT NULL,
                    vnode_id integer,
                    vnode_type text,
                    feature_id character varying(16),
                    feature_type character varying(16),
                    exit_id character varying(16),
                    exit_type character varying(16),
                    state smallint,
                    expl_id integer,
                    sector_id integer,
                    dma_id integer,
                    supplyzone_id integer,
                    omzone_id integer,
                    exit_topelev double precision,
                    exit_elev double precision,
                    the_geom geometry(LineString,SRID_VALUE),
                    the_geom_endpoint geometry(Point,SRID_VALUE),
                    flag boolean,
                    CONSTRAINT temp_link_pkey PRIMARY KEY (link_id)
                );

                CREATE TEMP TABLE IF NOT EXISTS temp_link_x_arc(
                    link_id integer NOT NULL,
                    vnode_id integer,
                    arc_id character varying(16),
                    feature_type character varying(16),
                    feature_id character varying(16),
                    node_1 character varying(16),
                    node_2 character varying(16),
                    vnode_distfromnode1 numeric(12,3),
                    vnode_distfromnode2 numeric(12,3),
                    exit_topelev double precision,
                    exit_ymax numeric(12,3),
                    exit_elev numeric(12,3),
                    CONSTRAINT temp_link_x_arc_pkey PRIMARY KEY (link_id)
                );

                CREATE TEMP TABLE IF NOT EXISTS temp_t_demand (LIKE temp_demand INCLUDING ALL);


                CREATE TEMP TABLE IF NOT EXISTS temp_t_pgr_go2epa_node (LIKE temp_node INCLUDING ALL);

                CREATE TEMP TABLE IF NOT EXISTS t_rpt_inp_pattern_value (LIKE rpt_inp_pattern_value INCLUDING ALL);

            ELSIF v_project_type = 'UD' THEN
                CREATE TEMP TABLE IF NOT EXISTS temp_t_arc_flowregulator (LIKE temp_arc_flowregulator INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS temp_t_lid_usage (LIKE temp_lid_usage INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS temp_t_node_other (LIKE temp_node_other INCLUDING ALL);

                CREATE TEMP TABLE IF NOT EXISTS temp_t_gully (LIKE temp_gully INCLUDING ALL);

                CREATE TEMP TABLE IF NOT EXISTS t_rpt_inp_raingage (LIKE rpt_inp_raingage INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS t_rpt_inp_node (LIKE rpt_inp_node INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS t_rpt_inp_arc (LIKE rpt_inp_arc INCLUDING ALL);
            END IF;

            CREATE TEMP TABLE IF NOT EXISTS temp_t_pgr_go2epa_arc (LIKE temp_arc INCLUDING ALL);

            CREATE TEMP TABLE IF NOT EXISTS t_rpt_cat_result (LIKE rpt_cat_result INCLUDING ALL);

            CREATE TEMP TABLE IF NOT EXISTS temp_t_csv (LIKE temp_csv INCLUDING ALL);
            CREATE TEMP TABLE IF NOT EXISTS temp_t_table (LIKE temp_table INCLUDING ALL);
            CREATE TEMP TABLE IF NOT EXISTS temp_t_node (LIKE temp_node INCLUDING ALL);
            CREATE TEMP TABLE IF NOT EXISTS temp_t_arc (LIKE temp_arc INCLUDING ALL);
			CREATE TEMP TABLE IF NOT EXISTS temp_t_link (LIKE link INCLUDING ALL);
            CREATE TEMP TABLE IF NOT EXISTS temp_t_element (LIKE element INCLUDING ALL);
            CREATE TEMP TABLE IF NOT EXISTS temp_t_anlgraph (LIKE temp_anlgraph INCLUDING ALL);
            CREATE TEMP TABLE IF NOT EXISTS temp_t_go2epa (LIKE temp_go2epa INCLUDING ALL);

            EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_pump AS SELECT * FROM v_edit_inp_pump'||v_filter;

            IF v_project_type = 'WS' THEN
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_pipe AS SELECT * FROM v_edit_inp_pipe'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_valve AS SELECT * FROM v_edit_inp_valve'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_junction AS SELECT * FROM v_edit_inp_junction'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_reservoir AS SELECT * FROM v_edit_inp_reservoir'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_tank AS SELECT * FROM v_edit_inp_tank'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_inlet AS SELECT * FROM v_edit_inp_inlet'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_virtualvalve AS SELECT * FROM v_edit_inp_virtualvalve'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_virtualpump AS SELECT * FROM v_edit_inp_virtualpump'||v_filter;
		    ELSIF v_project_type  = 'UD' THEN
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_conduit AS SELECT * FROM v_edit_inp_conduit'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_outlet AS SELECT * FROM v_edit_inp_outlet'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_orifice AS SELECT * FROM v_edit_inp_orifice'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_weir AS SELECT * FROM v_edit_inp_weir'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_virtual AS SELECT * FROM v_edit_inp_virtual'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_storage AS SELECT * FROM v_edit_inp_storage'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_junction AS SELECT * FROM v_edit_inp_junction'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_outfall AS SELECT * FROM v_edit_inp_outfall'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_divider AS SELECT * FROM v_edit_inp_divider'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_netgully AS SELECT * FROM v_edit_inp_netgully'||v_filter;
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_gully AS SELECT * FROM v_edit_inp_gully'||v_filter;
                -- note: don't need filter for these temporal tables
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_subcatchment AS SELECT * FROM v_edit_inp_subcatchment';
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_inp_subc2outlet AS SELECT * FROM v_edit_inp_subc2outlet';
			    EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_raingage AS SELECT * FROM v_edit_raingage';
		    END IF;
        END IF;

        IF 'OMCHECK' = ANY(v_group_array) THEN
            EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_arc AS SELECT * FROM v_edit_arc'||v_filter;
            EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_node AS SELECT * FROM v_edit_node'||v_filter;
            EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_connec AS SELECT * FROM v_edit_connec'||v_filter;
            EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_element AS SELECT * FROM element'||v_filter;
            EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_link AS SELECT * FROM v_edit_link'; -- TODO: add filter

            IF v_project_type = 'UD' THEN
                EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t_gully AS SELECT * FROM v_edit_gully'||v_filter;
            END IF;
        END IF;
        -- return message:: 'Log tables created' or 'Anl tables created' ...
        RETURN '{"status":"Accepted", "message":"'||UPPER(LEFT(v_group,1))||LOWER(SUBSTRING(v_group,2))||' tables created"}';

	ELSIF v_action = 'DROP' THEN
        DROP TABLE IF EXISTS t_audit_check_data;
        DROP TABLE IF EXISTS t_audit_check_project;
        DROP TABLE IF EXISTS t_audit_log_data;

        DROP TABLE IF EXISTS t_anl_node;
        DROP TABLE IF EXISTS t_anl_arc;
        DROP TABLE IF EXISTS t_anl_connec;
        DROP TABLE IF EXISTS t_anl_polygon;

        DROP TABLE IF EXISTS t_dma;
        DROP TABLE IF EXISTS t_dqa;
        DROP TABLE IF EXISTS t_presszone;
        DROP TABLE IF EXISTS t_sector;
        DROP TABLE IF EXISTS t_supplyzone;
        DROP TABLE IF EXISTS t_dwfzone;
        DROP TABLE IF EXISTS t_omzone;
        DROP TABLE IF EXISTS t_drainzone;

        DROP TABLE IF EXISTS temp_vnode;
        DROP TABLE IF EXISTS temp_link;
        DROP TABLE IF EXISTS temp_link_x_arc;
        DROP TABLE IF EXISTS temp_t_csv;
        DROP TABLE IF EXISTS temp_t_table;
        DROP TABLE IF EXISTS temp_t_node;
        DROP TABLE IF EXISTS temp_t_arc;
        DROP TABLE IF EXISTS temp_t_link;
        DROP TABLE IF EXISTS temp_t_element;
        DROP TABLE IF EXISTS temp_t_gully;
        DROP TABLE IF EXISTS temp_t_demand;
        DROP TABLE IF EXISTS temp_t_anlgraph;
        DROP TABLE IF EXISTS temp_t_go2epa;
        DROP TABLE IF EXISTS temp_t_pgr_go2epa_arc;
        DROP TABLE IF EXISTS temp_t_pgr_go2epa_node;
        DROP TABLE IF EXISTS temp_t_arc_flowregulator;
        DROP TABLE IF EXISTS temp_t_lid_usage;
        DROP TABLE IF EXISTS temp_t_node_other;

        DROP TABLE IF EXISTS t_rpt_inp_pattern_value;
        DROP TABLE IF EXISTS t_rpt_inp_raingage;
        DROP TABLE IF EXISTS t_rpt_inp_node;
        DROP TABLE IF EXISTS t_rpt_inp_arc;
        DROP TABLE IF EXISTS t_rpt_cat_result;

        DROP TABLE IF EXISTS t_inp_pump;
        DROP TABLE IF EXISTS t_inp_pipe;
        DROP TABLE IF EXISTS t_inp_valve;
        DROP TABLE IF EXISTS t_inp_junction;
        DROP TABLE IF EXISTS t_inp_reservoir;
        DROP TABLE IF EXISTS t_inp_tank;
        DROP TABLE IF EXISTS t_inp_inlet;
        DROP TABLE IF EXISTS t_inp_virtualvalve;
        DROP TABLE IF EXISTS t_inp_virtualpump;
        DROP TABLE IF EXISTS t_inp_conduit;
        DROP TABLE IF EXISTS t_inp_outlet;
        DROP TABLE IF EXISTS t_inp_orifice;
        DROP TABLE IF EXISTS t_inp_weir;
        DROP TABLE IF EXISTS t_inp_virtual;
        DROP TABLE IF EXISTS t_inp_storage;
        DROP TABLE IF EXISTS t_inp_junction;
        DROP TABLE IF EXISTS t_inp_outfall;
        DROP TABLE IF EXISTS t_inp_divider;
        DROP TABLE IF EXISTS t_inp_netgully;
        DROP TABLE IF EXISTS t_inp_gully;
        DROP TABLE IF EXISTS t_inp_subcatchment;
        DROP TABLE IF EXISTS t_inp_subc2outlet;
        DROP TABLE IF EXISTS t_raingage;

        DROP TABLE IF EXISTS t_arc;
        DROP TABLE IF EXISTS t_node;
        DROP TABLE IF EXISTS t_connec;
        DROP TABLE IF EXISTS t_element;
        DROP TABLE IF EXISTS t_link;
        DROP TABLE IF EXISTS t_gully;

        RETURN '{"status":"Accepted", "message":"'||UPPER(LEFT(v_group,1))||LOWER(SUBSTRING(v_group,2))||' tables deleted"}';
    END IF;

    RETURN ('{"status":"Failed","message":{"level":1, "text":"Something went wrong"}}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;