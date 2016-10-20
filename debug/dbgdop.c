/*
 * $Id$
 */

#include "hbapi.h"
#include "hbapiitm.h"

#ifdef __XHARBOUR__
#if defined(__XHARBOUR_VERYOLD__)

#include <windows.h>

HB_EXTERN_BEGIN
extern HB_EXPORT void hb_releaseCPU( BOOL );
HB_EXTERN_END

void hb_releaseCPU( BOOL bIndefinite )
{
   HB_SYMBOL_UNUSED( bIndefinite );
   Sleep( 20 );
}

HB_FUNC( HB_RELEASECPU )
{
   hb_releaseCPU(0);
}

#endif


#if defined( HB_OS_UNIX )
#include <glib.h>
HB_FUNC( __DBGPROCESSRUN )
{
   char * argv[] = { (char *) hb_parc(1), (char *) hb_parc(2), NULL };
   hb_retl( g_spawn_async( NULL, argv,
         NULL, G_SPAWN_SEARCH_PATH, NULL, NULL, NULL, NULL ) );
}
#endif

#endif
