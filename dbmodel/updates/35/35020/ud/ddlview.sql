/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/11
CREATE OR REPLACE VIEW vi_timeseries AS 
 SELECT timser_id, other1, other2, other3 FROM (SELECT 
inp_timeseries_value.id,
 inp_timeseries_value.timser_id,
    inp_timeseries_value.date AS other1,
    inp_timeseries_value.hour AS other2,
    inp_timeseries_value.value AS other3
   FROM inp_timeseries_value
     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
  WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text
UNION
 SELECT 
 inp_timeseries_value.id,
 inp_timeseries_value.timser_id,
    concat('FILE', ' ', inp_timeseries.fname) AS other1,
    NULL::character varying AS other2,
    NULL::numeric AS other3
   FROM inp_timeseries_value
     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
  WHERE inp_timeseries.times_type::text = 'FILE'::text
UNION
 SELECT 
    inp_timeseries_value.id,
    inp_timeseries_value.timser_id,
    inp_timeseries_value."time" AS other1,
    inp_timeseries_value.value::text AS other2,
    NULL::numeric AS other3
   FROM inp_timeseries_value
     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
  WHERE inp_timeseries.times_type::text = 'RELATIVE'::text) a
  ORDER BY id;