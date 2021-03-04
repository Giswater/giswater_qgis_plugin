/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/04
CREATE INDEX plan_psector_x_connec_arc_id ON plan_psector_x_connec USING btree (arc_id);
CREATE INDEX plan_psector_x_connec_connec_id ON plan_psector_x_connec USING btree (connec_id);

UPDATE sys_table set sys_sequence='plan_psector_x_connec_id_seq', sys_sequence_field='id' WHERE id='plan_psector_x_connec';

