


ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK 
(((id)::text = ANY (ARRAY['CHAMBER'::text, 'CONDUIT'::text, 'CONNEC'::text, 'GULLY'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'NETELEMENT'::text, 'NETGULLY'::text, 'NETINIT'::text, 
'OUTFALL'::text, 'SIPHON'::text, 'STORAGE'::text, 'VALVE'::text, 'VARC'::text, 'WACCEL'::text, 'WJUMP'::text, 'WWTP'::text, 'LINK'::text, 'SERVCONNECTION'::text, 'INLETPIPE'::text, 
'GENELEMENT'::text, 'FLWREG'::TEXT])));
