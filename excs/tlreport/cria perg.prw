#INCLUDE 'Protheus.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)

User Function Cria_pergs()
	Local TRB := "TRB_TEST"
	Local cQuery
	Local nRec
	Local cItem := "0001"
	Local nItem := 1
	Private cPerg := "FRMV424"

    RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"

	//Gerar novamentes as perguntas que estão refinadas
  //U_PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04		,cDefSpa4,cDefEng4,cDef05		,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)

    //U_PutSx1(cPerg,"01"   ,"Fornecedor de   		?",""                    ,""                    ,"mv_ch1","C"   ,15      ,0       ,0      , "G",""    			,"SA2" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	//U_PutSx1(cPerg,"02"   ,"Data da Selecao	de	?",""                    ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    			,""		,""         ,""   ,"mv_par02",""			 ,""      ,""      ,""    ,""	 			,""     ,""      ,""		  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	//U_PutSx1(cPerg,"03"   ,"Data da Selecao	até	?",""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    			,""		,""         ,""   ,"mv_par03",""			 ,""      ,""      ,""    ,""	 			,""     ,""      ,""		  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	//U_PutSx1(cPerg,"04"   ,"Do Armazem				?",""                    ,""                    ,"mv_ch4","C"   ,02      ,0       ,0      , "G",""    			,""	,""         ,""   ,"mv_par04",""			 ,""      ,""      ,""    ,""		 		,""     ,""      ,""		  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	//U_PutSx1(cPerg,"05"   ,"Ate Armazem	      		?",""                    ,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par05",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    		,""      ,""     ,""    		,""      ,""      ,""      ,""      ,""      ,"")
	//U_PutSx1(cPerg,"06"   ,"Pedido Compra:	",""                    ,""                    ,"mv_ch6","C"   ,01      ,0       ,0      , "N",""    			,"" 	,""         ,""   ,"mv_par06","Pendentes"		   	 ,""      ,""      ,""    ,"Parcial"        	,""     ,""      ,"Atendidos"  	 	  ,""      ,""      ,"Bloqueados"    		,""      ,""     ,"Todos"    		,""      ,""      ,""      ,""      ,""      ,"")

	Pergunte(cPerg,.t.)

	//Refinar a query
	cQuery:= " SELECT C7_NUM, C7_LOCAL,C7_PRODUTO,C7_ITEM,C7_EMISSAO,C7_FILIAL,C7_SEQUEN FROM SC7990 " + ENTER
	//cQuery+= " WHERE " + ENTER
	//cQuery+= " C7_FORNECE = 'VALTEC' AND " + ENTER
	//cQuery+= " C7_LOCAL BETWEEN '01' AND '01' AND " + ENTER
	//cQuery+= " C7_EMISSAO BETWEEN '20240510' AND '20240517' AND" + ENTER	
	//cQuery+= " C7_ACCPROC<>'1' And  C7_CONAPRO ='B' And C7_QUJE < C7_QUANT AND C7_RESIDUO ='' " + ENTER
	cQuery+= " ORDER BY C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN "
	
	
	MemoWrite("FORNECSS_RELAT.SQL",cQuery)

    dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),(TRB), .F., .F.)
	
	//TRB_TEST->(DBCreateIndex("IDX01_tst"," C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUE"))

	//TRB_TEST->(DBSetOrder(1))


	Count To nRec

	If nRec == 0
		Alert("NAO FORAM ENCONTRADOS DADOS, REFACA OS PARAMETROS","ATENCAO")
		DbSelectArea(TRB)
		dbCloseArea()
		Return
	EndIf

	dbSelectArea("SC7")
	DBSetOrder(1)
	dbgotop()

	//logica pra buscar os itens e produtos pelo pedido de compra na cs7 sem interfirir na query
	while !EoF()
		While SC7->(dbSeek((xFilial("SC7")+"000002"+cItem)))
			nItem++
			cItem:= "000"+Alltrim(Str(nItem))


			MsgInfo("Pedido " + SC7->C7_NUM +  "achado" + " = Item: "+ C7_ITEM)

			
		end do
	end do
	dbCloseArea()
    RESET ENVIRONMENT

Return
