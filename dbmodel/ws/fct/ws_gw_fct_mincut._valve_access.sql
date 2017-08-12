/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_valve_access('valve_id', 'result_id')


LA FUNCIO PREN AQUEST VALOR:
if  (select state from anl_mincut_result_valve_access where valve_id=clicked limit 1)=0 then
		raise exception 'valve permanently closed'
else if  (select state from anl_mincut_result_valve_access where valve_id=clicked limit 1)=1 then
		 delete from anl_mincut_result_valve_access where valve_id=clicked 
else
		insert into anl_mincut_result_valve_access (result_id, valve_id) VALUES (result_id, valve_id) 	
end if;


----MINCUT
CAL REVISAR EL MINCUT PER A QUE TREBALLI AMB EL CURRENT USER: CREC QUE LA SOLUCIO ES FICAR EL CAMP result_id a les taules anl_mincut_arc, anl_mincut_node, anl_mincut_connec, anl_mincut_hydrometer 
DE MANERA QUE QUAN ES PASSI DE LES ANL A LES RESULT, EN EL HIPOTÈTIC CAS QUE ALTRES USUARIS ESTIGUIN FENT ALTRES RESULTS ID NO PASARIA RES. ES PASARÀ CADASCUN AMB EL SEU
NOMÉS HI HAURIA CONFLICTE SI DOS USUARIS MANIPULEN EL MATEIX RESULT_ID. 
DE TOTES MANERES POTSER NO MOLA TREBALLAR AMB LES ANL_MINCUT_NODE I HEM DE TREBALLAR DIRECTAMENT AMB LES RESULT...
CAL MODIFICAR LA FUNCIÓ PER A QUE EL INSERT EN LA TAULA RESULT_SELECTOR ES FACI TAMBÉ PER USUARI
CAL QUE INSERTI EN EL CAMP ANL_THE_GEOM EL PUNT CLICAT PER USUARI


CAL ELIMINAR LES VISTES COMPARE
CAL AFEGIR CUR_USER A LES VISTES RESULT



CAL REVISAR EL MINCUT PER A QUE ANALITZI ELS CONFLICTES DE CONCURRENCIA TEMPORAL


CAL REVISAR EL MINCUT INCORPORANT EL TEMA DELS CULS DE SAC AMB VALVULES PERMANENTMENT TANCADE


CAL QUE LA VISTA V_ANL_MINCUT_RESULT_VALVE PINTI LES VALVULES PER TRES COLORS: 
	- PERMANENT TANCADA
	- PROPOSTA A TANCAR
	- OBERTA
	