/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/28
CREATE OR REPLACE VIEW v_edit_inp_rules AS 
SELECT DISTINCT rules.id,
rules.sector_id,
rules.text,
rules.active
FROM selector_sector,
inp_rules rules
WHERE rules.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_pattern AS 
 SELECT DISTINCT  
 p.pattern_id,
 observ,
 tscode,
 tsparameters::text as tsparameters,
 p.sector_id
  FROM selector_sector,
   inp_pattern p
  WHERE (p.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text) OR p.sector_id IS NULL  ORDER BY pattern_id;

CREATE OR REPLACE VIEW v_edit_inp_pattern_value AS 
  SELECT DISTINCT 
  id, 
  p.pattern_id,
  observ,
  tscode,
  tsparameters::text as tsparameters,
  p.sector_id,
  factor_1,
  factor_2,
  factor_3,
  factor_4,
  factor_5,
  factor_6,
  factor_7,
  factor_8,
  factor_9,
  factor_10,
  factor_11,
  factor_12,
  factor_13,
  factor_14,
  factor_15,
  factor_16,
  factor_17,
  factor_18 
   FROM selector_sector,
    inp_pattern p
    JOIN inp_pattern_value USING (pattern_id)
   WHERE (p.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text) OR p.sector_id IS NULL ORDER BY id;