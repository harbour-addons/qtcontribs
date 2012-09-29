/*
 * $Id: dbstruct.prg 4 2012-09-29 19:42:37Z bedipritpal $
 */

/*
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 *
 */
/*----------------------------------------------------------------------*/

#include "hbqtgui.ch"
#include "common.ch"

/*----------------------------------------------------------------------*/

FUNCTION main()
   LOCAL oStruct
   
   oStruct := ui_dbstruct():new()
   oStruct:create()
   oStruct:show()
   
   QApplication():exec()
   
   RETURN NIL
   
/*----------------------------------------------------------------------*/
   
   