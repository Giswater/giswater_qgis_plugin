SET SEARCH_PATH="SCHEMA_NAME", plublic;


ALTER TABLE config ADD COLUMN samenode_init_end_control boolean;
ALTER TABLE config ALTER COLUMN samenode_init_end_control SET NOT NULL;

ALTER TABLE config ADD COLUMN node_proximity_control boolean;
ALTER TABLE config ALTER COLUMN node_proximity_control SET NOT NULL;

ALTER TABLE config ADD COLUMN node_proximity_control boolean;
ALTER TABLE config ALTER COLUMN node_proximity_control SET NOT NULL;

ALTER TABLE config ADD COLUMN connec_proximity_control boolean;
ALTER TABLE config ALTER COLUMN connec_proximity_control SET NOT NULL;

ALTER TABLE config ADD COLUMN node_duplicated_tolerance double precision;

ALTER TABLE config ADD COLUMN connec_duplicated_tolerance double precision;

ALTER TABLE config ADD COLUMN audit_function_control boolean;
ALTER TABLE config ALTER COLUMN audit_function_control SET NOT NULL;


ALTER TABLE config ADD COLUMN arc_searchnodes_control boolean;
ALTER TABLE config ALTER COLUMN arc_searchnodes_control SET NOT NULL;





CREATE TABLE "config_csv_import" (
"table_name" varchar(50) NOT NULL,
"gis_client_layer_name" varchar(50),
CONSTRAINT "config_csv_import_pkey" PRIMARY KEY ("table_name")
);
