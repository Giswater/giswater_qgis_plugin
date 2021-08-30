/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/24

ALTER TABLE selector_inp_demand RENAME TO selector_inp_dscenario;


CREATE TABLE inp_dscenario_shortpipe (
  dscenario_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  minorloss numeric(12,6),
  status character varying(12),
  CONSTRAINT inp_dscenario_shortpipe_pkey PRIMARY KEY (node_id),
  CONSTRAINT inp_dscenario_shortpipe_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_shortpipe_status_check CHECK (status::text = ANY (ARRAY['CLOSED'::character varying, 'CV'::character varying, 'OPEN'::character varying]::text[]))
);


CREATE TABLE inp_dscenario_pipe (
  dscenario_id integer NOT NULL,
  arc_id character varying(16) NOT NULL,
  minorloss numeric(12,6),
  status character varying(12),
  roughness numeric(12,4) NOT NULL,
  dint numeric(12,3) NOT NULL,
  CONSTRAINT inp_dscenario_pipe_pkey PRIMARY KEY (arc_id, dscenario_id),
  CONSTRAINT inp_dscenario_pipe_arc_id_fkey FOREIGN KEY (arc_id)
      REFERENCES arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_pipe_status_check CHECK (status::text = ANY (ARRAY['CLOSED'::character varying, 'CV'::character varying, 'OPEN'::character varying]::text[]))
);


CREATE TABLE inp_dscenario_pump(
  dscenario_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  power character varying,
  curve_id character varying,
  speed numeric(12,6),
  pattern character varying,
  status character varying(12),
  CONSTRAINT inp_dscenario_pump_pkey PRIMARY KEY (node_id, dscenario_id),
  CONSTRAINT inp_dscenario_pump_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_pump_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_pump_status_check CHECK (status::text = ANY (ARRAY['CLOSED'::character varying, 'OPEN'::character varying]::text[]))
);



CREATE TABLE inp_dscenario_reservoir (
  dscenario_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  pattern_id character varying(16),
  head double precision,
  CONSTRAINT inp_dscenario_reservoir_pkey PRIMARY KEY (node_id, dscenario_id),
  CONSTRAINT inp_dscenario_reservoir_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id)
      REFERENCES inp_pattern (pattern_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE inp_dscenario_valve(
  dscenario_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  valv_type character varying(18),
  pressure numeric(12,4),
  flow numeric(12,4),
  coef_loss numeric(12,4),
  curve_id character varying(16),
  minorloss numeric(12,4),
  status character varying(12) DEFAULT 'ACTIVE'::character varying,
  CONSTRAINT inp_dscenario_valve_pkey PRIMARY KEY (node_id, dscenario_id),
  CONSTRAINT inp_dscenario_valve_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_valve_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_valve_status_check CHECK (status::text = ANY (ARRAY['ACTIVE'::character varying, 'CLOSED'::character varying, 'OPEN'::character varying]::text[])),
  CONSTRAINT inp_dscenario_valve_valv_type_check CHECK (valv_type::text = ANY (ARRAY['FCV'::character varying, 'GPV'::character varying, 'PBV'::character varying, 'PRV'::character varying, 'PSV'::character varying, 'TCV'::character varying]::text[]))
);



CREATE TABLE inp_dscenario_tank (
  dscenario_id integer NOT NULL,
  node_id character varying(16) NOT NULL,
  initlevel numeric(12,4),
  minlevel numeric(12,4),
  maxlevel numeric(12,4),
  diameter numeric(12,4),
  minvol numeric(12,4),
  curve_id character varying(16),
  CONSTRAINT inp_dscenario_tank_pkey PRIMARY KEY (node_id, dscenario_id),
  CONSTRAINT inp_dscenario_tank_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


ALTER TABLE inp_rules RENAME CONSTRAINT inp_rules_x_sector_pkey TO inp_rules_pkey;
ALTER TABLE inp_rules RENAME CONSTRAINT inp_rules_x_sector_id_fkey TO inp_rules_sector_id_fkey;


--2021/08/30
ALTER TABLE selector_inp_dscenario ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_mincut_result ALTER COLUMN cur_user SET DEFAULT "current_user"();

