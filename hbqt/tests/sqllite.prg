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

   LOCAL cDB := "cidades.db"
   LOCAL oApp
   LOCAL oDB
   LOCAL oModel
   LOCAL oWindow
   LOCAL oCompleter
   LOCAL oLineEdit

   REQUEST HB_CODEPAGE_UTF8
   REQUEST HB_CODEPAGE_UTF8EX

   Set( _SET_CODEPAGE, "UTF8EX" )
   hb_cdpSelect( "UTF8EX" )

   hbqt_errorsys()

   oApp := QApplication()

   WITH OBJECT oWindow := QMainWindow()
      :setWindowTitle( "hbqt: QCompleter ( QSql, QSqlDatabase, QSqlTableModel )" )
      :resize( 800, 600 )
   END WITH

   WITH OBJECT oDB := QSqlDatabase():addDatabase( "QSQLITE" )
      :setHostName( "localhost" )
      :setDatabaseName( cDB )
      :setUserName( "usuario" )
      :setPassword( "senha" )
   END WITH

   IF ! oDB:open()
      QUIT
   ENDIF

   WITH OBJECT oModel := QSqlTableModel( oWindow, oDB )
      :setTable( "cidades" )
      :setSort( 2, Qt_AscendingOrder )
      :select()
   END WITH

   WITH OBJECT oCompleter := QCompleter():new( oModel, oWindow )
      :setCaseSensitivity( Qt_CaseInsensitive )
      :setCompletionColumn( 2 )
   END WITH

   WITH OBJECT oLineEdit := QLineEdit( oWindow )
      :resize( 200, 20 )
      :move( 20, 20 )
   END WITH
   oLineEdit:setCompleter( oCompleter )

   oWindow:show()

   oApp:exec()

   RETURN
