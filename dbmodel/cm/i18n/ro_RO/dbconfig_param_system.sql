/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_param_system AS t SET label = v.label, descript = v.descript FROM (
	VALUES
	('admin_campaign_type', NULL, 'Variabilă pentru a specifica ce tip de campanie dorim să vedem atunci când creăm'),
    ('basic_selector_tab_campaign', 'Selector variabil', 'Variabilă pentru configurarea tuturor opțiunilor legate de căutarea pentru fila specifică'),
    ('basic_selector_tab_lot', 'Selector variabil', 'Variabilă pentru configurarea tuturor opțiunilor legate de căutarea pentru fila specifică')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

