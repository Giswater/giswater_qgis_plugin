DROP FUNCTION sanejament.gw_fct_om_visit_arc(integer, varchar);

CREATE OR REPLACE FUNCTION sanejament.gw_fct_om_visit(visitcat_aux integer, feature_type_aux varchar)
  RETURNS smallint AS
$BODY$
DECLARE
rec_table record;
exception_var boolean;
return_int smallint;

/*
-- per comentar amb la gemma:

Mecanisme:
1- Formulari demanant cataleg de visita, tipus de element (arc/node) i ruta del fitxer

Previs
1- La taula d'excel te que tenir només una fila capçalera. Els noms dels camps han de ser el que acordem
2- Cal que per trams, FCC entregui el camp de cataleg de tram (arccat_id) que té en la bbdd inicial

Sobre les dades
1- Cal parlar i definir el catàleg de visites
2- Que és update arc/node, que és element, que és visita (sobre tot pel que fa referència a pates a reposar)
3- Equip directament el numero que surt de FCC (o li posem una coletilla que posi FCC)


Sobre asistent
1- Missatge per pantalla en cas que la importació no hagi anat bé

 
SOBRE LES COSES QUE CAL FER A LA BBDD DESTÍ:

1) Fer unique constraint al camp om_visit_cat.short_descript
2) crear les tres taules:
	temp_om_arc_log
	temp_om_visit_arc
	temp_om_visit_node
	
3) Modificar catalegs
--parametres
EstatTapa
PatesReposar
NivellResidus
TipusResidus
EstatTester
EstatVolta

--elements
PATES POLIPROP.
PATES FERRO
TAPA

*/




BEGIN

-- Initializing
  SET search_path = "sanejament", public;

  DELETE FROM temp_om_arc_log;
  DELETE FROM temp_om_visit_arc;
  DELETE FROM temp_om_visit_node;
  return_int:=0;


--ARCS
IF feature_type_aux='ARC' THEN

	-- comprovacio de catalegs
	FOR rec_table IN SELECT * FROM temp_om_visit_arc
	LOOP
		SELECT id INTO seccio_aux FROM cat_arc WHERE id=rec_table.seccio
		IF seccio_aux IS NULL THEN
			INSERT INTO temp_om_log (row_id, descript, catalog_id) VALUES ( rec_table.id, 'Cataleg de tram no catalogat en la fila', rec_table)
			return_int=1;
		ELSIF
	END LOOP;

	-- comprovació que els valors de y1, y2 i res_nivell son numerics
	FOR rec_table IN SELECT * FROM temp_om_visit_arc
	LOOP
		IF seccio_aux IS NULL THEN
			INSERT INTO temp_om_log (row_id, descript, catalog_id) VALUES ( rec_table.id, 'Cataleg de tram no catalogat en la fila', rec_table)
			return_int=1;
		ELSIF
	END LOOP;
	
	
	
	-- update dels valors de y1,y2,arccat_id
	UPDATE arc SET y1=inici, y2=final, arccat_id=seccio FROM temp_om_visit_arc WHERE codi=arc_id;


	-- Update visita
	FOR rec_table IN * FROM temp_om_visit_arc
        LOOP
		-- Insert into visit table and visit_x_feature tables
        	INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(rec_table.dia, rec_table.dia, visitcat_aux, rec_table.equip) RETURNING id INTO id_last;
		INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last,rec_table.code);

		-- Insert into event table
		--residus
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'NivellResidus', rec_table.res_nivell, now());
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'TipusResidus', rec_table.res_tipus, now());
			    
		--estat estructural
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatGeneral', rec_table.est_general, now());
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatVolta', rec_table.est_volta, now());
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatSolera', rec_table.est_solera, now());
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatTester', rec_table.est_tester, now());
		
		--observacions
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'Observacions', rec_table.observacions, now());
		
        END LOOP;
	


--NODES
ELSE feature_type_aux='NODE' THEN	

 	-- update dels valors de sander,ymax
	UPDATE node SET sander=sorrer, ymax=total FROM temp_om_visit_node WHERE codi=node_id;

	-- Update visita
	FOR rec_table IN * FROM temp_om_visit_node
        LOOP
		-- Insert into visit table and visit_x_feature tables
        	INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(rec_table.dia, rec_table.dia, visitcat_aux, rec_table.equip) RETURNING id INTO id_last;
		INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last,rec_table.code);

		-- Insert into event table
       		--estat tapa
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatTapa', rec_table.tapa_estat, now());
		
		--pates reposar 
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'PatesReposar', rec_table.pates_reposar, now());
		
		--residus
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'NivellResidus', rec_table.res_nivell, now());
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'TipusResidus', rec_table.res_tipus, now());
			    
		--estat estructural
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatGeneral', rec_table.est_general, now());
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatSolera', rec_table.est_solera, now());
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatParets', rec_table.est_parets, now());

		--observacions
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'Observacions', rec_table.observacions, now());
		
        END LOOP;

	-- Update element
	FOR rec_table IN * FROM temp_om_visit_node
        LOOP
		-- Insert tapa
		INSERT INTO element (element_id, elementtype_id, annotation, num_elements) VALUES
		((SELECT nextval('urn_id_seq')), 'TAPA', rec_table.tapa_tipus, 1) RETURNING element_id INTO id_last;
		INSERT INTO element_x_node (element_id, node_id) VALUES(id_last,rec_table.codi);

		-- Insert pates ferro
		INSERT INTO element (element_id, elementtype_id, num_elements) VALUES
		((SELECT nextval('urn_id_seq')), 'PATES FERRO', pates_ferr) RETURNING element_id INTO id_last;
		INSERT INTO element_x_node (element_id, node_id) VALUES(id_last,rec_table.codi);

		-- Insert pates polipropile
		INSERT INTO element (element_id, elementtype_id, num_elements) VALUES
		((SELECT nextval('urn_id_seq')), 'PATES POLIPROP.', pates_poli) RETURNING element_id INTO id_last;
		INSERT INTO element_x_node (element_id, node_id) VALUES(id_last,rec_table.codi);

        END LOOP;

END IF;


RETURN return_int;

            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
