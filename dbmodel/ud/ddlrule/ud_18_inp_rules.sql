/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP RULE IF EXISTS insert_inp_dwf ON man_junction;
CREATE OR REPLACE RULE insert_inp_dwf AS ON INSERT TO man_junction
DO INSERT INTO inp_dwf (node_id,"value") VALUES (NEW.node_id, '0');

DROP RULE IF EXISTS insert_inp_dwf ON man_chamber;
CREATE OR REPLACE RULE insert_inp_dwf AS ON INSERT TO man_chamber
DO INSERT INTO inp_dwf (node_id,"value") VALUES (NEW.node_id, '0');

DROP RULE IF EXISTS insert_inp_dwf ON man_manhole;
CREATE OR REPLACE RULE insert_inp_dwf AS ON INSERT TO man_manhole
DO INSERT INTO inp_dwf (node_id,"value") VALUES (NEW.node_id, '0');

DROP RULE IF EXISTS insert_inp_dwf ON man_netinit;
CREATE OR REPLACE RULE insert_inp_dwf AS ON INSERT TO man_netinit
DO INSERT INTO inp_dwf (node_id,"value") VALUES (NEW.node_id, '0');

DROP RULE IF EXISTS insert_inp_dwf ON man_wjump;
CREATE OR REPLACE RULE insert_inp_dwf AS ON INSERT TO man_wjump
DO INSERT INTO inp_dwf (node_id,"value") VALUES (NEW.node_id, '0');