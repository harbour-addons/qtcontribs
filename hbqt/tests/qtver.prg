/*
 * $Id: qtver.prg 4 2012-09-29 19:42:37Z bedipritpal $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Viktor Szakats (harbour syenar.net)
 * www - http://harbour-project.org
 *
 */

#include "simpleio.ch"

PROCEDURE MAIN()

   ? "QT library used is shared:", QSHAREDBUILD()
   ? "QT library version used:", QVERSION()
   ? "QT library version HBQT was built against:", QT_VERSION_STR()
   ? "QT library version HBQT was built against (numeric):", "0x" + hb_numtohex( QT_VERSION() )

   RETURN
