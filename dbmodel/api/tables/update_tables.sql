
CREATE TABLE clav.config_web_layer
(
  layer_id text NOT NULL,
  alias_id text NOT NULL,
  is_parent boolean,
  tableparent_id text,
  is_editable boolean,
  tableinfo_id text,
  formid text,
  formname text,
  orderby integer,
  CONSTRAINT config_web_layer_pkey PRIMARY KEY (layer_id)
)
WITH (
  OIDS=FALSE
);



CREATE TABLE clav.config_web_layer_child
(
  featurecat_id character varying(30) NOT NULL,
  tableinfo_id text,
  CONSTRAINT config_web_layer_child_pkey PRIMARY KEY (featurecat_id)
)
WITH (
  OIDS=FALSE
);CREATE TABLE clav.config_web_layer_child
(
  featurecat_id character varying(30) NOT NULL,
  tableinfo_id text,
  CONSTRAINT config_web_layer_child_pkey PRIMARY KEY (featurecat_id)
)
WITH (
  OIDS=FALSE
);



CREATE TABLE clav.config_web_layer_tab
(
  id serial NOT NULL,
  layer_id character varying(50),
  formtab text,
  tableview_id text,
  CONSTRAINT config_web_layer_tab_pkey PRIMARY KEY (id),
  CONSTRAINT config_web_layer_formtab_fkey FOREIGN KEY (formtab)
      REFERENCES clav.config_web_layer_cat_formtab (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);




CREATE TABLE clav.config_web_tableinfo_x_inforole
(
  id serial NOT NULL,
  tableinfo_id character varying(50),
  inforole_id integer,
  tableinforole_id text,
  CONSTRAINT config_web_tableinfo_x_inforole_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

