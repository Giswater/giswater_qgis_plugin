CREATE TABLE SCHEMA_NAME.config_api_list
(
  id serial NOT NULL,
  tablename character varying(50),
  query_text text,
  device smallint,
  actionfields json,
  listtype character varying(30),
  CONSTRAINT config_api_list_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);