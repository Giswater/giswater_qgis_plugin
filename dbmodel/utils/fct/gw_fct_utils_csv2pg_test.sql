-- Function: ws_inp.gw_fct_utils_pg2csv(integer, text)

-- DROP FUNCTION ws_inp.gw_fct_utils_pg2csv(integer, text);

CREATE OR REPLACE FUNCTION ws_inp.gw_fct_utils_pg2csv(
    p_pg2csvcat_id integer,
    p_path_aux text)
  RETURNS void AS
$BODY$DECLARE

rec_table record;
column_number integer;
id_last integer;
num_col_rec record;
num_column text;
result_id_aux varchar;
title_aux varchar;

BEGIN

    -- Search path
    SET search_path = "ws_inp", public;

    IF p_pg2csvcat_id=8 THEN

      --Delete previous
      DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=p_pg2csvcat_id;
      
      SELECT result_id INTO result_id_aux FROM inp_selector_result where cur_user=current_user;
      SELECT title INTO title_aux FROM inp_project_id where author=current_user;

      INSERT INTO temp_csv2pg (csv1,csv2pgcat_id) VALUES ('[TITLE]',p_pg2csvcat_id);
      INSERT INTO temp_csv2pg (csv1,csv2pgcat_id) VALUES (';Created by Giswater',p_pg2csvcat_id);
      INSERT INTO temp_csv2pg (csv1,csv2,csv2pgcat_id) VALUES (';Giswater, the open water','management tool.',p_pg2csvcat_id);
      INSERT INTO temp_csv2pg (csv1,csv2,csv2pgcat_id) VALUES (';Project name: ',title_aux, p_pg2csvcat_id);
      INSERT INTO temp_csv2pg (csv1,csv2,csv2pgcat_id) VALUES (';Result name: ',result_id_aux,p_pg2csvcat_id); 
      INSERT INTO temp_csv2pg (csv1,csv2pgcat_id) VALUES (NULL,p_pg2csvcat_id); 

      --node
      FOR rec_table IN SELECT * FROM sys_csv2pg_config WHERE pg2csvcat_id=p_pg2csvcat_id order by id
       LOOP
    -- insert header
          INSERT INTO temp_csv2pg (csv1,csv2pgcat_id) VALUES (NULL,p_pg2csvcat_id); 
          EXECUTE 'INSERT INTO temp_csv2pg(csv2pgcat_id,csv1) VALUES ('||p_pg2csvcat_id||','''|| rec_table.header_text||''');';


          INSERT INTO temp_csv2pg (csv2pgcat_id,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12) 
          SELECT p_pg2csvcat_id,rpad(concat(';',c1),20),rpad(c2,20),rpad(c3,20),rpad(c4,20),rpad(c5,20),rpad(c6,20),rpad(c7,20),rpad(c8,20),rpad(c9,20),rpad(c10,20),rpad(c11,20),rpad(c12,20)
          FROM crosstab('SELECT table_name::text,  data_type::text, column_name::text FROM information_schema.columns WHERE table_schema =''ws_inp'' and table_name='''||rec_table.tablename||'''::text') 
          AS rpt(table_name text, c1 text, c2 text, c3 text, c4 text, c5 text, c6 text, c7 text, c8 text, c9 text, c10 text, c11 text, c12 text);

          INSERT INTO temp_csv2pg (csv2pgcat_id) VALUES (8) RETURNING id INTO id_last;

          SELECT count(*)::text INTO num_column from information_schema.columns where table_name=rec_table.tablename AND table_schema='ws_inp';
  
          --add underlines    
              FOR num_col_rec IN 1..num_column
              LOOP
                  IF num_col_rec=1 then
                        EXECUTE 'UPDATE temp_csv2pg set csv1=rpad('';-------'',20) WHERE id='||id_last||';';
                  ELSE
                        EXECUTE 'UPDATE temp_csv2pg SET csv'||num_col_rec||'=rpad(''-------'',20) WHERE id='||id_last||';';
                  END IF;
              END LOOP;

    -- insert values

  CASE WHEN rec_table.tablename='vi_options' and (SELECT value FROM vi_options WHERE parameter='hydraulics') is null THEN
    EXECUTE 'INSERT INTO temp_csv2pg SELECT nextval(''temp_csv2pg_id_seq''::regclass),'||p_pg2csvcat_id||',current_user,'''||rec_table.tablename::text||''',*  FROM '||rec_table.tablename||' WHERE parameter!=''hydraulics'';';
  ELSE
          EXECUTE 'INSERT INTO temp_csv2pg SELECT nextval(''temp_csv2pg_id_seq''::regclass),'||p_pg2csvcat_id||',current_user,'''||rec_table.tablename::text||''',*  FROM '||rec_table.tablename||';';
  END CASE;
  
    --add formating - spaces
    FOR num_col_rec IN 1..num_column::integer
              LOOP
    IF num_col_rec < num_column::integer THEN
        EXECUTE 'UPDATE temp_csv2pg SET csv'||num_col_rec||'=rpad(csv'||num_col_rec||',20) WHERE source='''||rec_table.tablename||''';';
    END IF;
              END LOOP;
      END LOOP;

    --export to csv

        EXECUTE 'COPY (SELECT csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12 FROM temp_csv2pg WHERE csv2pgcat_id=8 and user_name=current_user order by id) 
        TO '''||p_path_aux||''' WITH (DELIMITER E''\t'', FORMAT CSV);';

    ELSE 
      RAISE EXCEPTION 'In order to export data use parameter 8';

    END IF;

    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_inp.gw_fct_utils_pg2csv(integer, text)
  OWNER TO postgres;
