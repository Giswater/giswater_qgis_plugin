/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;


SET search_path = "SCHEMA_NAME", public, pg_catalog;


--
-- TOC entry 1518 (class 1255 OID 151956)
-- Name: gr_topology_delete_river(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_topology_delete_river"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
--Function created modifying "tgg_functionborralinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 
 
DECLARE 
	querystring Varchar; 
	nodosrec Record; 
	nodosactualizados Integer; 

BEGIN 
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	nodosactualizados := 0; 
 
	querystring := 'SELECT nodos.' || quote_ident ('OBJECTID') || ' AS ' || quote_ident ('OBJECTID') || ', nodos.numarcs AS numarcs FROM '
			|| quote_ident ('NodesTable') || ' nodos WHERE nodos.' || quote_ident('OBJECTID') || ' = ' 
			|| OLD.fromnode || ' OR nodos.' || quote_ident('OBJECTID') || ' = ' || OLD.tonode; 

INSERT INTO log VALUES ('gr_test()',querystring,CURRENT_TIMESTAMP);
			

	FOR nodosrec IN EXECUTE querystring
	LOOP
		nodosactualizados := nodosactualizados + 1; 

		IF (nodosrec.numarcs <= 1) THEN 
			EXECUTE 'DELETE FROM '|| quote_ident ('NodesTable') || ' WHERE ' || quote_ident('OBJECTID') || ' = ' || nodosrec."OBJECTID"; 
		ELSE 
			EXECUTE 'UPDATE ' || quote_ident('NodesTable') || ' SET numarcs = numarcs - 1 WHERE ' || quote_ident('OBJECTID') || ' = ' || nodosrec."OBJECTID"; 
		END IF; 

	END LOOP; 

	RETURN OLD; 
END;$$;


--
-- TOC entry 1519 (class 1255 OID 151957)
-- Name: gr_topology_insert_river(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_topology_insert_river"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$ 

--Function created modifying "tgg_functioninsertlinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 

DECLARE 

	loopquery Varchar; 
	nodeRecord1 Record; 
	nodeRecord2 Record; 
	geomlin public.geometry; 
	simplefeature Record; 
	geomfrag public.geometry; 
	elemfeature Record; 
	elemgeom1 public.geometry; 
	querystringUPDATE Varchar; 
	querystringUPDATEREACH Varchar;
	querystring Varchar; 
	querystringinicial Varchar; 
	ngeoms Integer; 
	unionall public.geometry; 
	array_len Integer; 
	gids Integer[];
	combinedName Varchar;
	combinedNames Varchar[];
 
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

/* 
Esta funcion varia su comportamiento en funcion desde don de ha sido llamada. Para ello analiza el valor de New.fromnode. 
Si fromnode es NULL, entonces se acepta que fue llamada por un comando SQL Insert ejecutado por el usuario. 
Si fromnode es -1, entonces fue llamada por el comando SQL Insert ejecutado dentro de 1a funcion gr_update_river(), 
que a su vez fue llamada tras la ejecucion de un comando SQL Update dentro de la funcion gr_insert_river(). 

Si fromnode es -3, entonces fue llamada por el 
comando SQL Insert ejecutado dentro de la funcion gr_update_river, que a su vez fue llamada tras la ejecucion de un comando SQL Update 
par el usuario. 

Si fromnode es -2, entonces gr_insert_river fue llamada por el 
comando SQL Insert ejecutado dentro de la funcion gr_insert_river(). 
*/

	IF (NEW.fromnode is NULL OR NEW.fromnode = -1 OR NEW.fromnode = -3) THEN 
		querystring:= 'INSERT INTO river VALUES ($1.*)'; 
		querystringUPDATE:= 'UPDATE river SET fromnode = -1 WHERE gid = $1'; 
		querystringUPDATEREACH:= 'UPDATE river SET reachcode = concat(reachcode , $2) WHERE gid = $1'; 
		querystringinicial:= 'SELECT * FROM river t1 WHERE ST_EXPAND ($1,1.0
					) && t1.geom AND t1.gid <> $2 AND (NOT gr_topology_cross(t1.geom, $1)) AND ST_DISTANCE(t1.geom, $1) <= 1.0'; 

		ngeoms:= 0; 
		unionall:= ST_startpoint(ST_LineMerge(NEW.geom)); 

		FOR elemfeature in EXECUTE querystringinicial USING ST_LineMerge(NEW.geom), NEW.gid LOOP 
			ngeoms:= ngeoms + 1; 
			unionall:= ST_Union (unionall, elemfeature.geom); 
			gids:= array_append (gids, elemfeature.gid); 

			combinedName = elemfeature.reachcode;
			combinedNames:= array_append (combinedNames, combinedName); 
			
		END LOOP; 

--		ngeoms sera mayor de cero si la geometria insertada interseca 
--		con alguna otra geometria. 
 
		IF (ngeoms > 0) THEN 
--			mediante e1 comando ST_Snap (a partir de PostGIS 2.0) se evitan 
--			errores tipo TopologyException de PostGIS (desde GEOS). 
			NEW.geom:= ST_multi(ST_Snap(ST_LineMerge(NEW.geom), unionall, 1.0)); 
			geomfrag:= ST_Difference(ST_LineMerge(NEW.geom), unionall); 

			IF (geomfrag IS NOT NULL) THEN 
				ngeoms:= 0; 
				FOR elemgeom1 IN SELECT (st_dump(geomfrag)).geom
				LOOP 
					ngeoms:= ngeoms + 1;
					
					simplefeature      := NEW; 
					simplefeature.geom := ST_multi(elemgeom1); 
					simplefeature.gid  := nextval('river_gid_seq'); 

--					marca e1 nodo inicia1 a -2 
					simplefeature.fromnode:= -2; 

--					Esta funcion lanzara de nuevo el disparador INSERT saltando 
--					de forma recursiva a tggFunction_insertlinea 
					EXECUTE querystring using simplefeature; 
					EXECUTE querystringUPDATEREACH using simplefeature.gid, combinedNames[ngeoms];


				END LOOP; 
			END IF;
 
--			Si este disparador ha sido invocado desde 
			IF (NEW.fromnode IS NULL OR NEW.fromnode = -3) THEN 
				array_len:= array_upper(gids, 1); 

				FOR i IN 1 .. array_len LOOP 
--					Esta funcion lanzara el disparador UPDATE pero con la marca -2 
--					para que el disparador UPDATE sepa que viene de aqui 
					EXECUTE querystringUPDATE using gids[i]; 
				END LOOP; 
			END IF; 

--			Anula la inserccion 
			RETURN NULL; 
		END IF; 
	END IF; 

--	Control de lineas de longitud 0
	IF ST_distance(ST_startpoint(ST_LineMerge(NEW.geom)),ST_endpoint(ST_LineMerge(NEW.geom))) > 0.5 THEN

--		Solo cuando New.nodoinicial es -2, 0 en el caso en e1 que la geometria 
--		insertada no interseque con ninguna geometria en 1a tabla (ngeoms = 0) 
		nodeRecord1  := gr_topology_check_node (ST_startpoint(ST_LineMerge(NEW.geom))); 
		NEW.fromnode := nodeRecord1.nodegid; 
		nodeRecord2  := gr_topology_check_node (ST_endpoint(ST_LineMerge(NEW.geom))); 
		NEW.tonode   := nodeRecord2.nodegid; 

--		modifica los puntos inicial y final de la linea para que coincida con los 
--		nodos (debido a la tolerancia) 
		NEW.geom := ST_multi(ST_SetPoint(ST_SetPoint(ST_LineMerge(NEW.geom), 0, nodeRecord1.nodegeom), ST_NPoints(ST_LineMerge(NEW.geom)) - 1, nodeRecord2.nodegeom)); 

		RETURN NEW; 
	ELSE
		RETURN NULL;
	END IF;

END;$$;


--
-- TOC entry 1520 (class 1255 OID 151959)
-- Name: gr_topology_update_river(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_topology_update_river"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$--Function created modifying "tgg_functionactualizalinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 

DECLARE 
	querystringdelete Varchar; 
	querystringINSERT Varchar; 
	marca Integer; 

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	querystringdelete:= 'DELETE FROM river WHERE gid = $1'; 
	querystringINSERT:= 'INSERT INTO river VALUES ($1.*)';

	marca:= 0; 

	IF (NEW.fromnode = -1) THEN 
		marca:= -1; 
	ELSIF (ST_ASEWKB(OLD.geom) <> ST_ASEWKB(NEW.geom)) THEN 
		marca:= -3; 
	END IF; 

	IF ( marca <> 0 ) THEN 
		EXECUTE querystringdelete USING OLD.gid; 

--		New.nodoinicial valdra -1, marcando si esta funcion ha sido a su 
--		vez invocada previamente tras la ejecuci6n del coman do SQL Update dentro 
--		de la funcion gr_insert_river 

--		New.nodoinicial va1dra -3, marcando si esta funcion ha side invocada 
--		por un comando SQL Update introducido por el usuario. 

		NEW.fromnode:= marca; 
		EXECUTE querystringINSERT using NEW; 

--		Anula la actualizaci6n 
		RETURN NULL; 
	END IF; 

--	El 'usuario no puede cambiar el valor de los nodos de forma manual 
	NEW.fromnode:= OLD.fromnode; 
	NEW.tonode:= OLD.tonode; 

RETURN NEW; 

END;$$;


--
-- TOC entry 1512 (class 1255 OID 151960)
-- Name: gr_update_banks_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_update_banks_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
   BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

      IF TG_OP = 'INSERT' THEN
        INSERT INTO  banks VALUES(DEFAULT,DEFAULT,DEFAULT,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE banks SET geom=NEW.geom WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM banks WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$$;


--
-- TOC entry 1521 (class 1255 OID 151961)
-- Name: gr_update_flowpaths_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_update_flowpaths_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

      IF TG_OP = 'INSERT' THEN
        INSERT INTO  flowpaths VALUES(DEFAULT,DEFAULT,NEW.linetype,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE flowpaths SET geom=NEW.geom, linetype=NEW.linetype WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM flowpaths WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$$;


--
-- TOC entry 1522 (class 1255 OID 151962)
-- Name: gr_update_nodestable(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_update_nodestable"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN

	NEW."X"=ST_X(NEW.geom);
	NEW."Y"=ST_Y(NEW.geom);
	NEW."Z"=0.0;
	NEW."NodeID" = NEW."OBJECTID";
	RETURN NEW;

END;$$;


--
-- TOC entry 1523 (class 1255 OID 151963)
-- Name: gr_update_river_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_update_river_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

      IF TG_OP = 'INSERT' THEN
        INSERT INTO  river VALUES(DEFAULT,DEFAULT,DEFAULT,NEW.rivercode,NEW.reachcode,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE river SET geom=NEW.geom,rivercode=NEW.rivercode,reachcode=NEW.reachcode WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM river WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$$;


--
-- TOC entry 1524 (class 1255 OID 151964)
-- Name: gr_update_xscutlines_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE OR REPLACE FUNCTION "gr_update_xscutlines_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

      IF TG_OP = 'INSERT' THEN
        INSERT INTO  xscutlines VALUES(DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,NEW.nodename,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE xscutlines SET geom=NEW.geom,nodename=NEW.nodename WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM xscutlines WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;$$;


--
-- TOC entry 3666 (class 2620 OID 152165)
-- Name: gr_delete_river_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_delete_river_trigger" BEFORE DELETE ON "river" FOR EACH ROW EXECUTE PROCEDURE "gr_topology_delete_river"();


--
-- TOC entry 3667 (class 2620 OID 152166)
-- Name: gr_insert_river_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_insert_river_trigger" BEFORE INSERT ON "river" FOR EACH ROW EXECUTE PROCEDURE "gr_topology_insert_river"();


--
-- TOC entry 3669 (class 2620 OID 152167)
-- Name: gr_update_banks_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_banks_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_banks" FOR EACH ROW EXECUTE PROCEDURE "gr_update_banks_view"();


--
-- TOC entry 3670 (class 2620 OID 152168)
-- Name: gr_update_flowpaths_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_flowpaths_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_flowpaths" FOR EACH ROW EXECUTE PROCEDURE "gr_update_flowpaths_view"();


--
-- TOC entry 3665 (class 2620 OID 152169)
-- Name: gr_update_nodestable_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_nodestable_trigger" BEFORE INSERT OR UPDATE ON "NodesTable" FOR EACH ROW EXECUTE PROCEDURE "gr_update_nodestable"();


--
-- TOC entry 3668 (class 2620 OID 152170)
-- Name: gr_update_river_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_river_trigger" BEFORE UPDATE ON "river" FOR EACH ROW EXECUTE PROCEDURE "gr_topology_update_river"();


--
-- TOC entry 3671 (class 2620 OID 152171)
-- Name: gr_update_river_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_river_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_river" FOR EACH ROW EXECUTE PROCEDURE "gr_update_river_view"();


--
-- TOC entry 3672 (class 2620 OID 152172)
-- Name: gr_update_xscutlines_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_xscutlines_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_xscutlines" FOR EACH ROW EXECUTE PROCEDURE "gr_update_xscutlines_view"();


SET search_path = public, pg_catalog;

-- Completed on 2013-12-17 23:15:03

--
-- PostgreSQL database dump complete
--

