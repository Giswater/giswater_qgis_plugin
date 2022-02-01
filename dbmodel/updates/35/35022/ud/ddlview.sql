/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
DROP VIEW IF EXISTS v_edit_inp_pattern;
CREATE OR REPLACE VIEW v_edit_inp_pattern AS 
 SELECT DISTINCT p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    p.log
   FROM selector_expl s, inp_pattern p
WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
ORDER BY p.pattern_id;

DROP VIEW IF EXISTS v_edit_inp_pattern_value;
CREATE OR REPLACE VIEW v_edit_inp_pattern_value AS 
 SELECT DISTINCT inp_pattern_value.id,
    p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18
   FROM selector_expl s, inp_pattern p
     JOIN inp_pattern_value USING (pattern_id)
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY inp_pattern_value.id;


CREATE OR REPLACE VIEW v_edit_inp_timeseries AS 
SELECT DISTINCT p.id,
    p.timser_type,
    p.times_type,
    p.idval,
    p.descript,
    p.fname,
    p.expl_id,
    p.log
   FROM selector_expl s, inp_timeseries p
WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
ORDER BY p.id;


CREATE OR REPLACE VIEW v_edit_inp_timeseries_value AS 
SELECT DISTINCT p.id,
   p.timser_id,
   t.timser_type,
   t.times_type,
   t.idval,
   t.expl_id,
   p.date,
   p.hour,
   p."time",
   p.value
   FROM selector_expl s, inp_timeseries t
   JOIN inp_timeseries_value p ON t.id=timser_id
WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
ORDER BY p.id;

