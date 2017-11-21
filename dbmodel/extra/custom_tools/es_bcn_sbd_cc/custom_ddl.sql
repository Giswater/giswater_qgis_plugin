SELECT sanejament.gw_fct_om_visit(2,'NODE');
SELECT sanejament.gw_fct_om_visit(2,'ARC');
--SELECT sanejament.gw_fct_om_visit_end();


SET SEARCH_PATH=sanejament;

CREATE EXTENSION unaccent;
CREATE EXTENSION tablefunc;


CREATE SEQUENCE sanejament.urn_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

ALTER TABLE "om_visit" ADD CONSTRAINT "iom_visit_visicat_id_fkey" FOREIGN KEY ("visitcat_id") REFERENCES "om_visit_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element ADD COLUMN tstamp timestamp default NOW();
ALTER TABLE om_visit_x_arc ADD COLUMN is_last boolean default TRUE;
ALTER TABLE om_visit_x_node ADD COLUMN is_last boolean default TRUE;
ALTER TABLE om_visit_x_connec ADD COLUMN is_last boolean default TRUE;
ALTER TABLE om_visit_x_gully ADD COLUMN is_last boolean default TRUE;





CREATE TABLE "selector_date"(
"id" serial PRIMARY KEY,
"from_date" date,
"to_date" date,
"context" varchar(30),
"cur_user" varchar (30)
);



CREATE TABLE "temp_om_visit_arc"(
id serial PRIMARY KEY,
  dia character varying,
  codi character varying,
  inici double precision,
  final double precision,
  seccio character varying,
  tipsec character varying,
  mida double precision,
  mida_x double precision,
  material character varying,
  res_nivell double precision,
  res_tipus character varying,
  est_general character varying,
  est_volta character varying,
  est_solera character varying,
  est_tester character varying,
  equip integer,
  observacions character varying
 );
 

CREATE TABLE temp_om_visit_node(
  id serial PRIMARY KEY,
  dia character varying,
  codi character varying,
  sorrer double precision,
  total double precision,
  tapa_tipus character varying,
  tapa_estat character varying,
  pates_poli integer,
  pates_ferr integer,
  pates_rep integer,
  res_nivell double precision,
  res_tipus character varying,
  est_general character varying,
  est_solera character varying,
  est_parets character varying,
  equip integer,
  observacions character varying
);



CREATE TABLE ext_om_visit_lot (
id serial PRIMARY KEY,
visitcat_id integer,
tstamp timestamp DEFAULT now()
);


CREATE TABLE ext_om_visit_lot_arc (
  id serial PRIMARY KEY,
  lot_id integer,
  dia character varying,
  codi character varying,
  inici double precision,
  final double precision,
  seccio character varying,
  tipsec character varying,
  mida double precision,
  mida_x double precision,
  material character varying,
  res_nivell double precision,
  res_tipus character varying,
  est_general character varying,
  est_volta character varying,
  est_solera character varying,
  est_tester character varying,
  equip integer,
  observacions character varying
);

ALTER TABLE "ext_om_visit_lot_arc" ADD CONSTRAINT "ext_om_visit_lot_arc_lot_fk" FOREIGN KEY ("lot_id") REFERENCES "ext_om_visit_lot" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE ext_om_visit_lot_node (
  id serial PRIMARY KEY,
  lot_id integer,
  dia character varying,
  codi character varying,
  sorrer double precision,
  total double precision,
  tapa_tipus character varying,
  tapa_estat character varying,
  pates_poli integer,
  pates_ferr integer,
  pates_rep integer,
  res_nivell double precision,
  res_tipus character varying,
  est_general character varying,
  est_solera character varying,
  est_parets character varying,
  equip integer,
  observacions character varying
);

ALTER TABLE "ext_om_visit_lot_node" ADD CONSTRAINT "ext_om_visit_lot_node_lot_fk" FOREIGN KEY ("lot_id") REFERENCES "ext_om_visit_lot" ("id") ON DELETE CASCADE ON UPDATE CASCADE;



