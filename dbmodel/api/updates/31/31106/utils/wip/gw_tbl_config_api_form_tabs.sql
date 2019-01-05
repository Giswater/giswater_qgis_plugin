
CREATE TABLE SCHEMA_NAME.config_api_form_tabs
(
  id integer PRIMARY KEY,
  formname character varying(50),
  tabname text,
  tablabel text,
  tabtext text,
  sys_role text,
  tooltip text,
  tabfunction json,
  tabactions json,
  CONSTRAINT config_web_tabs_pkey PRIMARY KEY (id)
);