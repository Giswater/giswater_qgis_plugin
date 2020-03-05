/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE subcatchment ALTER COLUMN node_id TYPE character varying(100);
ALTER TABLE subcatchment RENAME node_id TO outlet_id;
ALTER TABLE subcatchment RENAME parent_id TO _parent_id;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"pjoint_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"pjoint_id", "dataType":"varchar(16)"}}$$);


CREATE TABLE IF NOT EXISTS plan_psector_x_gully(
  id serial NOT NULL,
  gully_id character varying(16) NOT NULL,
  arc_id character varying(16),
  psector_id integer NOT NULL,
  state smallint NOT NULL,
  doable boolean NOT NULL,
  descript character varying(254),
  link_geom geometry (LINESTRING, SRID_VALUE),
  vnode_geom geometry (POINT, SRID_VALUE),
  CONSTRAINT plan_psector_x_gully_pkey PRIMARY KEY (id),
  CONSTRAINT plan_psector_x_gully_gully_id_fkey FOREIGN KEY (gully_id)
      REFERENCES gully (gully_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT plan_psector_x_gully_psector_id_fkey FOREIGN KEY (psector_id)
      REFERENCES plan_psector (psector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT plan_psector_x_gully_state_fkey FOREIGN KEY (state)
      REFERENCES value_state (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


ALTER TABLE subcatchment DROP CONSTRAINT IF EXISTS subcatchment_node_id_fkey;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"vnode", "column":"top_elev", "dataType":"numeric(12,3)"}}$$);


DROP RULE IF EXISTS insert_plan_psector_x_gully ON gully;
CREATE OR REPLACE RULE insert_plan_psector_x_gully AS ON INSERT TO gully WHERE NEW.state=2 DO 
INSERT INTO plan_psector_x_gully (gully_id, psector_id, state, doable) 
VALUES (new.gully_id, (SELECT value::integer FROM config_param_user WHERE parameter='psector_vdefault' and cur_user="current_user"()LIMIT 1),1,TRUE);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"lastupdate", "dataType":"timestamp without time zone"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"lastupdate_user", "dataType":"character varying(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"insert_user", "dataType":"character varying(50) DEFAULT current_user"}}$$);