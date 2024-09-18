/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_temptables()
 RETURNS text
 LANGUAGE plpgsql
AS $function$

declare
v_return_text text;

begin
	
	SET search_path = "SCHEMA_NAME", public;

	CREATE TEMP TABLE temp_pgr_node (
		pgr_node_id int not null,
		node_id varchar(16),
		zone_id integer default 0, -- per defecte és Undefined; és text perque el camp "id" per presszone és text, pero XTR ja ha canviat integer; 
		modif bool default false, -- true si s'han de desconectar els nodes - valvules tancades, inicis de mapzones
		graph_delimiter varchar(30),
		CONSTRAINT temp_pgr_node_pkey PRIMARY KEY (pgr_node_id)
	);
	CREATE INDEX temp_pgr_node_node_id ON temp_pgr_node USING btree (node_id);
	GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_node TO role_basic;
	
	CREATE TEMP TABLE temp_pgr_arc (
		pgr_arc_id int not null,
		arc_id varchar(16),
		pgr_node_1 int,
		pgr_node_2 int,
		node_1 varchar(16),
		node_2 varchar(16),
		zone_id integer default 0, -- per defecte és Undefined; és text perque el camp "id" per presszone és text, pero XTR ja ha canviat integer; 
		graph_delimiter varchar(30),
		modif bool default false, -- true si s'han de desconectar els arcs - arcs que connecten amb nodes inicis de mapzone i no són to_arc
		cost int default 1,
		reverse_cost int default 1,
		CONSTRAINT temp_pgr_arc_pkey PRIMARY KEY (pgr_arc_id)
	);
	CREATE INDEX temp_pgr_arc_pgr_arc_id ON temp_pgr_arc USING btree (pgr_arc_id);
	CREATE INDEX temp_pgr_arc_pgr_node1 ON temp_pgr_arc USING btree (pgr_node_1);
	CREATE INDEX temp_pgr_arc_pgr_node2 ON temp_pgr_arc USING btree (pgr_node_2);
	CREATE INDEX temp_pgr_arc_node1 ON temp_pgr_arc USING btree (node_1);
	CREATE INDEX temp_pgr_arc_node2 ON temp_pgr_arc USING btree (node_2);
	GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_arc TO role_basic;
	
	CREATE TEMP TABLE temp_pgr_minsector (
		pgr_arc_id int not null,
		node_id varchar(16),
		minsector_id_1 integer not null,
		minsector_id_2 integer not null,
		graph_delimiter varchar(30),
		cost int default 1,
		reverse_cost int default 1,
		CONSTRAINT temp_pgr_minsector_pkey PRIMARY KEY (pgr_arc_id)
	);
	CREATE INDEX temp_pgr_minsector_node_id ON temp_pgr_minsector USING btree (node_id);
	CREATE INDEX temp_pgr_minsector_minsector_id_1 ON temp_pgr_minsector USING btree (minsector_id_1);
	CREATE INDEX temp_pgr_minsector_minsector_id_2 ON temp_pgr_minsector USING btree (minsector_id_2);
	GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_minsector TO role_basic;
	
	CREATE TEMP TABLE temp_pgr_connectedcomponents (
	seq int8 not null,
	component int8 NULL,
	node int8 NULL,
	CONSTRAINT temp_pgr_connectedcomponents_pkey PRIMARY KEY (seq)
	);
	CREATE INDEX temp_pgr_connectedcomponents_component ON temp_pgr_connectedcomponents USING btree (component);
	CREATE INDEX temp_pgr_connectedcomponents_node ON temp_pgr_connectedcomponents USING btree (node);
	GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_connectedcomponents TO role_basic;
	
	CREATE TEMP TABLE temp_pgr_drivingdistance (
	seq int8 not NULL,
	"depth" int8 NULL,
	start_vid int8 NULL,
	pred int8 NULL,
	node int8 NULL,
	edge int8 NULL,
	"cost" float8 NULL,
	agg_cost float8 NULL,
	CONSTRAINT temp_pgr_drivingdistance_pkey PRIMARY KEY (seq)
	);
	CREATE INDEX temp_pgr_drivingdistance_start_vid ON temp_pgr_drivingdistance USING btree (start_vid);
	CREATE INDEX temp_pgr_drivingdistance_node ON temp_pgr_drivingdistance USING btree (node);
	CREATE INDEX temp_pgr_drivingdistance_edge ON temp_pgr_drivingdistance USING btree (edge);
	GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_drivingdistance TO role_basic;
	
	v_return_text = '{"Status":"OK"}';

return v_return_text;
end;
$function$
;