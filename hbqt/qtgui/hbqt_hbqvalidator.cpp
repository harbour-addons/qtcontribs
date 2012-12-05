/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "hbqt.h"

#include "hbapiitm.h"
#include "hbvm.h"
#include "hbapicls.h"

#if QT_VERSION >= 0x040500

#include "hbqt_hbqvalidator.h"


HBQValidator::HBQValidator( PHB_ITEM pBlock, PHB_ITEM pFixupBlock ) : QValidator()
{
   if( pBlock )
   {
      block = hb_itemNew( pBlock );
   }
   else
   {
      block = NULL;
   }

   if( fixupBlock )
   {
      fixupBlock = hb_itemNew( pFixupBlock );
   }
   else
   {
      fixupBlock = NULL;
   }
}

HBQValidator::~HBQValidator( void )
{
   if( block )
   {
      hb_itemRelease( block );
      block = NULL;
   }

   if( fixupBlock )
   {
      hb_itemRelease( fixupBlock );
      fixupBlock = NULL;
   }
}

void HBQValidator::fixup( QString & input ) const
{
   if( fixupBlock && hb_vmRequestReenter() )
   {
      PHB_ITEM p0 = hb_itemPutStrUTF8( NULL, input.toAscii().data() );
      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( fixupBlock, 1, p0 ) );
      hb_itemRelease( p0 );

      hb_vmRequestRestore();

      if( hb_itemType( ret ) & HB_IT_STRING )
      {
         void * pText = NULL;
         input = hb_itemGetStrUTF8( ret, &pText, NULL );
         hb_strfree( pText );
      }
      hb_itemRelease( ret );
   }
}

QValidator::State HBQValidator::validate( QString & input, int & pos ) const
{
   if( input.isEmpty() )
   {
      return QValidator::Intermediate;
   }

   QValidator::State state = QValidator::Acceptable;

   if( block && hb_vmRequestReenter() )
   {
      PHB_ITEM p0 = hb_itemPutStrUTF8( NULL, input.toAscii().data() );
      PHB_ITEM p1 = hb_itemPutNI( NULL, pos );

      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( block, 2, p0, p1 ) );

      hb_itemRelease( p0 );
      hb_itemRelease( p1 );

      hb_vmRequestRestore();

      if( hb_itemType( ret ) & HB_IT_ARRAY )
      {
         PHB_ITEM pText = hb_arrayGetItemPtr( ret, 1 );
         if( pText && HB_IS_STRING( pText ) )
         {
            void * pTextP = NULL;
            input = hb_itemGetStrUTF8( pText, &pTextP, NULL );
            hb_strfree( pTextP );
         }
         PHB_ITEM pPos = hb_arrayGetItemPtr( ret, 2 );
         if( pPos && HB_IS_NUMERIC( pPos ) )
         {
            pos = hb_itemGetNI( pPos );
         }
         PHB_ITEM pState = hb_arrayGetItemPtr( ret, 3 );
         if( pState && HB_IS_LOGICAL( pState ) )
         {
            state = ( QValidator::State ) ( hb_itemGetL( pState ) ? QValidator::Acceptable : QValidator::Invalid );
         }
         else
         {
            state = QValidator::Intermediate;
         }
      }
      else if( hb_itemType( ret ) & HB_IT_STRING )
      {
         void * pText = NULL;
         input = hb_itemGetStrUTF8( ret, &pText, NULL );
         hb_strfree( pText );
      }
      else if( hb_itemType( ret ) & HB_IT_LOGICAL )
      {
         state = ( QValidator::State ) ( hb_itemGetL( ret ) ? QValidator::Acceptable : QValidator::Invalid );
      }
      else
      {
         state = QValidator::Intermediate;
      }

      hb_itemRelease( ret );
   }

   return state; //QValidator::validate( input, pos );
}

#endif
