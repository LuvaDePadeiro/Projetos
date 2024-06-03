#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "REPORT.CH"

#DEFINE ENTER Chr(13)+Chr(10)

User Function fornec_QRY()
    Local oReport
    Private cPerg := "WMSA550"

    If FindFunction("TRepInUse") .And. TRepInUse() //relatorio personalizavel

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:= ReportDef() //Chama a função para carregar a Classe tReport
		oReport:PrintDialog()

	EndIf

Return

Static Function ReportDef()
    Local oReport := TReport():New("FORN1015","Fornecedores mais usados",cPerg,{|oReport|ReportPrint(oReport)})
    Local oSection1

    Local cAlias := "SA2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par8             // Fornecedor De ?                            ³
//³ mv_par9             // Fornecedor Até ?                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


    oReport:SetTitle("Fornecedores mais usados")
    oReport:lHeaderVisible := .T.
    oReport:lFooterVisible := .T.
    oReport:DisableOrientation() 
    oReport:SetLandscape()

    oSection1 := TRSection():New(oReport,"Fornecedores",{"SA2"})
    oSection1:SetTotalInLine(.F.)
    oSection1:SetNoFilter("SA2")

    TRCell():New(oSection1,'A2_COD'	,cAlias	, "COD FORNC.","@!")
    TRCell():New(oSection1,'A2_LOJA'	,cAlias	, "LOJA","@!")
    TRCell():New(oSection1,'A2_NOME'	,cAlias	, "NOME","@!")

    oSection1:SetHeaderPage()

Return (oReport)

Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1)
    Local cOrdem := "A2_FILIAL,A2_COD,A2_LOJA"
    Local TRB := "TRB_FORNEC"
    Local cQuery

    Pergunte(cPerg,.F.)

    //Consulta

    cQuery := "SELECT A2_COD,A2_LOJA,A2_NOME" + ENTER
    cQuery += " FROM " + RetSQLName("SA2") + ENTER
    cQuery += " WHERE A2_COD BETWEEN '" + AllTrim(mv_par08) + "' AND '" + AllTrim(mv_par09) +"' " + ENTER
    cQuery += " ORDER BY " + cOrdem

    MemoWrite("FORNEC_RELAT.SQL",cQuery)

    dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),(TRB), .T., .T.)

    Count To nRec

	If nRec == 0
		Alert("NAO FORAM ENCONTRADOS DADOS, REFACA OS PARAMETROS","ATENCAO")
		DbSelectArea(TRB)
		dbCloseArea()
		Return
	EndIf

    dbSelectArea(TRB)

    dbGoTop()

    While !Eof()
        oSection1:Init()

        oSection1:Cell("A2_COD"):SetValue(AllTrim(A2_COD))
        oSection1:Cell("A2_LOJA"):SetValue(AllTrim(A2_LOJA))
        oSection1:Cell("A2_NOME"):SetValue(AllTrim(A2_NOME))

        oSection1:PrintLine()
        oReport:setMeter(recCount())

        dbSkip()

    End do

    oSection1:Finish()

    dbCloseArea()

Return
