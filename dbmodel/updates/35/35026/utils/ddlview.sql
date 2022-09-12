/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/10
CREATE OR REPLACE VIEW v_price_compost AS 
 SELECT plan_price.id,
    plan_price.unit,
    plan_price.descript,
        CASE
            WHEN plan_price.price IS NOT NULL THEN plan_price.price::numeric(14,2)
            ELSE sum(price * plan_price_compost.value)::numeric(14,2)
        END AS price
   FROM plan_price
     LEFT JOIN plan_price_compost ON plan_price.id::text = plan_price_compost.compost_id::text
  GROUP BY plan_price.id, plan_price.unit, plan_price.descript;

  
CREATE OR REPLACE VIEW vi_controls AS 
 SELECT c.text
           FROM ( SELECT inp_controls.id,
                    inp_controls.text
                   FROM selector_sector,
                    inp_controls
                  WHERE selector_sector.sector_id = inp_controls.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_controls.active IS NOT FALSE
                  UNION
                  SELECT id,
                    text
                   FROM selector_sector s,
                    v_edit_inp_dscenario_controls d
                  WHERE s.sector_id = d.sector_id AND s.cur_user = "current_user"()::text AND d.active IS NOT FALSE
                  ORDER BY 1)c
  ORDER BY c.id;
  
  
  CREATE OR REPLACE VIEW v_ui_cat_dscenario AS 
 SELECT DISTINCT ON (c.dscenario_id) c.dscenario_id,
    c.name,
    c.descript,
    c.dscenario_type,
    c.parent_id,
    c.expl_id,
    c.active,
    c.log
   FROM cat_dscenario c, selector_expl s
  WHERE ((s.expl_id = c.expl_id AND s.cur_user = CURRENT_USER::text) OR c.expl_id IS NULL);
  