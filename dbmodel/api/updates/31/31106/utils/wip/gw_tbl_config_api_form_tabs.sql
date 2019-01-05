
CREATE TABLE SCHEMA_NAME.config_api_form_actions
(
  id integer NOT NULL,
  formname character varying(50),
  formaction text,
  project_type character varying,
  CONSTRAINT config_api_actions_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
