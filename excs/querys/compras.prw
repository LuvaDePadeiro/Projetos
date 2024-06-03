#INCLUDE 'Protheus.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)

User Function QRC7()
    local cQuery
    local nRec := 0

    If SELECT("SX6") >0
		ALERT("PROTHEUS ABERTO")
	Else
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
	EndIf

    cQuery:=" select * from " + RetSQLName("SC7")
    cQuery+=" WHERE D_E_L_E_T_ <> '*' "

    MemoWrite("compras.sql",cQuery)

    dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"TBRC7", .F., .T.)

    while TBRC7->(!Eof())
        Alert( TBRC7->C7_NUM,TBRC7->C7_ITEM)
    end


Return
