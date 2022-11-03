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


CREATE VIEW audit.v_fidlog_aux_ws AS
SELECT * FROM 
(SELECT tstamp::date as date, (json_array_elements_text((a.source->>'expl_id')::json))::integer as expl_id,
((a.source->>'schema')::text) as schema,
fprocess_type as type, fprocess_name, criticity, fcount as value
FROM audit.audit_fid_log a LEFT JOIN  ws.sys_fprocess  USING (fid) 
where isaudit is true )a
WHERE schema::text='ws'
order by 1,2,3;

CREATE VIEW audit.v_fidlog_aux_ud AS
SELECT * FROM 
(SELECT tstamp::date as date, (json_array_elements_text((a.source->>'expl_id')::json))::integer as expl_id,
((a.source->>'schema')::text) as schema,
fprocess_type as type, fprocess_name, criticity, fcount as value
FROM audit.audit_fid_log a LEFT JOIN  ws.sys_fprocess  USING (fid) 
where isaudit is true )a
WHERE schema::text='ud'
order by 1,2,3;



CREATE OR REPLACE VIEW audit.v_fidlog_gam AS 
 SELECT ct.date,
    'WARNING' AS criticity,
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
    'ERROR' AS criticity,
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

GRANT ALL ON TABLE audit.v_fidlog_gam TO role_master;


CREATE OR REPLACE VIEW audit.v_fidlog_gam_index AS 
 SELECT ct.date,
    a.total AS errors,
    b.total AS warnings,
    a.km,
    ct.index_3 AS err100km,
    ct.index_2 AS war100km,
    concat(ct.index_3, '.', ct.index_2) AS index
   FROM crosstab('SELECT date, criticity, index  FROM audit.v_fidlog_gam'::text, 'VALUES (''WARNING''), (''ERROR'')'::text) ct(date date, index_2 integer, index_3 integer)
     JOIN ( SELECT v_fidlog_gam.date,
            v_fidlog_gam.total,
            v_fidlog_gam.km,
            v_fidlog_gam.index
           FROM audit.v_fidlog_gam
          WHERE v_fidlog_gam.criticity = 'ERROR'::text) a USING (date)
     JOIN ( SELECT v_fidlog_gam.date,
            v_fidlog_gam.total,
            v_fidlog_gam.km,
            v_fidlog_gam.index
           FROM audit.v_fidlog_gam
          WHERE v_fidlog_gam.criticity = 'WARNING'::text) b USING (date)
  WHERE ct.index_3 IS NOT NULL AND ct.index_2 IS NOT NULL;
GRANT ALL ON TABLE audit.v_fidlog_gam TO role_master;


CREATE or replace VIEW audit.v_log_gam AS
SELECT user_name,  count (*) , action, date FROM 
(SELECT user_name, substring(query,0,30)  as action, (substring(date_trunc('day',(tstamp))::text,0,12))::date AS date from audit.log
JOIN (SELECT unnest(username) username FROM ws.cat_manager WHERE id = 3)a ON user_name = username where  schema = 'ws')a
group by user_name, date, action
ORDER BY date desc;

GRANT ALL ON TABLE audit.v_log_gam TO role_master;


CREATE OR REPLACE VIEW audit.v_fidlog AS 
 SELECT ct.date,
    'WARNING' AS criticity,
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
SELECT date, type, value FROM audit.v_fidlog where criticity in (0,2)
'::text, 'VALUES (''Check om-data''), (''Check om-topology''), (''Check graf-data''),(''Check epa-config''), (''Check epa-data''),(''Check epa-topology''), (''Check plan-config''),(''length'')'::text) 
ct(date date, omdata integer, omtopology integer, grafdata integer, epaconfig integer, epadata integer, epatopology integer, planconfig integer, length integer)
UNION
 SELECT ct.date,
    'ERROR' AS criticity,
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
SELECT date, type, value FROM audit.v_fidlog where criticity in (0,3)
'::text, 'VALUES (''Check om-data''), (''Check om-topology''), (''Check graf-data''),(''Check epa-config''), (''Check epa-data''),(''Check epa-topology''), (''Check plan-config''),(''length'')'::text) 
ct(date date, omdata integer, omtopology integer, grafdata integer, epaconfig integer, epadata integer, epatopology integer, planconfig integer, length integer)
  ORDER BY 1, 2, 3, 4;

GRANT ALL ON TABLE audit.v_fidlog TO role_master;


CREATE OR REPLACE VIEW audit.v_fidlog_index AS 
 SELECT ct.date,
    a.total AS errors,
    b.total AS warnings,
    a.km,
    ct.index_3 AS err100km,
    ct.index_2 AS war100km,
    concat(ct.index_3, '.', ct.index_2) AS index
   FROM crosstab('SELECT date, criticity, index  FROM audit.v_fidlog_gam'::text, 'VALUES (''WARNING''), (''ERROR'')'::text) ct(date date, index_2 integer, index_3 integer)
     JOIN ( SELECT v_fidlog_gam.date,
            v_fidlog_gam.total,
            v_fidlog_gam.km,
            v_fidlog_gam.index
           FROM audit.v_fidlog_gam
          WHERE v_fidlog_gam.criticity = 'ERROR'::text) a USING (date)
     JOIN ( SELECT v_fidlog_gam.date,
            v_fidlog_gam.total,
            v_fidlog_gam.km,
            v_fidlog_gam.index
           FROM audit.v_fidlog_gam
          WHERE v_fidlog_gam.criticity = 'WARNING'::text) b USING (date)
  WHERE ct.index_3 IS NOT NULL AND ct.index_2 IS NOT NULL;
GRANT ALL ON TABLE audit.v_fidlog_gam TO role_master;




  
  