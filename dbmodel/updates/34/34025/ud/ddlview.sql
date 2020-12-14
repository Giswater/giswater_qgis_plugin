/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

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