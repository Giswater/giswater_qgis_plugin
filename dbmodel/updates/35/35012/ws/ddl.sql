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
  roughness numeric(12,4),
  dint numeric(12,3),
  CONSTRAINT inp_dscenario_pipe_pkey PRIMARY KEY (arc_id, dscenario_id),
  CONSTRAINT inp_dscenario_pipe_arc_id_fkey FOREIGN KEY (arc_id)
      REFERENCES inp_pipe (arc_id) MATCH SIMPLE
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
      REFERENCES inp_reservoir (node_id) MATCH SIMPLE
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
      REFERENCES inp_valve (node_id) MATCH SIMPLE
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
      REFERENCES inp_tank (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


ALTER TABLE inp_rules RENAME CONSTRAINT inp_rules_x_sector_pkey TO inp_rules_pkey;
ALTER TABLE inp_rules RENAME CONSTRAINT inp_rules_x_sector_id_fkey TO inp_rules_sector_id_fkey;


--2021/08/30
ALTER TABLE selector_inp_dscenario ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_mincut_result ALTER COLUMN cur_user SET DEFAULT "current_user"();

-- 2021/09/03
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dscenario", "column":"parent_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dscenario", "column":"dscenario_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dscenario", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE cat_dscenario ALTER active SET DEFAULT TRUE;

-- 2021/09/20
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_register", "column":"pol_id", "newName":"_pol_id_"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_tank", "column":"pol_id", "newName":"_pol_id_"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_fountain", "column":"pol_id", "newName":"_pol_id_"}}$$);

-- 2021/09/26
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"add_settings", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"add_settings", "dataType":"double precision", "isUtils":"False"}}$$);

ALTER TABLE inp_demand RENAME to inp_dscenario_demand;
ALTER VIEW v_edit_inp_demand RENAME to v_edit_inp_dscenario_demand;

UPDATE sys_table SET id = 'inp_dscenario_demand' WHERE id = 'inp_demand';
UPDATE sys_table SET id = 'v_edit_inp_dscenario_demand' WHERE id = 'v_edit_inp_demand';

UPDATE sys_foreignkey SET target_table = 'inp_dscenario_demand' WHERE  target_table = 'inp_demand';

UPDATE config_form_fields SET formname = 'v_edit_inp_dscenario_demand' WHERE formname = 'v_edit_inp_demand';

DROP TRIGGER gw_trg_typevalue_fk ON inp_dscenario_demand;

CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON inp_dscenario_demand
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_fk('inp_dscenario_demand');





