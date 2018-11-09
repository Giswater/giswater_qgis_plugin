/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP CHECK

ALTER TABLE "plan_psector_cat_type" DROP CONSTRAINT IF EXISTS "plan_psector_cat_type_check";
ALTER TABLE "price_value_unit" DROP CONSTRAINT IF EXISTS "price_value_unit_check";


-- ADD CHECK

ALTER TABLE "plan_psector_cat_type" ADD CONSTRAINT plan_psector_cat_type_check CHECK (id = 1);
ALTER TABLE "price_value_unit" ADD CONSTRAINT price_value_unit_check CHECK (id IN ('kg','m','m2','m3','pa','t','u'));