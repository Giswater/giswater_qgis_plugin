/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/05
ALTER TABLE connec ADD CONSTRAINT connec_epa_type_check CHECK (epa_type = ANY (ARRAY['JUNCTION', 'UNDEFINED']));

ALTER TABLE inp_curve DROP CONSTRAINT inp_curve_id_curve_type_check;