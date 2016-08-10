#!/bin/bash
# =============================================================================
# File Name:     summarize.sh
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 12-04-2016
# Last Modified: Thu May 26 09:39:51 2016
# =============================================================================

find ~/ISU-DMC/dmc2016 -name '*.h' -o -name '*.R' | xargs wc -l
find ~/ISU-DMC/dmc2016 -name '*.h' -o -name '*.py' | xargs wc -l

find ~/ISU-DMC/dmc2016 -name '*.h' -o -name '*.R' > RFILES
find ~/ISU-DMC/dmc2016 -name '*.h' -o -name '*.py' > PYFILES

# library()
