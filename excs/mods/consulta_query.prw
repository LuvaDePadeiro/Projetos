#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"

User Function Consulta()
	local cAliasFor
	local cSql := ""
	local nRec := 0

	if select("SX6") > 0
		alert("Protheus open0")
	else
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "COM"
	endif

	cAliasFor := GetNextAlias() //Alias aleatorio temporario

	//Consulta
	cSql := "SELECT ZB_CODUSU,ZB_NOMEUSU,ZB_ITEM,ZB_FUNCAO "
	cSql += "FROM " + RetSQLName("ZZB") + " "
	cSql += "WHERE D_E_L_E_T_ <> '*' "

	//Gerando arquivo
	if !File("consult.sql")
		MemoWrite("consult.sql",cSql)
	endif

	//Usando a consulta
	cSql := ChangeQuery(cSql)

	//Cria tabela temp
	dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cSql),(cAliasFor), .F., .T.)

	//alterando tipo do dado
	//TCSetField(cAliasFor,"ZB_CODUSU","N")

	Count To nRec

	If nRec == 0
		Alert("NAO FORAM ENCONTRADOS DADOS, REFACA OS PARAMETROS","ATENCAO")
		DbSelectArea(cAliasFor)
		dbCloseArea()
		Return
	EndIf

	DbSelectArea(cAliasFor)
	dbGoTop()

	while !EoF()
		Conout(ZB_CODUSU,ZB_NOMEUSU,ZB_ITEM,ZB_FUNCAO)
		DbSelectArea(cAliasFor)
		dbSkip()
	end

	DbSelectArea(cAliasFor)
	dbCloseArea()

	RESET ENVIRONMENT

Return
