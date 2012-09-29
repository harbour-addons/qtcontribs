/*
 * $Id: hbqtcore.h 4 2012-09-29 19:42:37Z bedipritpal $
 */

#ifndef __HBQTCORE_H
#define __HBQTCORE_H

#include "hbqt.h"

#define hbqt_par_HBQEvents( n )                                 ( ( HBQEvents                                   * ) hbqt_par_ptr( n ) )
#define hbqt_par_HBQSlots( n )                                  ( ( HBQSlots                                    * ) hbqt_par_ptr( n ) )
#define hbqt_par_HBQString( n )                                 ( ( HBQString                                   * ) hbqt_par_ptr( n ) )

#endif /* __HBQTCORE_H */
