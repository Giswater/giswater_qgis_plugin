DROP FUNCTION sanejament.gw_fct_om_visit(integer, character varying);

CREATE OR REPLACE FUNCTION sanejament.gw_fct_om_visit(
    visitcat_aux integer,
    feature_type_aux character varying)
  RETURNS smallint AS
$BODY$
DECLARE
rec_table record;
arc_rec record;
node_rec record;
exception_var boolean;
return_int smallint;
id_last integer;
seccio_aux text;
tapa_aux text;



/*

PREVIS
1- La taula d'excel te que tenir només una fila capçalera. Els noms dels camps han de ser el que acordem i SEMPRE ELS MATEIXOS
2- Cal que per trams, FCC entregui el camp de cataleg de tram (arccat_id) que té en la bbdd inicial. Cal pensar qui modifica i com......


COM ACTUA L'EINA
BOTO 1
1. Formulari demanant cataleg de visita, tipus de element (arc/node) i ruta del fitxer. Cal parlar i definir el catàleg de visites (anual...)
2. En cas que el fitxer excel estigui malament (valors no numerics en camps numerics o bé catàlegs inexistents de arc per tram) peta.....
3. Crea una etiqueta de lot_id cada vegada que s'importa un fitxer i guarda tots els valors d'aquest en dues arcs/nodes on va acumulant valors...
4. Updateja a la taula de arc (y1/y2/arccat_id) els valors arribats del fitxer de forma automàtica guardant valors nous i vells en una taula (om_visit_review_arc)
5. Updateja a la taula de node (sander/ymax) els valors arribats del fitxer de forma automàtica guardant valors nous i vells en una taula (om_visit_review_node)
6. Insertar nous elements per a node (tapa, pates plastic, pastes ferro) i posar como a valors no ultims (is_last false) els valors de pates i tapa que pugues tenir aquell pou
7. Inserta registres de visita/event per a la resta d'atributs de node
8. Inserta registre de visita/event per a la resta d'atributs de arc
9. Reseteja el selector de dates amb els valors minim i màxim dels dos fitxers (trams / pous)

BOTO 2
1. Selector de dates. Permet veure per dates tot el que li passa a la xarxa


QUIN RESULTATS OBTENIM
--Consulta un per un (amb la info)

--Consulta agrupada (noves vistes) actua coordinadament amb el BOTO 2
1) Trams
        Visitats
	Sediments >0
	Estat estructural ni bo ni desconegut
	Observacions no nulles
2) Pous
        Visitats
        Sediments >0
	Estat estructural ni Bo ni Desconegut
	Observacions no nulles
	Estat tapa ni Bo ni Desconegut
	Pates a reposar

*/



BEGIN

-- Initializing
  SET search_path = "sanejament", public;
  SET datestyle=European;

  DELETE FROM temp_om_log;
  return_int:=0;
  PERFORM setval('sanejament.ext_om_visit_lot_id_seq', (  SELECT max(id)+1 FROM sanejament.ext_om_visit_lot) , true);


  
--ARCS
IF feature_type_aux='ARC' THEN

	-- comprovacio de cataleg de trams
	FOR rec_table IN SELECT * FROM temp_om_visit_arc
	LOOP
		SELECT id INTO seccio_aux FROM cat_arc WHERE id=rec_table.seccio;
		IF seccio_aux IS NULL THEN
			INSERT INTO temp_om_log (element, descript, row_id) VALUES ( rec_table.seccio, 'Cataleg de tram no catalogat en la fila.', rec_table.id);
			return_int=1;
		END IF;
	END LOOP;

		
	IF return_int=0 THEN
	
		-- insert into lot table
		INSERT INTO ext_om_visit_lot (visitcat_id) VALUES (visitcat_aux) RETURNING id INTO id_last;

		-- insert into lot_x_arc table
		INSERT INTO ext_om_visit_lot_arc 
		(dia,codi,inici,final,seccio,tipsec,mida,mida_x,material,res_nivell,res_tipus,est_general,est_volta,est_solera,est_tester,equip,observacions)
		SELECT dia,codi,inici,final,seccio,tipsec,mida,mida_x,material,res_nivell,res_tipus,est_general,est_volta,est_solera,est_tester,equip,observacions
		FROM temp_om_visit_arc;
		
		UPDATE ext_om_visit_lot_arc SET lot_id=id_last WHERE lot_id IS NULL;
			
		-- insert into review table (as a backup mode of old data)
		INSERT INTO om_visit_review_arc (arc_id, old_y1, old_y2, old_arccat_id, new_y1, new_y2, new_arccat_id, cur_user, lot_id) 
		SELECT arc_id, y1, y2, arccat_id, inici, final, seccio, equip, id_last FROM arc JOIN ext_om_visit_lot_arc ON arc_id=codi WHERE lot_id=id_last;	
	
			
		-- update dels valors de y1,y2,arccat_id
		UPDATE arc SET y1=inici, y2=final, arccat_id=seccio FROM temp_om_visit_arc WHERE codi=arc_id;
	
	
		-- Update visita
		FOR rec_table IN SELECT * FROM temp_om_visit_arc
		LOOP
			-- Insert into visit table and visit_x_feature tables
				INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(rec_table.dia::timestamp, rec_table.dia::timestamp, visitcat_aux, rec_table.equip) RETURNING id INTO id_last;
				INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last,rec_table.codi);
	
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
		
		RETURN return_int;
		
	ELSE 
		RETURN return_int;
	END IF;
	
	
	
	
