/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

 ALTER TABLE IF EXISTS cat_feature_arc DROP CONSTRAINT IF EXISTS cat_feature_arc_inp_check;

ALTER TABLE IF EXISTS cat_feature_arc
ADD CONSTRAINT cat_feature_arc_inp_check CHECK (epa_default::text = ANY (ARRAY['PIPE'::text, 'UNDEFINED'::text, 'PUMP-IMPORTINP'::text, 'VALVE-IMPORTINP'::text, 'VIRTUALVALVE'::text, 'VIRTUALPUMP'::text]));
