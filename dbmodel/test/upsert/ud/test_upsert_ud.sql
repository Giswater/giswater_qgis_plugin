/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- insert/update/delete doc_type
-- insert/update/delete doc
	
-- insert/update/delete element_type
-- insert/update/delete element
-- insert/update/delete cat_work

-- insert/update/delete cat_feature_node (junction, circ_manhole, sewer_storage)
-- insert/update/delete cat_feature_arc (conduit, siphon, waccel, pump_pipe)
-- insert/update/delete cat_feature_connec (connec)
-- insert/update/delete cat_feature_gully (gully, pgully)
-- insert/update/delete cat_mat_node
-- insert/update/delete cat_mat_roughness
-- insert/update/delete cat_mat_arc
-- insert/update/delete cat_arc
-- insert/update/delete cat_node
-- insert/update/delete cat_grate
		
-- insert/update/delete macroexploitation
-- insert/update/delete macrosector
-- insert/update/delete macrodma
-- insert/update/delete macrodqa
		
-- insert/update/delete exploitation
-- insert/update/delete sector
-- insert/update/delete dma
			
-- insert/update/delete node (loop on cat_feature_node)
-- insert/update/delete arc (loop on cat_feature_arc)
-- insert/update/delete connec (loop on cat_feature_connec)
-- insert/update/delete gully (loop on cat_feature_gully)
-- insert/update/delete link

-- insert/update/delete psector (arc, node, connec, gully, preus_addicionals)
-- insert/update/delete netscenario (dma, presszone)
-- insert/update/delete dscenario (a totes les taules de dscenario que hi ha)