/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

ALTER TABLE inp_frorifice ALTER COLUMN flap DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN cd DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN shape DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN geom1 DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN geom2 DROP NOT NULL;


ALTER TABLE om_waterbalance_dma_graph ADD CONSTRAINT om_waterbalance_dma_graph_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE arc ADD CONSTRAINT arc_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE connec ADD CONSTRAINT connec_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE gully ADD CONSTRAINT gully_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE link ADD CONSTRAINT link_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE node ADD CONSTRAINT node_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);

CREATE RULE omzone_conflict AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = '-1'::integer) OR (old.omzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE omzone_undefined AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = 0) OR (old.omzone_id = 0)) DO INSTEAD NOTHING;

CREATE RULE dma_conflict AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = '-1'::integer) OR (old.dma_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dma_undefined AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;

CREATE RULE dwfzone_conflict AS
    ON UPDATE TO dwfzone
   WHERE ((new.dwfzone_id = '-1'::integer) OR (old.dwfzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dwfzone_undefined AS
    ON UPDATE TO dwfzone
   WHERE ((new.dwfzone_id = 0) OR (old.dwfzone_id = 0)) DO INSTEAD NOTHING;


-- expl_id is not void
CREATE RULE dqa_expl AS
    ON UPDATE TO dqa
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;

CREATE RULE dwfzone_expl AS
    ON UPDATE TO dqa
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;
   
CREATE RULE omzone_expl AS
    ON UPDATE TO dqa
   WHERE ((new.expl_id = '{}'::integer[]) OR (old.expl_id = '{}'::integer[])) DO INSTEAD NOTHING;