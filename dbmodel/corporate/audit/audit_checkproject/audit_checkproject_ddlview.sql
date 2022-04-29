/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE VIEW audit.v_fidlog_aux AS
SELECT tstamp::date as date, (json_array_elements_text((a.source->>'expl_id')::json))::integer as expl_id, fprocess_type as type, fprocess_name, criticity, fcount as value
FROM audit.audit_fid_log a LEFT JOIN  ws.sys_fprocess  USING (fid) 
where isaudit is true
order by 1,2,3


CREATE OR REPLACE VIEW audit.v_fidlog_gam AS 
 SELECT ct.date,
    2 AS criticity,
    ct.omdata,
    ct.omtopology,
    ct.grafdata,
    ct.epaconfig,
    ct.epadata,
    ct.epatopology,
    ct.planconfig,
    COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) +COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0) AS total,
    (ct.length::numeric / 1000::numeric)::numeric(12,1) AS km,
    (100000::numeric * (COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) +COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0))::numeric / ct.length::numeric)::integer AS index
   FROM crosstab('
SELECT date, type, value FROM audit.v_fidlog where expl_id = 1 and criticity in (0,2)
'::text, 'VALUES (''Check om-data''), (''Check om-topology''), (''Check graf-data''),(''Check epa-config''), (''Check epa-data''),(''Check epa-topology''), (''Check plan-config''),(''length'')'::text) 
ct(date date, omdata integer, omtopology integer, grafdata integer, epaconfig integer, epadata integer, epatopology integer, planconfig integer, length integer)
UNION
 SELECT ct.date,
    3 AS criticity,
    ct.omdata,
    ct.omtopology,
    ct.grafdata,
    ct.epaconfig,
    ct.epadata,
    ct.epatopology,
    ct.planconfig,
    COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) +COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0) AS total,
    (ct.length::numeric / 1000::numeric)::numeric(12,1) AS km,
    (100000::numeric * (COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) +COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0))::numeric / ct.length::numeric)::integer AS index
   FROM crosstab('
SELECT date, type, value FROM audit.v_fidlog where expl_id = 1 and criticity in (0,3)
'::text, 'VALUES (''Check om-data''), (''Check om-topology''), (''Check graf-data''),(''Check epa-config''), (''Check epa-data''),(''Check epa-topology''), (''Check plan-config''),(''length'')'::text) 
ct(date date, omdata integer, omtopology integer, grafdata integer, epaconfig integer, epadata integer, epatopology integer, planconfig integer, length integer)
  ORDER BY 1, 2, 3, 4;

ALTER TABLE audit.v_fidlog_gam
  OWNER TO bgeoadmin;
GRANT ALL ON TABLE audit.v_fidlog_gam TO bgeoadmin;
GRANT ALL ON TABLE audit.v_fidlog_gam TO role_master;


CREATE OR REPLACE VIEW audit.v_fidlog_gam_index AS 
SELECT date, a.total as errors, b.total as warnings, a.km,  index_3 as err100km, index_2 as war100km, concat(index_3, '.', index_2) as index  FROM crosstab ('SELECT date, criticity, index  FROM audit.v_fidlog_gam'::text, 'VALUES (''2''), (''3'')'::text) as ct(date date, index_2 integer, index_3 integer)
join (SELECT date, total, km, index FROM audit.v_fidlog_gam WHERE criticity = 3) a USING (date)
join (SELECT date, total, km, index FROM audit.v_fidlog_gam WHERE criticity = 2) b USING (date)
where index_3 is not null and index_2 is not null;

GRANT ALL ON TABLE audit.v_fidlog_gam TO role_master;


  
  