
/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;





ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK (id::text = ANY (
    ARRAY['ELEMENT'::text, 'EXPANSIONTANK'::text, 'FILTER'::text, 'FLEXUNION'::text, 'FOUNTAIN'::text, 'GREENTAP'::text, 'HYDRANT'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'METER'::text, 
    'NETELEMENT'::text, 'NETSAMPLEPOINT'::text, 'NETWJOIN'::text, 'PIPE'::text, 'PUMP'::text, 'REDUCTION'::text, 'REGISTER'::text, 'SOURCE'::text, 'TANK'::text, 'TAP'::text, 'VALVE'::text, 
    'VARC'::text, 'WATERWELL'::text, 'WJOIN'::text, 'WTP'::text, 'LINK'::text, 'GENELEMENT'::text, 'FLWREG'::text]));