drop table sanejament.om_visit_review_config;
CREATE TABLE sanejament.om_visit_review_config (
id serial PRIMARY KEY,
y1 float,
y2 float,
geom1 float,
geom2 float,
sander float,
ymax float
);


DROP TABLE sanejament.om_visit_review_arc;
CREATE TABLE sanejament.om_visit_review_arc (
id serial PRIMARY KEY, 
arc_id varchar(16),
old_y1 float, 
new_y1 float, 
old_y2 float, 
new_y2 float, 
arccat_id varchar (30), 
old_shape varchar (30),
new_shape varchar (30),
old_geom1 float,
new_geom1 float,
old_geom2 float,
new_geom2 float,
old_matcat_id varchar (30),
new_matcat_id varchar (30),
cur_user varchar (30),  
lot_id integer,
is_validated boolean
);

DROP TABLE sanejament.om_visit_review_node;
CREATE TABLE sanejament.om_visit_review_node (
id serial PRIMARY KEY, 
node_id varchar(16),
old_sander float, 
new_sander float, 
old_ymax float, 
new_ymax float, 
cur_user text , 
lot_id integer,
is_validated boolean
);


DROP VIEW sanejament.v_ui_element_x_node;
CREATE OR REPLACE VIEW sanejament.v_ui_element_x_node AS 
 SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    element.elementcat_id,
    element.state,
    element.observ,
    element.comment,
    element.builtdate,
    element.enddate
   FROM sanejament.element_x_node
     JOIN sanejament.element ON element.element_id::text = element_x_node.element_id::text WHERE is_last IS TRUE;



-- PERMISSIONS
--TO postgres;
--TO "VIALITAT";
--TO "ADMIN_GIS" WITH GRANT OPTION;
--TO "VIALITAT_CONSULTA";


-- UPDATE VALUES
UPDATE element SET is_last=TRUE;
UPDATE om_visit_parameter_type SET id ='INSPECCIONS' WHERE id='INSPECTION'

INSERT INTO om_visit_parameter VALUES ('EstatTapa', 'INSPECCIONS', 'NODE', 'TEXT', 'Inspecció estat de la tapa del pou');
INSERT INTO om_visit_parameter VALUES ('PatesReposar', 'INSPECCIONS', 'NODE', 'integer', 'Numero de pates a reposar del pou');
INSERT INTO om_visit_parameter VALUES ('NivellResidus', 'INSPECCIONS', 'ALL', 'FLOAT', 'Inspecció nivell de sediments');
INSERT INTO om_visit_parameter VALUES ('Observacions', 'INSPECCIONS', 'ALL', 'text', 'Temes observacions varies en la inspecció');
INSERT INTO om_visit_parameter VALUES ('EstatSolera', 'INSPECCIONS', 'ALL', 'text', 'Estat de la solera');
INSERT INTO om_visit_parameter VALUES ('EstatTester', 'INSPECCIONS', 'ARC', 'text', 'Estat del tester');
INSERT INTO om_visit_parameter VALUES ('EstatVolta', 'INSPECCIONS', 'ARC', 'text', 'Estat de la volta');
INSERT INTO om_visit_parameter VALUES ('TipusResidus', 'INSPECCIONS', 'ALL', 'text', 'Tipus de residus');
INSERT INTO om_visit_parameter VALUES ('EstatGeneral', 'INSPECCIONS', 'ALL', 'text', 'Informació sobre estat general del element');
INSERT INTO om_visit_parameter VALUES ('EstatParets', 'INSPECCIONS', 'NODE', 'text', 'Informació sobre estat de les parets del element');

INSERT INTO sanejament.cat_element VALUES ('TAPA')

INSERT INTO om_visit_cat VALUES ('2', 'Inspeccions','Inspeccions FCC 2017', 'Informació entregada per FCC', '2017-01-01','2017-12-31');
INSERT INTO om_visit_cat VALUES ('3', 'Inspeccions','Inspeccions FCC 2018', 'Informació entregada per FCC', '2018-01-01','2018-12-31');
