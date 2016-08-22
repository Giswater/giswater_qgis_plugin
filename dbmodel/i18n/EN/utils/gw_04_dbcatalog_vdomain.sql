/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO db_cat_table VALUES (10000, 'version', 'ud&se&ws', 'utils', NULL, 'Table to control de version of the software used on the project.');
INSERT INTO db_cat_table VALUES (10020, 'config', 'ud&se&ws', 'utils', NULL, 'Table to define diferent configuration parameters related to the GIS USER interface.');
INSERT INTO db_cat_table VALUES (10030, 'config_csv_import', 'ud&se&ws', 'utils', NULL, 'Table to define the tables enabled for csv import tool');
INSERT INTO db_cat_table VALUES (10040, 'db_cat_table', 'ud&se&ws', 'utils', NULL, 'Table with the information of tables of the project');
INSERT INTO db_cat_table VALUES (10050, 'db_cat_view', 'ud&se&ws', 'utils', NULL, 'Table with the information of views of the project');
INSERT INTO db_cat_table VALUES (10060, 'db_cat_columns', 'ud&se&ws', 'utils', NULL, 'Table with the information of columns of the project');
INSERT INTO db_cat_table VALUES (10070, 'db_cat_clientlayer', 'ud&se&ws', 'utils', NULL, 'Table with the information of GIS layers of the project');
INSERT INTO db_cat_table VALUES (10080, 'anl_node_orphan', 'ud&se&ws', 'utils', NULL, 'Table with the results of the topology process of node orphan function');
INSERT INTO db_cat_table VALUES (10090, 'anl_node_sink', 'ud&se&ws', 'utils', NULL, 'Table with the results of the topology process of node sink function');
INSERT INTO db_cat_table VALUES (10100, 'anl_node_duplicated', 'ud&se&ws', 'utils', NULL, 'Table with the results of the topology process of node duplicated function');
INSERT INTO db_cat_table VALUES (10110, 'anl_arc_same_startend', 'ud&se&ws', 'utils', NULL, 'Table with the results of the topology process of arcs with same node initial and end function');
INSERT INTO db_cat_table VALUES (10120, 'anl_arc_nonode_startend', 'ud&se&ws', 'utils', NULL, 'Table with the results of the topology process of arcs with no nodes on start and/or end function');
INSERT INTO db_cat_table VALUES (10130, 'audit_cat_error', 'ud&se&ws', 'utils', NULL, 'Catalog of errors');
INSERT INTO db_cat_table VALUES (10140, 'audit_cat_function', 'ud&se&ws', 'utils', NULL, 'Catalog of functions');
INSERT INTO db_cat_table VALUES (10150, 'audit_function_actions', 'ud&se&ws', 'utils', NULL, 'Table to store information about traceability of user actions with functions');




