/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = audit, public, pg_catalog;

CREATE or replace VIEW audit.v_log AS
SELECT insert_by,  count (*) , action, date FROM
(SELECT insert_by, substring(query,0,30)  as action, (substring(date_trunc('day',(tstamp))::text,0,12))::date AS date from audit.log)a
group by insert_by, date, action
ORDER BY date desc;

GRANT ALL ON TABLE audit.v_log TO role_plan;


CREATE OR REPLACE VIEW audit.v_fidlog_aux
AS WITH last_date AS (
         SELECT max(afl.tstamp) as tstamp, source->>'schema' as schema
           FROM audit.audit_fid_log afl
           group by source ->>'schema'
        )
 SELECT a.tstamp::date AS date,
    a.source ->> 'schema' AS schema,
    a.type,
    a.fprocess_name,
    a.criticity,
    a.fcount AS value
   FROM audit.audit_fid_log a,
    last_date
  WHERE a.tstamp = last_date.tstamp and a.source->>'schema' = last_date.schema
  ORDER BY a.tstamp, (a.source ->> 'schema'), a.type;

GRANT ALL ON TABLE v_fidlog_aux TO role_admin;
GRANT INSERT, SELECT ON TABLE v_fidlog_aux TO role_basic;


CREATE OR REPLACE VIEW v_fidlog
AS SELECT v_fidlog_aux.date,
    v_fidlog_aux.schema,
        CASE
            WHEN v_fidlog_aux.type IS NULL THEN 'length'::character varying(100)
            ELSE v_fidlog_aux.type::character varying(100)
        END AS type,
    v_fidlog_aux.criticity,
    sum(v_fidlog_aux.value)::integer AS value
   FROM v_fidlog_aux
  GROUP BY v_fidlog_aux.type, v_fidlog_aux.criticity, v_fidlog_aux.date, v_fidlog_aux.schema
  ORDER BY v_fidlog_aux.date, v_fidlog_aux.schema, (
        CASE
            WHEN v_fidlog_aux.type IS NULL THEN 'length'::character varying(100)
            ELSE v_fidlog_aux.type::character varying(100)
        END);

GRANT ALL ON TABLE v_fidlog TO role_admin;
GRANT INSERT, SELECT ON TABLE v_fidlog TO role_basic;



CREATE OR REPLACE VIEW audit.v_fidlog_table
AS SELECT ct.date_schema[1]::date AS date,
    ct.date_schema[2] AS schema,
    'WARNING'::text AS criticity,
    ct.omdata,
    ct.omtopology,
    ct.grafdata,
    ct.epaconfig,
    ct.epadata,
    ct.epatopology,
    ct.planconfig,
    COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) + COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0) AS total,
    (ct.length::numeric / 1000::numeric)::numeric(12,1) AS km,
    (100000::numeric * (COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) + COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0))::numeric / ct.length::numeric)::integer AS index
   FROM crosstab('
SELECT ARRAY[date::text, schema], type, value FROM audit.v_fidlog where criticity in (0,2)
'::text, 'VALUES (''Check om-data''), (''Check om-topology''), (''Check graf-data''),(''Check epa-config''), (''Check epa-data''),(''Check epa-topology''), (''Check plan-config''),(''length'')'::text) ct(date_schema text[], omdata integer, omtopology integer, grafdata integer, epaconfig integer, epadata integer, epatopology integer, planconfig integer, length integer)
UNION
 SELECT ct.date_schema[1]::date AS date,
    ct.date_schema[2] AS schema,
    'ERROR'::text AS criticity,
    ct.omdata,
    ct.omtopology,
    ct.grafdata,
    ct.epaconfig,
    ct.epadata,
    ct.epatopology,
    ct.planconfig,
    COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) + COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0) AS total,
    (ct.length::numeric / 1000::numeric)::numeric(12,1) AS km,
    (100000::numeric * (COALESCE(ct.omdata, 0) + COALESCE(ct.omtopology, 0) + COALESCE(ct.grafdata, 0) + COALESCE(ct.epaconfig, 0) + COALESCE(ct.epadata, 0) + COALESCE(ct.epatopology, 0) + COALESCE(ct.planconfig, 0))::numeric / ct.length::numeric)::integer AS index
   FROM crosstab('
SELECT ARRAY[date::text, schema], type, value FROM audit.v_fidlog where criticity in (0,3)
'::text, 'VALUES (''Check om-data''), (''Check om-topology''), (''Check graf-data''),(''Check epa-config''), (''Check epa-data''),(''Check epa-topology''), (''Check plan-config''),(''length'')'::text) ct(date_schema text[], omdata integer, omtopology integer, grafdata integer, epaconfig integer, epadata integer, epatopology integer, planconfig integer, length integer)
  ORDER BY 1, 2, 3, 4;

GRANT ALL ON TABLE v_fidlog TO role_admin;
GRANT INSERT, SELECT ON TABLE v_fidlog TO role_basic;


CREATE OR REPLACE VIEW audit.v_fidlog_index
AS SELECT ct.date_schema[1]::date AS date,
    ct.date_schema[2] AS schema,
    a.total AS errors,
    b.total AS warnings,
    a.km,
    ct.index_3 AS err100km,
    ct.index_2 AS war100km,
    concat(ct.index_3, '.', ct.index_2) AS index
   FROM crosstab('SELECT ARRAY[date::text, schema], criticity, index  FROM audit.v_fidlog_table'::text, 'VALUES (''WARNING''), (''ERROR'')'::text) ct(date_schema text[], index_2 integer, index_3 integer)
     JOIN ( SELECT v_fidlog_table.date,
            v_fidlog_table.schema,
            v_fidlog_table.total,
            v_fidlog_table.km,
            v_fidlog_table.index
           FROM audit.v_fidlog_table
          WHERE v_fidlog_table.criticity = 'ERROR'::text) a ON a.date = ct.date_schema[1]::date AND a.schema = ct.date_schema[2]
     JOIN ( SELECT v_fidlog_table.date,
            v_fidlog_table.schema,
            v_fidlog_table.total,
            v_fidlog_table.km,
            v_fidlog_table.index
           FROM audit.v_fidlog_table
          WHERE v_fidlog_table.criticity = 'WARNING'::text) b ON b.date = ct.date_schema[1]::date AND b.schema = ct.date_schema[2]
  WHERE ct.index_3 IS NOT NULL AND ct.index_2 IS NOT NULL;

GRANT ALL ON TABLE v_fidlog_index TO role_admin;
GRANT INSERT, SELECT ON TABLE v_fidlog_index TO role_basic;