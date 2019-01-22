CREATE TABLE SCHEMA_NAME.config_api_toolbar_buttons
(
  id integer NOT NULL,
  idval character varying(30),
  toolbar character varying(30),
  sys_role character varying(20),
  project_type character varying(10),
  active boolean,
  buttonoptions json,
  CONSTRAINT config_api_button_pkey PRIMARY KEY (id)
)
;