INSERT INTO db_cat_columns VALUES (30010, 10, 'id', 'int4', 'ID of version. Primary key.');
INSERT INTO db_cat_columns VALUES (30020, 10, 'giswater', 'varchar(16)', 'Identifies the version of giswater with the project was created');
INSERT INTO db_cat_columns VALUES (30030, 10, 'wsoftware', 'varchar(16)', 'Identifies the water software compatible with the project');
INSERT INTO db_cat_columns VALUES (30040, 10, 'postgres', 'varchar(512)', 'Identifies the version of PostgreSQL where the project was created');
INSERT INTO db_cat_columns VALUES (30050, 10, 'postgis', 'varchar(512)', 'Identifies the version of Postgis where the project was created');
INSERT INTO db_cat_columns VALUES (30060, 10, 'text', 'timestamp(6)', 'Identifies the date when the project was created');
INSERT INTO db_cat_columns VALUES (30070, 20, 'id', 'varchar(18)', 'Autonumeric field to store unique values for each row (primary key)');
INSERT INTO db_cat_columns VALUES (30080, 20, 'node_proximity', 'double precision', 'Configuration parameter of node proximity related to trg_node_proximity function trigger');
INSERT INTO db_cat_columns VALUES (30090, 20, 'arc_searchnodes', 'double precision', 'Configuration parameter of arc searching start and end nodes related to trg_arc_searchnodes function trigger');
INSERT INTO db_cat_columns VALUES (30100, 20, 'node2arc', 'double precision', 'Configuration parameter of disconected nodes about it''s proximity to arcs related to fct_node2arc function');
INSERT INTO db_cat_columns VALUES (30110, 20, 'connec_proximity', 'double precision', 'Configuration parameter of node proximity related to trg_connec_proximity function trigger');
INSERT INTO db_cat_columns VALUES (30120, 20, 'arc_toporepair', 'double precision', 'Configuration parameter of arc repair related to fct_arc_toporepair function');
INSERT INTO db_cat_columns VALUES (30130, 20, 'nodeinsert_arcendpoint', 'boolean', 'Configuration parameter of automatic node insert when endnode does not exist related to trg_arc_searchnodes function trigger');
INSERT INTO db_cat_columns VALUES (30140, 20, 'nodeinsert_nodetype_vdefault', 'Varchar (300)', 'Automatic value of node_type when automatic node insert is true');
INSERT INTO db_cat_columns VALUES (30150, 20, 'orphannode_delete', 'boolean', 'Configuration parameter of automatic delete node when arc is deleted related to trg_orphannode_delete fuction trigger');
INSERT INTO db_cat_columns VALUES (30160, 20, 'vnode_update_tolerance', 'double precision', 'Configuration parameter of defining node tolerance.');
INSERT INTO db_cat_columns VALUES (30170, 20, 'nodetype_change_enabled', 'boolean', 'Enable change node type option.');
INSERT INTO db_cat_columns VALUES (30180, 20, 'same_node_init_end_control', 'boolean', 'Field to put enable (true) or dissabled (false) the rules of topology to prevent arcs with same init node and end node.');
INSERT INTO db_cat_columns VALUES (30190, 20, 'node_proximity_control', 'boolean', 'Field to put enable (true) or dissabled (false) the rules of topology to prevent nodes closet to other nodes');
INSERT INTO db_cat_columns VALUES (30200, 20, 'connec_proximity_control', 'boolean', 'Field to put enable (true) or dissabled (false) the rules of topology to prevent connec closet to other connec');
INSERT INTO db_cat_columns VALUES (30210, 20, 'node_duplicated_tolerance', 'float', 'Tolerace for function of node duplicated indentification');
INSERT INTO db_cat_columns VALUES (30280, 40, 'name', 'text', 'Name of the table');
INSERT INTO db_cat_columns VALUES (30310, 40, 'db_cat_clientlayer_id', 'int4', 'Name of the GIS layer (if exists)');
INSERT INTO db_cat_columns VALUES (30330, 50, 'id', 'int4', 'Autonumeric field to store unique values for each row (primary key)');
INSERT INTO db_cat_columns VALUES (30340, 50, 'name', 'text', 'Name of the view');
INSERT INTO db_cat_columns VALUES (30350, 50, 'project_type', 'text', 'Project type of the table (WS, UD or SE).');
INSERT INTO db_cat_columns VALUES (30360, 50, 'context', 'text', 'Context where this view is showed');
INSERT INTO db_cat_columns VALUES (30370, 50, 'db_cat_clientlayer_id', 'int4', 'Name of the GIS layer (if exists)');
INSERT INTO db_cat_columns VALUES (30380, 50, 'description', 'text', 'description of the table');
INSERT INTO db_cat_columns VALUES (30390, 60, 'id', 'int4', 'Autonumeric field to store unique values for each row (primary key)');
INSERT INTO db_cat_columns VALUES (30400, 60, 'name', 'text', 'Name of the column');
INSERT INTO db_cat_columns VALUES (30410, 60, 'db_cat_table_id', 'int4', 'Type of column');
INSERT INTO db_cat_columns VALUES (30420, 60, 'description', 'text', 'description of the table');
INSERT INTO db_cat_columns VALUES (30430, 70, 'id', 'int4', 'Autonumeric field to store unique values for each row (primary key)');
INSERT INTO db_cat_columns VALUES (30440, 70, 'name', 'text', 'Name of the layer of the GIS project');
INSERT INTO db_cat_columns VALUES (30450, 70, 'group_level_1', 'text', 'Group of the table of contents (ToC) where the layer is located. Level 1 of agrupation');
INSERT INTO db_cat_columns VALUES (30460, 70, 'group_level_2', 'text', 'Group of the table of contents (ToC) where the layer is located. Level 2 of agrupation');
INSERT INTO db_cat_columns VALUES (30470, 70, 'group_level_3', 'text', 'Group of the table of contents (ToC) where the layer is located. Level 3 of agrupation');
INSERT INTO db_cat_columns VALUES (30480, 80, 'node_id', 'Varchar(16)', 'Node identifier');
INSERT INTO db_cat_columns VALUES (30490, 80, 'node_type', 'Varchar(300)', 'Type of the node');
INSERT INTO db_cat_columns VALUES (30500, 80, 'the_geom', 'public.geometry', 'Geometry of node');
INSERT INTO db_cat_columns VALUES (30510, 90, 'node_id', 'Varchar(16)', 'Node identifier');
INSERT INTO db_cat_columns VALUES (30520, 90, 'num_arcs', 'integer', 'Number of arcs joining the node');
INSERT INTO db_cat_columns VALUES (30530, 90, 'the_geom', 'public.geometry', 'Geometry of node');
INSERT INTO db_cat_columns VALUES (30540, 100, 'node_id', 'Varchar(16)', 'Node identifier');
INSERT INTO db_cat_columns VALUES (30550, 100, 'node_conserv', 'Varchar(16)', 'Node identifier of the duplicated node');
INSERT INTO db_cat_columns VALUES (30560, 100, 'the_geom', 'public.geometry', 'Geometry of node');
INSERT INTO db_cat_columns VALUES (30600, 110, 'arc_id', NULL, 'Arc identifier');
INSERT INTO db_cat_columns VALUES (30220, 20, 'connec_duplicated_tolerance', 'float', 'Tolerace for function of connec duplicated indentification');
INSERT INTO db_cat_columns VALUES (30230, 20, 'audit_function_control', 'boolean', 'Field to put enable (true) or dissabled (false) the audit function control');
INSERT INTO db_cat_columns VALUES (30240, 20, 'arc_searchnodes_control', 'boolean', 'Field to put enable (true) or dissabled (false) the rules of topology to prevent arcs without nodes at init or end position');
INSERT INTO db_cat_columns VALUES (30250, 30, 'table_name', 'Varchar (50)', 'Name of table to insert csv data');
INSERT INTO db_cat_columns VALUES (30260, 30, 'gis_client_layer_name', 'Varchar (50)', 'Alias of this table on the GIS project');
INSERT INTO db_cat_columns VALUES (30270, 40, 'id', 'int4', 'Autonumeric field to store unique values for each row (primary key)');
INSERT INTO db_cat_columns VALUES (30290, 40, 'project_type', 'text', 'Project type of the table (WS, UD or SE).');
INSERT INTO db_cat_columns VALUES (30300, 40, 'context', 'text', 'Context where this table is showed');
INSERT INTO db_cat_columns VALUES (30320, 40, 'description', 'text', 'description of the table');
INSERT INTO db_cat_columns VALUES (30610, 110, 'the_geom', 'public.geometry', 'Geometry of arc');
INSERT INTO db_cat_columns VALUES (30620, 120, 'arc_id', NULL, 'Arc identifier');
INSERT INTO db_cat_columns VALUES (30630, 120, 'the_geom', 'public.geometry', 'Geometry of arc');
INSERT INTO db_cat_columns VALUES (30640, 130, 'id', 'int', 'Identifier of the error');
INSERT INTO db_cat_columns VALUES (30650, 130, 'error_message', 'text', 'Message of the error');
INSERT INTO db_cat_columns VALUES (30660, 130, 'hint_message', 'text', 'Hint message');
INSERT INTO db_cat_columns VALUES (30670, 130, 'log_level', 'int2', 'Log level of the error');
INSERT INTO db_cat_columns VALUES (30680, 130, 'show_user', 'boolean', 'Field to define to show (or not) to the user this message');
INSERT INTO db_cat_columns VALUES (30690, 130, 'context', 'text', 'Context of the message');
INSERT INTO db_cat_columns VALUES (30700, 140, 'id', 'int4', 'Identifier of the function');
INSERT INTO db_cat_columns VALUES (30710, 140, 'name', 'text', 'Name of the function');
INSERT INTO db_cat_columns VALUES (30720, 140, 'function_type', 'text', 'Type of the function (trigger function or function)');
INSERT INTO db_cat_columns VALUES (30730, 140, 'context', 'text', 'Context of the function');
INSERT INTO db_cat_columns VALUES (30740, 140, 'input_params', 'json', 'Input parameters of the function');
INSERT INTO db_cat_columns VALUES (30750, 140, 'return_type', 'text', 'Type of return of the function');
INSERT INTO db_cat_columns VALUES (30760, 150, 'id', 'bigserial', 'Autonumeric field to store unique values for each row (primary key)');
INSERT INTO db_cat_columns VALUES (30770, 150, 'tstamp', 'timestamp with time zone', 'Timestamp');
INSERT INTO db_cat_columns VALUES (30780, 150, 'audit_cat_error_id', 'int', 'Identifier of the error');
INSERT INTO db_cat_columns VALUES (30790, 150, 'audit_cat_function_id', 'int4', 'Identifier of the function');
INSERT INTO db_cat_columns VALUES (30800, 150, 'query', 'text', 'String with the full query realized');
INSERT INTO db_cat_columns VALUES (30810, 150, 'user_name', 'text', 'Name of the user');
INSERT INTO db_cat_columns VALUES (30820, 150, 'addr', 'inet', 'IP address of client that issued query. Null for unix domain socket');
INSERT INTO db_cat_columns VALUES (30830, 150, 'debug_info', 'text', 'Additional information to debug');


--
-- TOC entry 11797 (class 0 OID 90954)
-- Dependencies: 2634
-- Data for Name: db_cat_table; Type: TABLE DATA; Schema: test_ud_0815; Owner: postgres
--