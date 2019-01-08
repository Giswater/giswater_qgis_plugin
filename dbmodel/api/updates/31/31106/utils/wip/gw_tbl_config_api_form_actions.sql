
CREATE TABLE ws_sample.config_api_form
(
  id serial PRIMARY KEY,
  formname character varying(50),
  projecttype character varying,
  actions json,
  layermanager json);
