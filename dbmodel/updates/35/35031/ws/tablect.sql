/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2023/01/02
ALTER TABLE IF EXISTS connec
    ADD CONSTRAINT connec_crmzone_id_fkey FOREIGN KEY (crmzone_id)
    REFERENCES crm_zone (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE sys_feature_cat
ADD CONSTRAINT sys_feature_cat_check CHECK (((id)::text = ANY ((
ARRAY['ELEMENT'::character varying, 'EXPANSIONTANK'::character varying, 'FILTER'::character varying, 'FLEXUNION'::character varying,
'FOUNTAIN'::character varying, 'GREENTAP'::character varying, 'HYDRANT'::character varying, 'JUNCTION'::character varying,
'MANHOLE'::character varying, 'METER'::character varying, 'NETELEMENT'::character varying, 'NETSAMPLEPOINT'::character varying,
'NETWJOIN'::character varying, 'PIPE'::character varying, 'PUMP'::character varying, 'REDUCTION'::character varying, 'REGISTER'::character varying,
'SOURCE'::character varying, 'TANK'::character varying, 'TAP'::character varying, 'VALVE'::character varying, 'VARC'::character varying,
'WATERWELL'::character varying, 'WJOIN'::character varying, 'WTP'::character varying, 'LINK'::character varying])::text[])));