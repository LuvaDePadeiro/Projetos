#include "protheus.ch"


User Function Relat()

	Local oReport
	Private cPerg := "ETRL11"

	If FindFunction("TRepInUse") .And. TRepInUse() //relatorio personalizavel
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//쿔nterface de impressao                                                  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		oReport:= ReportDef() //Chama a fun豫o para carregar a Classe tReport
		oReport:PrintDialog()
	EndIf

return

Static Function ReportDef()
	Local oReport := TReport():New("ESTRL011","Pedidos de compras em aberto","DSR340",{|oReport|ReportPrint(oReport)})
	Local oSection1
	Local cAliasSB1 := "SB1"

	Pergunte("DSR340",.f.)

	oReport:DisableOrientation()
	oReport:SetLandscape()

	oSection1:=TRSection():New(oReport,"Pedidos de compras em aberto",{"SB1"})

	oSection1:SetNoFilter("SB1")
	oSection1:SetTotalInLine(.f.)
	TRCell():New(oSection1,'B1_CODITE'	,cAliasSB1	, "CODIGO"				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'B1_COD'		,cAliasSB1	, "CODIGO"				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'B1_DESC'	,cAliasSB1	,"DESCRI플O"				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'B1_TIPO'	,cAliasSB1	,"TP"				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection1:SetHeaderPage()
	oSection1:SetTotalText("T o t a l  G e r a l :")

Return oReport


Static Function ReportPrint(oReport)
	Local oSection1	:= oReport:Section(1)

	oSection1:BeginQuery()

	BeginSql Alias "SB1"
        SELECT SB1.R_E_C_N_O_ SB1REC , SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO,
        SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM, SB1.B1_CODITE

        FROM %table:SB1% SB1

        ORDER BY B1_FILIAL+B1_PROC

	EndSql

	oSection1:EndQuery()

	oSection1:Cell('B1_CODITE'	):Show()
	oSection1:Cell('B1_COD'	 	):Hide()
	oSection1:Cell('B1_TIPO'	):Show()
	oSection1:Cell('B1_DESC'	):Show()

	oSection1:Print()

	oSection1:Finish()

return
