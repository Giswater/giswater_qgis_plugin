/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE SCHEMA_NAME.inp_flwreg_weir DROP CONSTRAINT inp_flwreg_weir_check_type;

ALTER TABLE SCHEMA_NAME.inp_flwreg_weir
ADD CONSTRAINT inp_flwreg_weir_check_type CHECK (weir_type::text = ANY (ARRAY['SIDEFLOW','TRANSVERSE','V-NOTCH','TRAPEZOIDAL_WEIR']::text[]));

ALTER TABLE inp_timser_id DROP CONSTRAINT inp_timser_id_check;

ALTER TABLE inp_rdii ADD CONSTRAINT inp_rdii_hydro_id_fkey FOREIGN KEY (hydro_id) REFERENCES inp_hdyrograph_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;