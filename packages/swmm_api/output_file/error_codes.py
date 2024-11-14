ERROR_CODE = {101: "\n  ERROR 101: memory allocation error.",
              103: "\n  ERROR 103: cannot solve KW equations for Link %s.",
              105: "\n  ERROR 105: cannot open ODE solver.",
              107: "\n  ERROR 107: cannot compute a valid time step.",

              108: "\n  ERROR 108: ambiguous outlet ID name for Subcatchment %s.",
              109: "\n  ERROR 109: invalid parameter values for Aquifer %s.",
              110: "\n  ERROR 110: ground elevation is below water table for Subcatchment %s.",

              111: "\n  ERROR 111: invalid length for Conduit %s.",
              112: "\n  ERROR 112: elevation drop exceeds length for Conduit %s.",
              113: "\n  ERROR 113: invalid roughness for Conduit %s.",
              114: "\n  ERROR 114: invalid number of barrels for Conduit %s.",
              115: "\n  ERROR 115: adverse slope for Conduit %s.",
              117: "\n  ERROR 117: no cross section defined for Link %s.",
              119: "\n  ERROR 119: invalid cross section for Link %s.",
              121: "\n  ERROR 121: missing or invalid pump curve assigned to Pump %s.",
              122: "\n  ERROR 122: startup depth not higher than shutoff depth for Pump %s.",

              131: "\n  ERROR 131: the following links form cyclic loops in the drainage system:",
              133: "\n  ERROR 133: Node %s has more than one outlet link.",
              134: "\n  ERROR 134: Node %s has illegal DUMMY link connections.",

              135: "\n  ERROR 135: Divider %s does not have two outlet links.",
              136: "\n  ERROR 136: Divider %s has invalid diversion link.",
              137: "\n  ERROR 137: Weir Divider %s has invalid parameters.",
              138: "\n  ERROR 138: Node %s has initial depth greater than maximum depth.",
              139: "\n  ERROR 139: Regulator %s is the outlet of a non-storage node.",
              140: "\n  ERROR 140: Storage node %s has negative volume at full depth.",  # (5.1.015)
              141: "\n  ERROR 141: Outfall %s has more than 1 inlet link or an outlet link.",
              143: "\n  ERROR 143: Regulator %s has invalid cross-section shape.",
              145: "\n  ERROR 145: Drainage system has no acceptable outlet nodes.",

              151: "\n  ERROR 151: a Unit Hydrograph in set %s has invalid time base.",
              153: "\n  ERROR 153: a Unit Hydrograph in set %s has invalid response ratios.",
              155: "\n  ERROR 155: invalid sewer area for RDII at node %s.",

              156: "\n  ERROR 156: ambiguous station ID for Rain Gage %s.",
              157: "\n  ERROR 157: inconsistent rainfall format for Rain Gage %s.",
              158: "\n  ERROR 158: time series for Rain Gage %s is also used by another object.",
              159: "\n  ERROR 159: recording interval greater than time series interval for Rain Gage %s.",

              161: "\n  ERROR 161: cyclic dependency in treatment functions at node %s.",

              171: "\n  ERROR 171: Curve %s has invalid or out of sequence data.",
              173: "\n  ERROR 173: Time Series %s has its data out of sequence.",

              181: "\n  ERROR 181: invalid Snow Melt Climatology parameters.",
              182: "\n  ERROR 182: invalid parameters for Snow Pack %s.",

              183: "\n  ERROR 183: no type specified for LID %s.",
              184: "\n  ERROR 184: missing layer for LID %s.",
              185: "\n  ERROR 185: invalid parameter value for LID %s.",
              186: "\n  ERROR 186: invalid parameter value for LID placed in Subcatchment %s.",
              187: "\n  ERROR 187: LID area exceeds total area for Subcatchment %s.",
              188: "\n  ERROR 188: LID capture area exceeds total impervious area for Subcatchment %s.",

              191: "\n  ERROR 191: simulation start date comes after ending date.",
              193: "\n  ERROR 193: report start date comes after ending date.",
              195: "\n  ERROR 195: reporting time step or duration is less than routing time step.",

              200: "\n  ERROR 200: one or more errors in input file.",
              201: "\n  ERROR 201: too many characters in input line ",
              203: "\n  ERROR 203: too few items ",
              205: "\n  ERROR 205: invalid keyword %s ",
              207: "\n  ERROR 207: duplicate ID name %s ",
              209: "\n  ERROR 209: undefined object %s ",
              211: "\n  ERROR 211: invalid number %s ",
              213: "\n  ERROR 213: invalid date/time %s ",
              217: "\n  ERROR 217: control rule clause invalid or out of sequence ",  # (5.1.008)
              219: "\n  ERROR 219: data provided for unidentified transect ",
              221: "\n  ERROR 221: transect station out of sequence ",
              223: "\n  ERROR 223: Transect %s has too few stations.",
              225: "\n  ERROR 225: Transect %s has too many stations.",
              227: "\n  ERROR 227: Transect %s has no Manning's N.",
              229: "\n  ERROR 229: Transect %s has invalid overbank locations.",
              231: "\n  ERROR 231: Transect %s has no depth.",
              233: "\n  ERROR 233: invalid treatment function expression ",

              301: "\n  ERROR 301: files share same names.",
              303: "\n  ERROR 303: cannot open input file.",
              305: "\n  ERROR 305: cannot open report file.",
              307: "\n  ERROR 307: cannot open binary results file.",
              309: "\n  ERROR 309: error writing to binary results file.",
              311: "\n  ERROR 311: error reading from binary results file.",

              313: "\n  ERROR 313: cannot open scratch rainfall interface file.",
              315: "\n  ERROR 315: cannot open rainfall interface file %s.",
              317: "\n  ERROR 317: cannot open rainfall data file %s.",
              318: "\n  ERROR 318: the following line is out of sequence in rainfall data file %s.",  # (5.1.010)
              319: "\n  ERROR 319: unknown format for rainfall data file %s.",
              320: "\n  ERROR 320: invalid format for rainfall interface file.",
              321: "\n  ERROR 321: no data in rainfall interface file for gage %s.",

              323: "\n  ERROR 323: cannot open runoff interface file %s.",
              325: "\n  ERROR 325: incompatible data found in runoff interface file.",
              327: "\n  ERROR 327: attempting to read beyond end of runoff interface file.",
              329: "\n  ERROR 329: error in reading from runoff interface file.",

              330: "\n  ERROR 330: hotstart interface files have same names.",
              331: "\n  ERROR 331: cannot open hotstart interface file %s.",
              333: "\n  ERROR 333: incompatible data found in hotstart interface file.",
              335: "\n  ERROR 335: error in reading from hotstart interface file.",

              336: "\n  ERROR 336: no climate file specified for evaporation and/or wind speed.",
              337: "\n  ERROR 337: cannot open climate file %s.",
              338: "\n  ERROR 338: error in reading from climate file %s.",
              339: "\n  ERROR 339: attempt to read beyond end of climate file %s.",

              341: "\n  ERROR 341: cannot open scratch RDII interface file.",
              343: "\n  ERROR 343: cannot open RDII interface file %s.",
              345: "\n  ERROR 345: invalid format for RDII interface file.",

              351: "\n  ERROR 351: cannot open routing interface file %s.",
              353: "\n  ERROR 353: invalid format for routing interface file %s.",
              355: "\n  ERROR 355: mis-matched names in routing interface file %s.",
              357: "\n  ERROR 357: inflows and outflows interface files have same name.",

              361: "\n  ERROR 361: could not open external file used for Time Series %s.",
              363: "\n  ERROR 363: invalid data in external file used for Time Series %s.",

              401: "\n  ERROR 401: general system error.",
              402: "\n  ERROR 402: cannot open new project while current project still open.",
              403: "\n  ERROR 403: project not open or last run not ended.",
              405: "\n  ERROR 405: amount of output produced will exceed maximum file size;"
                   "\n             either reduce Ending Date or increase Reporting Time Step.",

              # API Error Keys
              501: "\n API Key Error: Object Type Outside Bonds",
              502: "\n API Key Error: Network Not Initialized (Input file open?)",
              503: "\n API Key Error: Simulation Not Running",
              504: "\n API Key Error: Incorrect object type for parameter chosen",
              505: "\n API Key Error: Object index out of Bounds.",
              506: "\n API Key Error: Invalid Pollutant Index",
              507: "\n API Key Error: Invalid Inflow Type",
              508: "\n API Key Error: Invalid Timeseries Index",
              509: "\n API Key Error: Invalid Pattern Index",
              }
