/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM inp_timeseries WHERE timser_type = ''Rainfall'' AND active'
WHERE formname = 'v_edit_raingage' and columnname = 'rg_id';

update rpt_cat_result r set sector_id = a.sector_id from
(select array_agg(distinct a.sector_id) as sector_id, a.result_id from rpt_inp_arc a group by result_id) a
where a.result_id = r.result_id and r.sector_id is null;

update rpt_cat_result r set expl_id = a.expl_id from
(select array_agg(distinct a.expl_id) as expl_id, r.result_id from arc a join rpt_cat_result r on a.sector_id=any(r.sector_id) group by  result_id) a
where a.result_id = r.result_id and r.expl_id is null;

update rpt_cat_result set network_type = 1 where network_type is null;

-- 12/11/24
UPDATE config_form_fields
	SET layoutname='lyt_data_1', layoutorder=10, "datatype"='string',
	WHERE formname='v_edit_raingage' AND columnname='muni_id';
