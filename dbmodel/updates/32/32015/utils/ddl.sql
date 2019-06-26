/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE om_psector_x_connec(
  id serial NOT NULL,
  connec_id character varying(16),
  psector_id integer,
  descript character varying(254),
  CONSTRAINT om_psector_x_connec_pkey PRIMARY KEY (id),
  CONSTRAINT om_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id)
      REFERENCES connec (connec_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT om_psector_x_connec_psector_id_fkey FOREIGN KEY (psector_id)
      REFERENCES om_psector (psector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


  
CREATE TABLE plan_psector_x_connec(
  id serial NOT NULL,
  connec_id character varying(16) NOT NULL,
  psector_id integer NOT NULL,
  state smallint NOT NULL,
  doable boolean NOT NULL,
  descript character varying(254),
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
