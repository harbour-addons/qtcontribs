// *---------------------------------------------------------------------------*
//
//   hbqt - Samples - QTableView
//
//   Copyright (C) 2012-2017 HbQT
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
   LOCAL oDB
   LOCAL oModel
   LOCAL oWindow
   LOCAL oView
   LOCAL cDB := "qtsqldemo.db"
   LOCAL lFile := hb_FileExists( cDB )

   REQUEST HB_CODEPAGE_UTF8
   REQUEST HB_CODEPAGE_UTF8EX

   SET( _SET_CODEPAGE, "UTF8EX" )
   hb_cdpSelect( "UTF8EX" )

   hbqt_errorsys()

   oApp := QApplication()

   WITH OBJECT oWindow := QMainWindow()
      :setWindowTitle( "HbQt: QTableView ( QSqlDatabase, QSqlTableModel )" )
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

   IF ! lFile
      WITH OBJECT oDB
         :exec( "CREATE TABLE cadastro( id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, idade INTEGER, endereco TEXT, numero INTEGER, cidade TEXT )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Antonio' , 20, 'Avenida Avelino de Moraes'   , 1   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Bernardo', 21, 'Avenida Bandeira de Azur'    , 2   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Carlos'  , 22, 'Avenida Constantino de Brito', 3   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Diogo'   , 23, 'Avenida Damasio Fortuna'     , 4   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Elias'   , 24, 'Avenida Evaristo Manoel'     , 5   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Fernando', 25, 'Avenida Feira de Santana'    , 6   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Gabriel' , 26, 'Avenida Gomes da Costa'      , 7   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Henrique', 27, 'Avenida Hermano Roriz'       , 8   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Ismael'  , 28, 'Avenida Indio Artiaga'       , 9   , 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Jonas'   , 29, 'Avenida Jfk'                 , 1001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Leonardo', 30, 'Avenida Kito Faria'          , 2001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Marcos'  , 31, 'Avenida Lauro de Alencar'    , 3001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Norberto', 32, 'Avenida Maria Alcina'        , 4001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Odaricio', 33, 'Avenida Nicanor Nacano'      , 5001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Paulo'   , 34, 'Avenida Oliver Perez'        , 6001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Renato'  , 35, 'Avenida Pato Branco'         , 7001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Silvio'  , 36, 'Avenida Q'                   , 8001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Tiago'   , 37, 'Avenida R'                   , 9001, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Ulisses' , 38, 'Avenida S'                   , 9101, 'Rio de Janeiro' )" )
         :exec( "INSERT INTO cadastro( nome, idade, endereco, numero, cidade ) VALUES ( 'Valdir'  , 39, 'Avenida T'                   , 9901, 'Rio de Janeiro' )" )
      ENDWITH
   ENDIF

   WITH OBJECT oModel := QSqlTableModel( oWindow, oDB )
      :setTable("cadastro")
      :setEditStrategy( QSqlTableModel_OnFieldChange )
      :select()
      :setHeaderData( 1, Qt_Horizontal, QVariant( "Nome" ) )
      :setHeaderData( 2, Qt_Horizontal, QVariant( "Idade" ) )
   ENDWITH

   WITH OBJECT oView := QTableView( oWindow )
      :setModel( oModel )
      :hideColumn( 0 ) /* Hide 1st Col - 'Id' */
   ENDWITH

   WITH OBJECT oWindow
      :setCentralWidget( oView )
      :show()
   ENDWITH

   oApp:exec()

   RETURN

