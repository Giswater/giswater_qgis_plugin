/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE dma DROP COLUMN _pattern_id;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"minorloss", "dataType":"numeric(12,6)"}}$$);

ALTER TABLE price_simple RENAME TO _price_simple_;
ALTER TABLE om_visit_value_criticity RENAME TO _om_visit_value_criticity_;
ALTER TABLE dattrib RENAME TO _dattrib_;
ALTER TABLE dattrib_type RENAME TO _dattrib_type_;
ALTER TABLE ext_rtc_scada_x_data RENAME TO _ext_rtc_scada_x_data_;
ALTER TABLE ext_rtc_scada_x_value RENAME TO _ext_rtc_scada_x_value_;
ALTER TABLE ext_rtc_hydrometer_x_value RENAME TO _ext_rtc_hydrometer_x_value_;
ALTER TABLE config RENAME TO _config_;
ALTER TABLE config_api_cat_widgettype RENAME TO _config_api_cat_widgettype_;
ALTER TABLE config_api_cat_formtemplate RENAME TO _config_api_cat_formtemplate_;
ALTER TABLE config_api_cat_datatype RENAME TO _config_api_cat_datatype_;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"pjoint_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"pjoint_id", "dataType":"varchar(16)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"price_compost", "column":"pricecat_id", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_csv2pg_cat", "column":"readheader", "dataType":"boolean"}}$$);


CREATE TABLE IF NOT EXISTS om_psector_x_connec (
  id serial NOT NULL,
  connec_id character varying(16) NOT NULL,
  arc_id character varying(16),
  psector_id integer,
  descript character varying(254),
  CONSTRAINT om_psector_x_connec_pkey PRIMARY KEY (id),
  CONSTRAINT om_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id)
      REFERENCES connec (connec_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT om_psector_x_connec_psector_id_fkey FOREIGN KEY (psector_id)
      REFERENCES om_psector (psector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


  
CREATE TABLE IF NOT EXISTS plan_psector_x_connec(
  id serial NOT NULL,
  connec_id character varying(16) NOT NULL,
  arc_id character varying(16),
  psector_id integer NOT NULL,
  state smallint NOT NULL,
  doable boolean NOT NULL,
  descript character varying(254),
  link_geom geometry (LINESTRING, SRID_VALUE),
  vnode_geom geometry (POINT, SRID_VALUE),
  CONSTRAINT plan_psector_x_connec_pkey PRIMARY KEY (id),
  CONSTRAINT plan_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id)
      REFERENCES connec (connec_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT plan_psector_x_connec_psector_id_fkey FOREIGN KEY (psector_id)
      REFERENCES plan_psector (psector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT plan_psector_x_connec_state_fkey FOREIGN KEY (state)
      REFERENCES value_state (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"ext_code", "dataType":"varchar(50)"}}$$);


DROP RULE IF EXISTS insert_plan_psector_x_connec ON connec;
CREATE OR REPLACE RULE insert_plan_psector_x_connec AS ON INSERT TO connec WHERE NEW.state=2 DO 
INSERT INTO plan_psector_x_connec (connec_id, psector_id, state, doable) 
VALUES (new.connec_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()LIMIT 1),1,TRUE);
