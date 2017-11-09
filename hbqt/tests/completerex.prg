// *---------------------------------------------------------------------------*
//
//   hbqt - Samples
//
//   Copyright (C) 2012-2017 hbQT
//   Author: M.,Ronaldo <ronmesq@gmail.com>
//
//   www: http://harbour-project.org
//   github: https://github.com/MRonaldo/hbqt-lite
//   google groups: https://groups.google.com/forum/#!forum/qtcontribs
//
// *---------------------------------------------------------------------------*

#include "hbqtgui.ch"

PROCEDURE Main ()

   LOCAL oApp
   LOCAL oWindow
   LOCAL oCompleter
   LOCAL oLineEdit
   LOCAL oWords
   LOCAL oModel

   REQUEST HB_CODEPAGE_UTF8
   REQUEST HB_CODEPAGE_UTF8EX

   Set( _SET_CODEPAGE, "UTF8EX" )
   hb_cdpSelect( "UTF8EX" )

   hbqt_errorsys()

   oApp := QApplication()

   WITH OBJECT oWindow := QMainWindow()
      :setWindowTitle( "hbqt: QCompleter ( QStringList )" )
      :resize( 500, 200 )
   END WITH

   WITH OBJECT oWords := QStringList()
      :append( "Marcia" )
   END WITH
   oModel := QStringListModel( oWords )


   WITH OBJECT oCompleter := QCompleter( oModel, oWindow )
      :setCaseSensitivity( Qt_CaseInsensitive )
      :setModelSorting( QCompleter_CaseInsensitivelySortedModel )
   ENDWITH

   WITH OBJECT oLineEdit := QLineEdit( oWindow )
      :resize( 200, 20 )
      :move( 150, 80 )
      :connect( "textChanged(QString)", {|cText| OpenCompleter( oLineEdit, cText ) } )
   END WITH
   oLineEdit:setCompleter( oCompleter )

   oWindow:show()

   oApp:exec()

   RETURN


FUNCTION OpenCompleter( oLineEdit, cText )
   LOCAL oStringList
   LOCAL oModel := oLineEdit:completer():model()

   IF Right( cText, 1 ) == "@"
      WITH OBJECT oStringList := QStringList()
         :append( cText + "gmail.com" )
         :append( cText + "hotmail.com" )
         :append( cText + "yahoo.com" )
         :append( cText + "outlook.com" )
         :append( cText + "aol.com" )
      ENDWITH 
      oModel:setStringList( oStringList )
   ENDIF
   RETURN NIL 

