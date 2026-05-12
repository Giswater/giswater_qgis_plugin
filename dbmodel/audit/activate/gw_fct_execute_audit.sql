/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- Function: PARENT_SCHEMA.gw_fct_execute_foreign_audit(text, date)

-- DROP FUNCTION PARENT_SCHEMA.gw_fct_execute_foreign_audit(text, date);

CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_fct_execute_foreign_audit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE


    SELECT PARENT_SCHEMA.gw_fct_execute_foreign_audit($${"client":
    {"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"sourceSchema":"PARENT_SCHEMA", "auditDate":"10-09-2020"}}}$$)::text

*/

DECLARE
v_result text;
v_version text;
rec record;
v_feature_geom text;
v_feature_id text;
v_query text;
v_srid integer;
v_check_feature_id boolean;
v_text text[];
v_jsonfield JSON;
v_field text;
v_value text;
text text;
i integer=1;
n integer=1;
v_schemaname text;
v_columntype text;
v_idname text;
v_column_type_id text;
v_column_pkey text;
v_queryjson json;
v_source_schema text;
v_audit_date date;

BEGIN

--  Set search path to local schema
    SET search_path = "PARENT_SCHEMA", public;

    -- select config values
    SELECT  wsoftware,epsg  INTO v_version, v_srid FROM version order by 1 desc limit 1;

    v_source_schema = ((((p_data::JSON ->> 'data')::json ->> 'parameters')::json) ->>'sourceSchema')::boolean;
    v_audit_date = ((((p_data::JSON ->> 'data')::json ->> 'parameters')::json) ->>'auditDate')::boolean;

    FOR rec IN (SELECT * FROM (
    SELECT DISTINCT ON (query) * FROM foreign_audit.log  WHERE  table_name not ilike 've_%' and  table_name not ilike 'v_edit_%' and
    query not ilike '/*%' and date(tstamp) = v_audit_date) t ORDER BY id asc)
    LOOP

    v_schemaname = 'PARENT_SCHEMA';

    IF rec.table_name IN ('node','arc','connec','gully') THEN
        v_idname =  concat(rec.table_name,'_id');
    ELSE
        select concat(lower(type),'_id') into v_idname FROM sys_feature_class WHERE rec.table_name = concat('man_',lower(id));
    END IF;
    rec.query = replace(rec.query,v_source_schema,'PARENT_SCHEMA');

    raise notice 'rec.id,%',rec.id;

    --execute direct queries on tables - insert/ updates
    IF v_idname IS NOT NULL THEN
        --capture values of id and geometry
        IF rec.query ILIKE '%st_geomfromwkb%' or rec.query ILIKE '%the_geom%' THEN
            v_feature_geom = ((rec.new_value::json)->> 'the_geom')::text;
            v_feature_id = ((rec.new_value::json)->> concat('',v_idname,''))::text;
raise notice 'rec.query,%',rec.query;

    raise notice 'rec.table_name,%',rec.table_name;
        --direct update of geometry
        IF rec.action = 'U' AND rec.query ilike 'UPDATE%' AND position(rec.table_name in rec.query)>0 THEN
            rec.query = replace(rec.query,concat('st_geomfromwkb($1::bytea,',v_srid::text,')'),'$1'::text);

            EXECUTE ''||rec.query||''
            USING v_feature_geom,v_feature_id;

        --insert on parent tables
      ELSIF rec.action = 'I' AND rec.query ilike 'INSERT%' AND position(rec.table_name in rec.query)>0 and position(rec.table_name in rec.query)<40 THEN
       raise notice 'insert1';
            rec.query = split_part(replace(rec.query,concat('st_geomfromwkb($1::bytea,',v_srid::text,')'),'$1'::text),'RETURNING',1);

            EXECUTE 'SELECT '||v_feature_id||'::text IN (SELECT '||v_idname||' FROM '||rec.table_name||')'
            into v_check_feature_id;

            IF v_check_feature_id is false THEN

            EXECUTE ''||rec.query||''
            USING v_feature_geom,v_feature_id;
            END IF;

         --insert on man tables
        ELSIF rec.action = 'I' AND rec.query ilike 'INSERT%' AND rec.table_name ilike 'man_%' and rec.new_value is not null THEN
            raise notice 'insert2';
            v_query := 'UPDATE ' || quote_ident(rec.table_name) ||' SET ';

            select array_agg(row_to_json(a)) into v_text from json_each(rec.new_value)a;

                --   Get id column type
                EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
                    JOIN pg_class t on a.attrelid = t.oid
                    JOIN pg_namespace s on t.relnamespace = s.oid
                    WHERE a.attnum > 0 
                    AND NOT a.attisdropped
                    AND a.attname = $3
                    AND t.relname = $2 
                    AND s.nspname = $1
                    ORDER BY a.attnum'
                    USING v_schemaname, rec.table_name, v_idname
                    INTO v_column_type_id;
                    raise notice 'v_column_type_id,%',v_column_type_id;
                    raise notice 'v_text,%',v_text;

            FOREACH text IN ARRAY v_text LOOP

                SELECT v_text [i] into v_jsonfield;
                v_field:= (SELECT (v_jsonfield ->> 'key')) ;
                v_value := (SELECT (v_jsonfield ->> 'value')) ;

                EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(rec.table_name) || ' AND column_name = $2'
                    USING v_schemaname, v_field
                    INTO v_columntype;

                -- control column_type
                IF v_columntype IS NULL THEN
                    v_columntype='text';
                ELSIF v_columntype = 'USER-DEFINED' THEN
                    v_columntype='geometry';
                END IF;

            IF n=1 THEN
                v_query := concat (v_query, quote_ident(v_field) , ' = CAST(' , quote_nullable(v_value) , ' AS ' , v_columntype , ')');
            ELSIF i>1 THEN
                v_query := concat (v_query, ' , ',  quote_ident(v_field) , ' = CAST(' , quote_nullable(v_value) , ' AS ' , v_columntype , ')');
            END IF;
            n=n+1;
            --END IF;
            i=i+1;
            END LOOP;
            n=1;
            i=1;
            -- query text, final step
            v_query := v_query || ' WHERE ' || quote_ident(v_idname) || ' = CAST(' || quote_literal(v_feature_id) || ' AS ' || v_column_type_id || ')';
            EXECUTE v_query;
        END IF;

        ELSE
            EXECUTE 'SELECT a.attname
            FROM   pg_index i
            JOIN   pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            WHERE  i.indrelid = $1::regclass
            AND    i.indisprimary'
            USING rec.table_name
            INTO v_column_pkey;

            raise notice 'execute direct insert';
            EXECUTE ''||rec.query||' ON CONFLICT ('||v_column_pkey||') DO NOTHING';

        END IF;

    ELSE

            IF rec.query ILIKE '%gw_api_setvisit%' THEN
               raise notice 'execute direct gw_api_setvisit';
                v_queryjson = split_part(rec.query,'$$',2)::json;
                IF (((((((v_queryjson->> 'feature')::json)->>'data')::json)->>'fields')::json)->>'visit_id')::integer NOT IN  (select id from om_visit) THEN
                    EXECUTE ''||rec.query||'';
                END IF;
            ELSIF rec.query ILIKE '%gw_api_setvisitmanager%' THEN
            raise notice 'execute direct gw_api_setvisitmanager';
                v_queryjson = split_part(rec.query,'$$',2)::json;
                IF (((v_queryjson->> 'feature')::json)->>'lot_id')::integer NOT IN  (select id from om_visit_lot) THEN
                    EXECUTE ''||rec.query||'';
                END IF;
            ELSE
        IF rec.query ilike 'INSERT INTO%' THEN
                --execute functions
                EXECUTE 'SELECT a.attname
            FROM   pg_index i
            JOIN   pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            WHERE  i.indrelid = $1::regclass
            AND    i.indisprimary'
            USING rec.table_name
            INTO v_column_pkey;

        v_query = concat ('RETURNING ',v_column_pkey);
            rec.query = replace(rec.query, v_query,'');

            raise notice 'execute INSERT EXECUTE,%',rec.query;
            EXECUTE ''||rec.query||' ON CONFLICT ('||v_column_pkey||') DO NOTHING';
        ELSE
            raise notice 'execute EXECUTE,%',rec.query;
            EXECUTE ''||rec.query||'';
                END IF;
            END IF;
            END IF;
    END LOOP;

    --    Control nulls
    v_result := COALESCE(v_result, '[]');

    --  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{"result":' || v_result ||
                 '}'||
               '}'||
    '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;