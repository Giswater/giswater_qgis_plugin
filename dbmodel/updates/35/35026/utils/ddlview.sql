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