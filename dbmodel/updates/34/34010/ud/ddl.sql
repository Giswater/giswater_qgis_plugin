/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE subcatchment RENAME TO inp_subcatchment;

ALTER TABLE v_edit_subcatchment RENAME TO v_edit_inp_subcatchment;

ALTER SEQUENCE subcatchment_subc_id_seq RENAME TO inp_subcatchment_subc_id_seq;

DROP SEQUENCE IF EXISTS inp_vertice_seq;