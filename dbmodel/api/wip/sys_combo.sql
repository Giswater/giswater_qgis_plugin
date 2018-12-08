CREATE TABLE ws_sample.sys_combo_cat
(
  id serial NOT NULL,
  idval text,
  CONSTRAINT sys_combo_cat_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ws_sample.sys_combo_cat
  OWNER TO postgres;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO postgres;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO geoadmin;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO user_dev;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO rol_dev;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO qgisserver;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO xtorret;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO user_test;
GRANT ALL ON TABLE ws_sample.sys_combo_cat TO role_basic;



CREATE TABLE ws_sample.sys_combo_values
(
  sys_combo_cat_id integer NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  CONSTRAINT sys_combo_pkey PRIMARY KEY (sys_combo_cat_id, id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ws_sample.sys_combo_values
  OWNER TO postgres;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO postgres;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO geoadmin;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO user_dev;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO rol_dev;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO qgisserver;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO xtorret;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO user_test;
GRANT ALL ON TABLE ws_sample.sys_combo_values TO role_basic;
