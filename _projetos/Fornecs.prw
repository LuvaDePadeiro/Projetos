#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "REPORT.CH"

#DEFINE ENTER Chr(13)+Chr(10)

/*/{Protheus.doc} nomeFunction
(Relatorio de historico de compras do fornecedor)
@type user function
@author Kevin Rodrigues o quase analista
@since 16/05/2024
@version 1.0
/*/
User Function FORELAT467()
	Local oReport
	Private cPerg := "FRMV424"

	If FindFunction("TRepInUse") .And. TRepInUse() //relatorio personalizavel

		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„SÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³Interface de impressao                                                  Â³
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
		oReport:= ReportDef() //Chama a funÃ§Ã£o para carregar a Classe tReport
		oReport:PrintDialog()

	EndIf


Return


Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cRelat := "FORELAT467"
	Local tSC7 := "SC7"
	Local aOrdem    := {OemToAnsi(' Numero PC + Item + Sequencia    '),OemToAnsi(' Produto + Fornecedor + Loja + Numero PC      '),OemToAnsi(' DT Emissao + Numero PC + Item 	   ')}//############


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport :=TReport():New(cRelat,"Pedidos de compras X Fornecedor ",cPerg,{|oReport|ReportPrint(oReport,tSC7,aOrdem),"Pedidos de compras X Fornecedor"})

	oReport:SetTotalInLine(.F.)
	oReport:DisableOrientation()
	oReport:SetLandscape()

	VLDPerg()

	Pergunte(cPerg,.f.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da secao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a secao.                   ³
//³ExpA4 : Array com as Ordens do relatorio                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Sessao 1                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oSection1:= TRSection():New(oReport,"Compras X Fornecedores",{tSC7},aOrdem)

	oSection1:SetNoFilter("SC7")

	TRCell():New(oSection1,'C7_NUM'	,tSC7	,"NUM. " + ENTER + "PED."	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'C7_ITEM'	,tSC7	, "QUANT " + ENTER + "ITENS"				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'C7_LOCAL'	,tSC7	, "ARMAZEM"				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'C7_EMISSAO'	,tSC7	,"DATA EMISSÃO"				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'VTOTAL'	," "	,"TOTAL PC"				,"99,999,999,999.99",/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection1:SetHeaderPage()

Return (oReport)

Static Function ReportPrint(oReport,tSA2,tSC7,aOrdem)
	Local oSection1 := oReport:Section(1)
	Local cCont 

	//Variaveis Relatorio 
	Local aProds
	Local cCondPC := ""
	Local cPC
	Local nTotal 
	Local cItem 
	Local nItem
	Local nTT
	Local cArmz

	//Variaveis da query
	Local cOrdem := " ORDER BY "
	Local nOrdem := oSection1:GetOrder()
	Local TRB := "FRC57"
	Local cQuery

	//Ordem da query
	if nOrdem == 1
		cOrdem += "C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN " + ENTER
	elseif nOrdem == 2
		cOrdem += "C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM " + ENTER
	elseif nOrdem == 3
		cOrdem += "C7_FILIAL+C7_EMISSAO+C7_NUM+C7_ITEM+C7_SEQUEN " + ENTER
	ENDIF

	//Status do pedido de compra
	//Pedidos Pendentes(VERDE), parcialmente atendidos(AMARELO), pedidos atendidos(VERMELHO), pedidos bloqueados(AZUL)
	If mv_par06 == 1
		cCondPC := " C7_QUJE = 0 And C7_QTDACLA = 0 And C7_RESIDUO = '' AND C7_CONTRA = '' AND C7_CONAPRO<>'B' "
	elseif mv_par06 == 2
		cCondPC := " C7_QUJE<> 0 And C7_QUJE<C7_QUANT AND C7_RESIDUO = '' AND C7_CONTRA = '' AND C7_CONAPRO = 'B' "
	elseif mv_par06 == 3
		cCondPC := " C7_QUJE>=C7_QUANT AND C7_RESIDUO = '' AND C7_CONTRA = '' AND C7_CONAPRO<>'B' "
	elseif mv_par06 == 4
		cCondPC := " C7_ACCPROC<>'1' And  C7_CONAPRO ='B' And C7_QUJE < C7_QUANT AND C7_RESIDUO ='' "
	ENDIF

	//Criar a query que tras todos os pedidos de compras de um fornecedor X
	cQuery:= " SELECT C7_FILIAL,C7_NUM,C7_ITEM, C7_LOCAL,C7_PRODUTO,C7_EMISSAO,C7_TOTAL FROM " + RetSQLName("SC7") + ENTER
	cQuery+= " WHERE " + ENTER
	cQuery+= " C7_FORNECE = '" + AllTrim(mv_par01) + "' AND " + ENTER
	cQuery+= " C7_EMISSAO >= '" + DtoS(mv_par02) + "' AND C7_EMISSAO <= '" + DtoS(mv_par03) +"' AND" + ENTER
	cQuery+= " C7_LOCAL BETWEEN '"+ mv_par04 + "' AND '" + mv_par05 + "' AND " + ENTER
	cQuery+= cCondPC
	cQuery+= cOrdem

	MemoWrite("FORELAT467.SQL",cQuery)
	dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),(TRB), .T., .T.)

	Count To nRec

	If nRec == 0
		Alert("NAO FORAM ENCONTRADOS DADOS, REFACA OS PARAMETROS","ATENCAO")
		DbSelectArea(TRB)
		dbCloseArea()
		Return
	EndIf

	dbSelectArea(TRB)
	DbGoTop()
	SC7->(DBSetOrder(1))
	
	While !EoF()
		oSection1:Init()

		//Quando mudar o numero do pc ira resetar as variaveis
		if cPC <> FRC57->C7_NUM
			cPC := FRC57->C7_NUM

			aProds := {}
			aArmz:= {}
			nTotal := 0 
			nTT := 0
			nItem := 1
			cItem := "0001"
			cCont := ""
			cArmz:=""
			
			//logica pra buscar os itens e produtos pelo pedido de compra na cs7 sem interfirir na query
			
			SC7->(dbgotop())
			While SC7->(dbSeek((xFilial("SC7")+cPc+cItem)))	
				//setar os valores que vão ser atribuidos
				nTT := nItem
				AADD(aProds,SC7->C7_PRODUTO)
				nTotal+= SC7->C7_TOTAL
				
				if cCont <> SC7->C7_LOCAL
					cCont :=  SC7->C7_LOCAL
					cArmz +=  Alltrim((SC7->C7_LOCAL)) + " "
				endif
				//Troca o valor do item
				nItem++
				cItem:= "000"+Alltrim(Str(nItem))
			end do

		else
			FRC57->(DbSkip())
			Loop
		endif

		oSection1:Cell('C7_NUM'		):SetValue(FRC57->C7_NUM)
		oSection1:Cell('C7_LOCAL'	):SetValue(cArmz)
		oSection1:Cell('C7_EMISSAO'	):SetValue(FRC57->(STOD(C7_EMISSAO)))
		oSection1:Cell('VTOTAL'		):SetValue(nTotal)
		oSection1:Cell('C7_ITEM'	):SetValue(nTT)

		oReport:SkipLine(2)
		oSection1:PrintLine()
		oReport:setMeter(recCount())
		dbSkip()
	END DO

	oSection1:Finish()
	dbCloseArea()


