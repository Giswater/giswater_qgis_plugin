
/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK (id::text = ANY (
    ARRAY['EXPANSIONTANK'::text, 'FILTER'::text, 'FLEXUNION'::text, 'FOUNTAIN'::text, 'GREENTAP'::text, 'HYDRANT'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'METER'::text,
    'NETELEMENT'::text, 'NETSAMPLEPOINT'::text, 'NETWJOIN'::text, 'PIPE'::text, 'PUMP'::text, 'REDUCTION'::text, 'REGISTER'::text, 'SOURCE'::text, 'TANK'::text, 'TAP'::text, 'VALVE'::text,
    'VARC'::text, 'WATERWELL'::text, 'WJOIN'::text, 'WTP'::text, 'LINK'::text, 'ELEMENT'::text, 'GENELEM'::text, 'FRELEM'::text, 'SERVCONNECTION'::text]));

ALTER TABLE om_waterbalance DROP CONSTRAINT om_waterbalance_pkey;
ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_pkey PRIMARY KEY (dma_id, startdate, enddate);

ALTER TABLE config_form_fields
ADD CONSTRAINT chk_widgets_requires_dv_querytext
CHECK (
  (widgettype NOT IN ('combo', 'typeahead')) OR dv_querytext IS NOT NULL
);