--NODES
ELSIF feature_type_aux='NODE' THEN


		IF return_int=0 THEN

			-- insert into lot table
			INSERT INTO ext_om_visit_lot (visitcat_id) VALUES (visitcat_aux) RETURNING id INTO id_last;
	
			-- insert into lot_x_node table
			INSERT INTO ext_om_visit_lot_node
			(dia,codi,sorrer,total,tapa_tipus,tapa_estat,pates_poli,pates_ferr,pates_rep,res_nivell,res_tipus,est_general,est_solera,est_parets,equip,observacions)
			SELECT dia,codi,sorrer,total,tapa_tipus,tapa_estat,pates_poli,pates_ferr,pates_rep,res_nivell,res_tipus,est_general,est_solera,est_parets,equip,observacions
			FROM temp_om_visit_node;
			
			UPDATE ext_om_visit_lot_node SET lot_id=id_last WHERE lot_id IS NULL;
				
			-- insert into review table (as a backup mode of old data)
			INSERT INTO om_visit_review_node (node_id, old_sander, old_ymax, new_sander, new_ymax, cur_user, lot_id) 
			SELECT node_id, sander, ymax, sorrer, total, equip, id_last FROM node JOIN ext_om_visit_lot_node ON node_id=codi WHERE lot_id=id_last;	
	
		
			-- update dels valors de sander,ymax
			UPDATE node SET sander=sorrer, ymax=total FROM temp_om_visit_node WHERE codi=node_id;
		
			-- Update visita
			FOR rec_table IN SELECT * FROM temp_om_visit_node
			LOOP
				-- Insert into visit table and visit_x_feature tables
				INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(rec_table.dia::timestamp, rec_table.dia::timestamp, visitcat_aux, rec_table.equip) RETURNING id INTO id_last;
				INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last,rec_table.codi);
		
				-- Insert into event table
				--estat tapa
				INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatTapa', rec_table.tapa_estat, now());
				
				--pates reposar 
				INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'PatesReposar', rec_table.pates_rep, now());
				
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
			FOR rec_table IN SELECT * FROM temp_om_visit_node
			LOOP
				-- Updatejar valors actuals del pou com a is_last false
				UPDATE element SET is_last=FALSE FROM element_x_node WHERE element_x_node.element_id=element.element_id AND node_id=rec_table.codi;

				-- Insert tapa
				INSERT INTO element (element_id, elementcat_id, state, annotation, units) VALUES
				((SELECT nextval('urn_id_seq')), 'TAPA', 'ON_SERVICE', rec_table.tapa_tipus, 1) RETURNING element_id INTO id_last;
				INSERT INTO element_x_node (element_id, node_id) VALUES(id_last,rec_table.codi);

	
				-- Insert pates ferro
				INSERT INTO element (element_id, elementcat_id, state, units) VALUES
				((SELECT nextval('urn_id_seq')), 'PATE FERRO', 'ON_SERVICE', rec_table.pates_ferr) RETURNING element_id INTO id_last;
				INSERT INTO element_x_node (element_id, node_id) VALUES(id_last,rec_table.codi);
		
				-- Insert pates polipropile
				INSERT INTO element (element_id, elementcat_id, state, units) VALUES
				((SELECT nextval('urn_id_seq')), 'PATE PLASTIC', 'ON_SERVICE', rec_table.pates_poli) RETURNING element_id INTO id_last;
				INSERT INTO element_x_node (element_id, node_id) VALUES(id_last,rec_table.codi);
		
			END LOOP;
		
			RETURN return_int;
		ELSE
			RETURN return_int;
		END IF;
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION sanejament.gw_fct_om_visit(integer, character varying)
  OWNER TO postgres;