Return
Static Function VLDPerg()
  //U_PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04		,cDefSpa4,cDefEng4,cDef05		,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	U_PutSx1(cPerg,"01"   ,"Fornecedor de   		?",""                    ,""                    ,"mv_ch1","C"   ,15      ,0       ,0      , "G",""    			,"SA2" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"02"   ,"Data da Selecao	de	?",""                    ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    			,""		,""         ,""   ,"mv_par02",""			 ,""      ,""      ,""    ,""	 			,""     ,""      ,""		  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"03"   ,"Data da Selecao	até	?",""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    			,""		,""         ,""   ,"mv_par03",""			 ,""      ,""      ,""    ,""	 			,""     ,""      ,""		  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"04"   ,"Do Armazem				?",""                    ,""                    ,"mv_ch4","C"   ,02      ,0       ,0      , "G",""    			,""	,""         ,""   ,"mv_par04",""			 ,""      ,""      ,""    ,""		 		,""     ,""      ,""		  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"05"   ,"Ate Armazem	      		?",""                    ,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par05",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"06"   ,"Pedido Compra:	",""                    ,""                    ,"mv_ch6","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par06","Pendentes"		   	 ,""      ,""      ,""    ,"Parcial"        	,""     ,""      ,"Atendidos"  	 	  ,""      ,""      ,"Bloqueados"    		,""      ,""     ,"Todos"    		,""      ,""      ,""      ,""      ,""      ,"")
return
