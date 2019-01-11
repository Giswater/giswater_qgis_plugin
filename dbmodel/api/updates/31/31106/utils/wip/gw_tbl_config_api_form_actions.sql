
CREATE TABLE SCHEMA_NAME.config_api_form
(
  id serial PRIMARY KEY,
  formname character varying(50),
  projecttype character varying,
  actions json,
  layermanager json);
