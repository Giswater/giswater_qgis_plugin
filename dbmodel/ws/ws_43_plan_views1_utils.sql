/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- COMMON SQL (WS & UD)

DROP VIEW IF EXISTS "v_price_compost" CASCADE; 
CREATE VIEW "v_price_compost" AS 
SELECT
  price_compost.id,
  price_compost.unit,
  price_compost.descript,
  (CASE WHEN (price_compost.price IS  NOT NULL) THEN price_compost.price::numeric(14,2) 
  ELSE (sum(price_simple.price*price_compost_value.value))::numeric(14,2) END) AS price 
FROM (price_compost
LEFT JOIN price_compost_value ON (((price_compost.id)::text = (price_compost_value.compost_id)::text))
LEFT JOIN price_simple ON (((price_simple.id)::text = (price_compost_value.simple_id)::text)))
GROUP BY price_compost.id, price_compost.unit, price_compost.descript;


DROP VIEW IF EXISTS "v_price_x_catsoil1"  CASCADE;
CREATE VIEW "v_price_x_catsoil1" AS 
SELECT
  cat_soil.id,
  cat_soil.y_param,
  cat_soil.b,
  cat_soil.trenchlining,
  v_price_compost.price AS m3exc_cost
FROM (cat_soil
JOIN v_price_compost ON (((cat_soil."m3exc_cost")::text = (v_price_compost.id)::text)));


DROP VIEW IF EXISTS "v_price_x_catsoil2" CASCADE;
CREATE VIEW "v_price_x_catsoil2" AS
SELECT
  cat_soil.id,
  v_price_compost.price AS m3fill_cost
FROM (cat_soil
JOIN v_price_compost ON (((cat_soil."m3fill_cost")::text = (v_price_compost.id)::text)));


DROP VIEW IF EXISTS "v_price_x_catsoil3" CASCADE;
CREATE VIEW "v_price_x_catsoil3" AS
SELECT
  cat_soil.id,
  v_price_compost.price AS m3excess_cost
FROM (cat_soil
JOIN v_price_compost ON (((cat_soil."m3excess_cost")::text = (v_price_compost.id)::text)));


DROP VIEW IF EXISTS "v_price_x_catsoil4" CASCADE;
CREATE VIEW "v_price_x_catsoil4" AS
SELECT
  cat_soil.id,
   v_price_compost.price AS m2trenchl_cost
FROM (cat_soil
JOIN v_price_compost ON (((cat_soil."m2trenchl_cost")::text = (v_price_compost.id)::text)))
WHERE (((cat_soil.m2trenchl_cost)::text = (v_price_compost.id)::text)  OR  (cat_soil.m2trenchl_cost)::text = null);


DROP VIEW IF EXISTS "v_price_x_catsoil" CASCADE;
CREATE VIEW "v_price_x_catsoil" AS
SELECT
  v_price_x_catsoil1.id,
  v_price_x_catsoil1.y_param,
  v_price_x_catsoil1.b,
  v_price_x_catsoil1.trenchlining,
  v_price_x_catsoil1.m3exc_cost,
  v_price_x_catsoil2.m3fill_cost,
  v_price_x_catsoil3.m3excess_cost,
  v_price_x_catsoil4.m2trenchl_cost
FROM (v_price_x_catsoil1
LEFT JOIN v_price_x_catsoil2 ON (((v_price_x_catsoil2.id)::text = (v_price_x_catsoil1.id)::text))
LEFT JOIN v_price_x_catsoil3 ON (((v_price_x_catsoil3.id)::text = (v_price_x_catsoil1.id)::text))
LEFT JOIN v_price_x_catsoil4 ON (((v_price_x_catsoil4.id)::text = (v_price_x_catsoil1.id)::text))
);


