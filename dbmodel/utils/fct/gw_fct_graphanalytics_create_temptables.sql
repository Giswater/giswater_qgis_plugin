/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3330

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_create_temptables(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_create_temptables(p_data json)
RETURNS json AS
$BODY$

/*
SELECT gw_fct_graphanalytics_create_temptables('{"data":{"fct_name":"MINSECTOR"}}');
*/

DECLARE

    v_project_type text;
    v_version TEXT;
    v_fct_name TEXT;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_fct_name = (SELECT (p_data::json->>'data')::json->>'fct_name');

    -- Create temporary tables
    CREATE TEMP TABLE temp_pgr_node (
        pgr_node_id INT NOT NULL,
        node_id VARCHAR(16),
        zone_id INTEGER DEFAULT 0,
        modif BOOL DEFAULT FALSE,  -- True if nodes have to be disconnected - closed valves, starts of mapzones
        graph_delimiter VARCHAR(30),
        CONSTRAINT temp_pgr_node_pkey PRIMARY KEY (pgr_node_id)
    );
    CREATE INDEX temp_pgr_node_node_id ON temp_pgr_node USING btree (node_id);
    GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_node TO role_basic;


    CREATE TEMP TABLE temp_pgr_arc (
        pgr_arc_id INT NOT NULL,
        arc_id VARCHAR(16),
        pgr_node_1 INT,
        pgr_node_2 INT,
        node_1 VARCHAR(16),
        node_2 VARCHAR(16),
        zone_id INTEGER DEFAULT 0,
        graph_delimiter VARCHAR(30),
        modif BOOL DEFAULT FALSE,  -- True if arcs have to be disconnected - arcs that connect with nodes at the start of mapzones and are not to_arc
        cost INT DEFAULT 1,
        reverse_cost INT DEFAULT 1,
        CONSTRAINT temp_pgr_arc_pkey PRIMARY KEY (pgr_arc_id)
    );
    CREATE INDEX temp_pgr_arc_pgr_arc_id ON temp_pgr_arc USING btree (pgr_arc_id);
    CREATE INDEX temp_pgr_arc_pgr_node1 ON temp_pgr_arc USING btree (pgr_node_1);
    CREATE INDEX temp_pgr_arc_pgr_node2 ON temp_pgr_arc USING btree (pgr_node_2);
    CREATE INDEX temp_pgr_arc_node1 ON temp_pgr_arc USING btree (node_1);
    CREATE INDEX temp_pgr_arc_node2 ON temp_pgr_arc USING btree (node_2);
    GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_arc TO role_basic;


    CREATE TEMP TABLE temp_pgr_connec (
        connec_id varchar(16),
        arc_id varchar(16),
        zone_id INTEGER DEFAULT 0,
        minsector_id INTEGER DEFAULT 0,
        CONSTRAINT temp_pgr_connec_pkey PRIMARY KEY (connec_id)
    );
    CREATE INDEX temp_pgr_connec_connec_id ON temp_pgr_connec USING btree (connec_id);
    CREATE INDEX temp_pgr_connec_arc_id ON temp_pgr_connec USING btree (arc_id);


    CREATE TEMP TABLE temp_pgr_link (
        link_id varchar(16),
        feature_id varchar(16),
        feature_type varchar(16),
        zone_id INTEGER DEFAULT 0,
        minsector_id INTEGER DEFAULT 0,
        CONSTRAINT temp_pgr_link_pkey PRIMARY KEY (link_id)
    );
    CREATE INDEX temp_pgr_link_link_id ON temp_pgr_link USING btree (link_id);
    CREATE INDEX temp_pgr_link_feature_id ON temp_pgr_link USING btree (feature_id);


    -- Create temporary layers depending on the project type
    IF v_project_type = 'UD' THEN
        CREATE TEMP TABLE temp_pgr_gully (
            gully_id varchar(16),
            arc_id varchar(16),
            zone_id INTEGER DEFAULT 0,
            CONSTRAINT temp_pgr_gully_pkey PRIMARY KEY (gully_id)
        );
        CREATE INDEX temp_pgr_gully_gully_id ON temp_pgr_gully USING btree (gully_id);
        CREATE INDEX temp_pgr_gully_arc_id ON temp_pgr_gully USING btree (arc_id);
    END IF;

    -- Create other additional temporary tables
	CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

    -- For specific functions
    IF v_fct_name = 'MINSECTOR' THEN
        CREATE TEMP TABLE temp_pgr_connectedcomponents (
            seq INT8 NOT NULL,
            component INT8 NULL,
            node INT8 NULL,
            CONSTRAINT temp_pgr_connectedcomponents_pkey PRIMARY KEY (seq)
        );
        CREATE INDEX temp_pgr_connectedcomponents_component ON temp_pgr_connectedcomponents USING btree (component);
        CREATE INDEX temp_pgr_connectedcomponents_node ON temp_pgr_connectedcomponents USING btree (node);
        GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_connectedcomponents TO role_basic;


        CREATE TEMP TABLE temp_pgr_minsector (
            pgr_arc_id INT NOT NULL,
            node_id VARCHAR(16),
            minsector_id_1 INTEGER NOT NULL,
            minsector_id_2 INTEGER NOT NULL,
            graph_delimiter VARCHAR(30),
            cost INT DEFAULT 1,
            reverse_cost INT DEFAULT 1,
            CONSTRAINT temp_pgr_minsector_pkey PRIMARY KEY (pgr_arc_id)
        );
        CREATE INDEX temp_pgr_minsector_node_id ON temp_pgr_minsector USING btree (node_id);
        CREATE INDEX temp_pgr_minsector_minsector_id_1 ON temp_pgr_minsector USING btree (minsector_id_1);
        CREATE INDEX temp_pgr_minsector_minsector_id_2 ON temp_pgr_minsector USING btree (minsector_id_2);
        GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_minsector TO role_basic;

 	    CREATE TEMP TABLE temp_minsector (LIKE SCHEMA_NAME.minsector INCLUDING ALL);
    ELSE
        CREATE TEMP TABLE temp_pgr_drivingdistance (
            seq INT8 NOT NULL,
            "depth" INT8 NULL,
            start_vid INT8 NULL,
            pred INT8 NULL,
            node INT8 NULL,
            edge INT8 NULL,
            "cost" FLOAT8 NULL,
            agg_cost FLOAT8 NULL,
            CONSTRAINT temp_pgr_drivingdistance_pkey PRIMARY KEY (seq)
        );
        CREATE INDEX temp_pgr_drivingdistance_start_vid ON temp_pgr_drivingdistance USING btree (start_vid);
        CREATE INDEX temp_pgr_drivingdistance_node ON temp_pgr_drivingdistance USING btree (node);
        CREATE INDEX temp_pgr_drivingdistance_edge ON temp_pgr_drivingdistance USING btree (edge);
        GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_drivingdistance TO role_basic;
    END IF;

    RETURN jsonb_build_object(
        'status', 'Accepted',
        'message', jsonb_build_object(
            'level', 1,
            'text', 'The temporary tables have been created successfully'
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

    EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'status', 'Failed',
        'message', jsonb_build_object(
            'level', 3,
            'text', 'An error occurred while creating temporary tables: ' || SQLERRM
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100

