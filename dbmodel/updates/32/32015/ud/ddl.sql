/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE IF NOT EXISTS om_psector_x_gully(
  id serial NOT NULL,
  gully_id character varying(16),
  arc_id character varying(16),
  psector_id integer,
  descript character varying(254),
  CONSTRAINT om_psector_x_gully_pkey PRIMARY KEY (id),
  CONSTRAINT om_psector_x_gully_gully_id_fkey FOREIGN KEY (gully_id)
      REFERENCES gully (gully_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT om_psector_x_gully_psector_id_fkey FOREIGN KEY (psector_id)
      REFERENCES om_psector (psector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


  
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


ALTER TABLE subcatchment DROP CONSTRAINT subcatchment_node_id_fkey;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"vnode", "column":"top_elev", "dataType":"numeric(12,3)"}}$$);

