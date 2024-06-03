#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)
User Function Query_TBL()
    local nRec := 0
    local cQuery

    If SELECT("SX6") >0
		ALERT("PROTHEUS ABERTO")
	Else
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
	EndIf

    cQuery:= " SELECT * " + ENTER
    cQuery+= " FROM " +  RetSQLName("ZZB") + ENTER
    cQuery+= " WHERE D_E_L_E_T_ <> '*' AND " + ENTER
    cQuery+= " ZB_FUNCAO ='MVC2_INIC' " + ENTER

    MemoWrite("acessos.sql",cQuery)

    dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"TRBZB", .F., .T.)
    TRBZB->(dbGoTop())

    Count To nRec

	If nRec == 0
		Alert("NAO FORAM ENCONTRADOS DADOS, REFACA OS PARAMETROS","ATENCAO")
		dbCloseArea()
		Return
	EndIf

    While TRBZB->(!Eof())
        Alert(TRBZB->ZB_CODUSU,TRBZB->ZB_NOMEUSU,TRBZB->ZB_ITEM,TRBZB->ZB_ATIVO)
        TRBZB->(dbSkip())
    end
    RESET ENVIRONMENT
Return
