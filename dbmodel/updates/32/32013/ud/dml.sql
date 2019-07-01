/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO audit_cat_param_user VALUES ('edit_gully_force_automatic_connect2network', 'config', 'If true, link will be automatically generated when inserting a new gully', 
			'role_edit', NULL, NULL, 'Automatic connect gully to network:', NULL, NULL, true, 8, 9, 'ud', false, NULL, NULL, NULL, false, 'boolean', 'check', false,
			NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL);
			
INSERT INTO audit_cat_param_user VALUES ('edit_gully_doublegeom', 'config', 'Parameter to configure automatic insert of polygon geometry for gully', 'role_edit', NULL, NULL, 
			'Gully double geometry:', NULL, NULL, true, 8, 10, 'ud', false, NULL, NULL, NULL, false, 'json', 'linetext', true, NULL, '{"status":"false","unitsFactor":"2"}', NULL, NULL, NULL, NULL, 
			NULL, NULL, NULL, false, NULL, NULL);

UPDATE inp_typevalue SET id='FROUDE', idval='FROUDE' WHERE id='FROUD';

