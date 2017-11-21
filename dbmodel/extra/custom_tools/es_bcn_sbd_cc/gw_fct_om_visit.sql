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
rec_val record;
rec_dif record;
codi_var varchar;

/*

PREVIS
1- La taula d'excel te que tenir només una fila capçalera. Els noms dels camps han de ser el que acordem i SEMPRE ELS MATEIXOS
2- Cal que per trams, FCC entregui el camp de cataleg de tram (arccat_id) que té en la bbdd inicial. Cal pensar qui modifica i com......


COM ACTUA L'EINA
BOTO 1
1. Formulari demanant cataleg de visita, tipus de element (arc/node) i ruta del fitxer. Cal parlar i definir el catàleg de visites (anual...)
2. Per la importació es fan una serie de verificacions:
	2.1 Cal que els camps del csv han de tenir exactament els noms acordats.
	2.2 El nom dels fitxers pots ser el que es vulgui atès que el codi identifica el tercer camp (sorrer / inici) per saber si és un (pou / tram).
	2.3 En cas que els valors del fitxer estiguin malament (valors no numerics en camps numerics ) peta.....
	2.4 En cas que s'intenti reimportar un excel que tingui un sol valor (codi / dia) igual peta. 
	    No pot ser que s'hagi inspeccionat dos vegades el mateix pou/tram el mateix dia en fitxers diferents
5. Es crea una etiqueta de lot_id cada vegada que s'importa un fitxer i guarda tots els valors d'aquest en dues arcs/nodes on va acumulant valors...
6. Es genera un primer mapa on es veuen el total dels elements inspeccionats
7. Es genera un segon mapa (capes v_edit_om_review_arc & v_edit_om_review_node) on es veuen les diferencies d'inventari que amb els llindars que s'hagin configurat. 
   En aquest mapa l'usuari ha d'anar validant un per un els elements ( cal modificar els valors new_ que es consideri i posar en true el camp
8. S'inserten nous elements per a node (tapa, pates plastic, pastes ferro) i posar como a valors no ultims (is_last false) els valors de pates i tapa que pugues tenir aquell pou
9. S'inserten els nous registres de visita/event per a la resta d'atributs de node
10.S'inserten els nous registres de visita/event per a la resta d'atributs de arc
11.Es reseteja el selector de dates amb els valors minim i màxim dels dos fitxers (trams / pous)

BOTO 2
1. Selector de dates. Permet veure per dates tot el que li passa a la xarxa
2. Fa un refresh del canvas

BOTO 3
1. Permet configurar els llindars de revisió dels elements d'inventari


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

  return_int:=0;
  PERFORM setval('sanejament.ext_om_visit_lot_id_seq', (  SELECT max(id)+1 FROM sanejament.ext_om_visit_lot) , true);
  SELECT * INTO rec_dif FROM om_visit_review_config;


  
--ARCS
IF feature_type_aux='ARC' THEN

	--Control de inserció de registres amb dades repetides (mateix codi i dia no pot ser)
	FOR rec_table IN SELECT * FROM temp_om_visit_arc
	LOOP
		SELECT codi INTO codi_var FROM ext_om_visit_lot_arc where codi=rec_table.codi AND dia=rec_table.dia;
		IF codi_var is not null THEN
			RAISE EXCEPTION 'Hi ha dades en aquest fitxer que ja s''han entrat amb anterioritat. Almenys un registre amb valors (codi, dia) iguals ja existeix a la base de dades. Reviseu-ho abans de continuar';
		END IF;
	END LOOP;
		

	-- insert into lot table
	INSERT INTO ext_om_visit_lot (visitcat_id) VALUES (visitcat_aux) RETURNING id INTO id_last;

	-- insert into lot_x_arc table
	INSERT INTO ext_om_visit_lot_arc 
	(dia,codi,inici,final,seccio,tipsec,mida,mida_x,material,res_nivell,res_tipus,est_general,est_volta,est_solera,est_tester,equip,observacions)
	SELECT dia,codi,inici,final,seccio,tipsec,mida,mida_x,material,res_nivell,res_tipus,est_general,est_volta,est_solera,est_tester,equip,observacions
	FROM temp_om_visit_arc;
		
	UPDATE ext_om_visit_lot_arc SET lot_id=id_last WHERE lot_id IS NULL;

	-- insert into review table (to validate by user and as backup information)
	INSERT INTO om_visit_review_arc (arc_id, old_y1, new_y1, old_y2, new_y2, arccat_id, old_shape, new_shape, old_geom1, 
	new_geom1, old_geom2, new_geom2, old_matcat_id, new_matcat_id, cur_user, lot_id) 
	SELECT arc_id, y1, inici, y2, final, arccat_id, shape, upper(unaccent(tipsec)), geom1, mida, geom2, mida_x, upper(unaccent(matcat_id)), upper(unaccent(material)), equip, id_last 
	FROM arc
		JOIN cat_arc ON cat_arc.id=arccat_id
		JOIN ext_om_visit_lot_arc ON arc_id=codi WHERE lot_id=id_last;	

		
	-- Automatic validation of data
	FOR rec_val IN SELECT * FROM om_visit_review_arc WHERE lot_id=id_last
	LOOP
		IF abs(rec_val.old_y1-rec_val.new_y1)>rec_dif.y1 OR
	 	   abs(rec_val.old_y2-rec_val.new_y2)>rec_dif.y2 OR
	 	   abs(rec_val.old_geom1-rec_val.new_geom1)>rec_dif.geom1 OR
		   abs(rec_val.old_geom2-rec_val.new_geom2)>rec_dif.geom2 OR
		   rec_val.old_matcat_id!= rec_val.new_matcat_id OR
		   rec_val.old_shape != rec_val.new_shape	THEN
			UPDATE om_visit_review_arc SET is_validated=FALSE WHERE arc_id=rec_val.arc_id AND lot_id=id_last;
			return_int=return_int+1;
		ELSE
			UPDATE om_visit_review_arc SET is_validated=TRUE WHERE arc_id=rec_val.arc_id AND lot_id=id_last;

		END IF;
	END LOOP;
		   
	
	-- Update visita
	FOR rec_table IN SELECT * FROM temp_om_visit_arc
	LOOP

		-- Insert into visit table and visit_x_feature tables
		INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(rec_table.dia::timestamp, rec_table.dia::timestamp, visitcat_aux, rec_table.equip) RETURNING id INTO id_last;

		UPDATE om_visit_x_arc SET is_last=FALSE where arc_id=rec_table.codi;
		INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last,rec_table.codi);
				
		-- Insert into event table
		--residus
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'NivellResidus', rec_table.res_nivell, rec_table.dia::timestamp);
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'TipusResidus', rec_table.res_tipus, rec_table.dia::timestamp);
					
		--estat estructural
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatGeneral', rec_table.est_general, rec_table.dia::timestamp);
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatVolta', rec_table.est_volta, rec_table.dia::timestamp);
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatSolera', rec_table.est_solera, rec_table.dia::timestamp);
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatTester', rec_table.est_tester, rec_table.dia::timestamp);
			
		--observacions
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'Observacions', rec_table.observacions, rec_table.dia::timestamp);
			
	END LOOP;
		
	
--NODES
ELSIF feature_type_aux='NODE' THEN

	--Control de inserció de registres amb dades repetides (mateix codi i dia no pot ser)
	FOR rec_table IN SELECT * FROM temp_om_visit_node
	LOOP
		SELECT codi INTO codi_var FROM ext_om_visit_lot_node where codi=rec_table.codi AND dia=rec_table.dia;
		IF codi_var is not null THEN
			RAISE EXCEPTION 'Hi ha dades en aquest fitxer que ja s''han entrat amb anterioritat.  Almenys un registre amb valors (codi, dia) iguals ja existeix a la base de dades. Reviseu-ho abans de continuar';
		END IF;
	END LOOP;
		

	-- insert into lot table
	INSERT INTO ext_om_visit_lot (visitcat_id) VALUES (visitcat_aux) RETURNING id INTO id_last;
	
	-- insert into lot_x_node table
	INSERT INTO ext_om_visit_lot_node
	(dia,codi,sorrer,total,tapa_tipus,tapa_estat,pates_poli,pates_ferr,pates_rep,res_nivell,res_tipus,est_general,est_solera,est_parets,equip,observacions)
	SELECT dia,codi,sorrer,total,tapa_tipus,tapa_estat,pates_poli,pates_ferr,pates_rep,res_nivell,res_tipus,est_general,est_solera,est_parets,equip,observacions
	FROM temp_om_visit_node;
	
	UPDATE ext_om_visit_lot_node SET lot_id=id_last WHERE lot_id IS NULL;
		
	-- insert into review table (to validate by user and as backup information)
	INSERT INTO om_visit_review_node (node_id, old_sander, new_sander, old_ymax, new_ymax, cur_user, lot_id) 
	SELECT node_id, sander, sorrer, ymax, total, equip, id_last FROM node JOIN ext_om_visit_lot_node ON node_id=codi WHERE lot_id=id_last;	

	-- Automatic validation of data
	FOR rec_val IN SELECT * FROM om_visit_review_node WHERE lot_id=id_last
	LOOP
		IF abs(rec_val.old_sander-rec_val.new_sander)>rec_dif.sander OR
	 	   abs(rec_val.old_ymax-rec_val.new_ymax)>rec_dif.ymax THEN
			UPDATE om_visit_review_node SET is_validated=FALSE WHERE node_id=rec_val.node_id AND lot_id=id_last;
			return_int=return_int+1;
			
		ELSE
			UPDATE om_visit_review_node SET is_validated=TRUE WHERE node_id=rec_val.node_id AND lot_id=id_last;

		END IF;
	END LOOP;

		
	-- Update visita
	FOR rec_table IN SELECT * FROM temp_om_visit_node
	LOOP
		-- Insert into visit table and visit_x_feature tables
		INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(rec_table.dia::timestamp, rec_table.dia::timestamp, visitcat_aux, rec_table.equip) RETURNING id INTO id_last;

		UPDATE om_visit_x_node SET is_last=FALSE where node_id=rec_table.codi;
		INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last,rec_table.codi);

		-- Insert into event table
		--estat tapa
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatTapa', rec_table.tapa_estat, rec_table.dia::timestamp);
		
		--pates reposar 
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'PatesReposar', rec_table.pates_rep, rec_table.dia::timestamp);
	
		--residus
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'NivellResidus', rec_table.res_nivell, rec_table.dia::timestamp);
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'TipusResidus', rec_table.res_tipus, rec_table.dia::timestamp);
				
		--estat estructural
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatGeneral', rec_table.est_general, rec_table.dia::timestamp);
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatSolera', rec_table.est_solera, rec_table.dia::timestamp);
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'EstatParets', rec_table.est_parets, rec_table.dia::timestamp);

		--observacions
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, 'Observacions', rec_table.observacions, rec_table.dia::timestamp);
		
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

END IF;

PERFORM sanejament.gw_fct_om_visit_end();

RETURN return_int;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION sanejament.gw_fct_om_visit(integer, character varying)
  OWNER TO postgres;
