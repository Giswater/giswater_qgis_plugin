/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO value_state_type(id,state, name, is_operative, is_doable)
VALUES (98,0, 'EJECUTADO PLANIFICADO',true, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO value_state_type(id,state, name, is_operative, is_doable)
VALUES (97,0, 'EJECUTADO FICTICIO',true, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO value_state_type(id,state, name, is_operative, is_doable)
VALUES (96,0, 'CANCELADO PLANIFICADO',true, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO value_state_type(id,state, name, is_operative, is_doable)
VALUES (95,0, 'CANCELADO FICTICIO',true, false) ON CONFLICT (id) DO NOTHING;