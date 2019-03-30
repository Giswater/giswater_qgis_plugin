/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2919/03/29
INSERT INTO audit_cat_param_user VALUES ('inp_options_use_dma_pattern', 'epaoptions', 'Use dma standard pattern for non CRM simulations', 'role_epa', null, null, 'Use dma default pattern',  
NULL, NULL, TRUE, 15, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'boolean', 'check', TRUE, NULL, 'TRUE', 'grl_inpother_15', NULL, TRUE, NULL, NULL, NULL, null);
