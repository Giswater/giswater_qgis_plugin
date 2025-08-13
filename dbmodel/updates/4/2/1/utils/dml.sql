/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE plan_typevalue SET idval = 'PLANIFIED' WHERE idval = 'PLANNIFIED';

INSERT INTO plan_typevalue VALUES ('psector_status', '8', 'RESTORED', 'Psector that was archived but that have been restored');
INSERT INTO plan_typevalue VALUES ('psector_status', '7', 'CANCELED (ARCHIVED)', 'Psector cancelled and the same time archived');
INSERT INTO plan_typevalue VALUES ('psector_status', '6', 'COMISSIONED (ARCHIVED)', 'Psector cancelled and the same time archived');
INSERT INTO plan_typevalue VALUES ('psector_status', '5', 'MADE OPERATIONAL (ARCHIVED)', 'Psector cancelled and the same time archived');
UPDATE plan_typevalue SET idval = 'EXECUTED' WHERE typevalue = 'psector_status' AND id = '4';
UPDATE plan_typevalue SET idval = 'EXECUTION IN PROGRESS' WHERE typevalue = 'psector_status' AND id = '3';
UPDATE plan_typevalue SET idval = 'PLANNED' WHERE typevalue = 'psector_status' AND id = '2';
UPDATE plan_typevalue SET idval = 'PLANNING IN PROGRESS' WHERE typevalue = 'psector_status' AND id = '1';

UPDATE plan_psector SET status = 8 WHERE status = null;
UPDATE plan_psector SET status = 7 WHERE status = 3;
UPDATE plan_psector SET status = 6 WHERE status = 0;
UPDATE plan_psector SET status = 5 WHERE status = 4;
UPDATE plan_psector SET status = 4 WHERE status = null;
UPDATE plan_psector SET status = 3 WHERE status = null;
UPDATE plan_psector SET status = 2 WHERE status = 2;
UPDATE plan_psector SET status = 1 WHERE status = 1;

UPDATE sys_table SET id = 'archived_psector_arc' WHERE id = 'archived_psector_arc_traceability';
UPDATE sys_table SET id = 'archived_psector_node' WHERE id = 'archived_psector_node_traceability';
UPDATE sys_table SET id = 'archived_psector_connec' WHERE id = 'archived_psector_connec_traceability';
UPDATE sys_table SET id = 'archived_psector_gully' WHERE id = 'archived_psector_gully_traceability';
UPDATE sys_table SET id = 'archived_psector_link' WHERE id = 'archived_psector_link_traceability';


