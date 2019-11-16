/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--13/11/2019
ALTER TABLE inp_mapunits ADD CONSTRAINT inp_mapunits_pkey PRIMARY KEY(type_units);
ALTER TABLE inp_mapdim ADD CONSTRAINT inp_mapdim_pkey PRIMARY KEY(type_dim);
