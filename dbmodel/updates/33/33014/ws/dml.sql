/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM audit_cat_param_user WHERE id IN ('expansiontankcat_vdefault', 'filtercat_vdefault', 'flexunioncat_vdefault', 'fountaincat_vdefault', 'greentapcat_vdefault', 
							'hydrant_vdefault', 'junctioncat_vdefault', 'manholecat_vdefault', 'metercat_vdefault', 'netelementcat_vdefault', 'netsamplepointcat_vdefault', 
							'netwjoincat_vdefault', 'pipecat_vdefault', 'pumpcat_vdefault', 'reductioncat_vdefault', 'registercat_vdefault', 'sourcecat_vdefault', 
							'tankcat_vdefault', 'tapcat_vdefault', 'valvecat_vdefault', 'waterwellcat_vdefault', 'wjoincat_vdefault', 'wtpcat_vdefault');