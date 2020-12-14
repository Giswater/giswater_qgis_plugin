/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/03
ALTER TABLE cat_grate ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_node_shape ALTER COLUMN active SET DEFAULT TRUE;

-- 2020/12/04
ALTER TABLE IF EXISTS inp_label RENAME to _inp_label_;

CREATE TABLE IF NOT EXISTS inp_label
(
  label text primary key,
  xcoord numeric(18,6),
  ycoord numeric(18,6),
  anchor character varying(16),
  font character varying(50),
  size integer,
  bold character varying(3),
  italic character varying(3)
);


DROP VIEW vi_labels;
CREATE OR REPLACE VIEW vi_labels AS 
 SELECT inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.anchor,
    inp_label.font,
    inp_label.size,
    inp_label.bold,
    inp_label.italic
   FROM inp_label
  ORDER BY inp_label.label;

CREATE TRIGGER gw_trg_vi_labels
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_labels
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_labels');


CREATE OR REPLACE VIEW vi_timeseries AS 
 SELECT inp_timeseries.timser_id,
    inp_timeseries.date AS other1,
    inp_timeseries.hour AS other2,
    inp_timeseries.value AS other3
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'ABSOLUTE'::text
UNION
 SELECT inp_timeseries.timser_id,
    concat('FILE', ' ', inp_timeseries.fname) AS other1,
    NULL::character varying AS other2,
    NULL::numeric AS other3
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'FILE'::text
UNION
 SELECT inp_timeseries.timser_id,
    inp_timeseries."time" AS other1,
    inp_timeseries.value::text AS other2,
    NULL::numeric AS other3
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'RELATIVE'::text
  ORDER BY 1, 2;