
CREATE TABLE ws_sample.config_api_form_actions
(
  id serial PRIMARY KEY,
  formname character varying(50),
  project_type character varying,
  actions json);
