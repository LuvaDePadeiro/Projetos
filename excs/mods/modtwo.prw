#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#Include "TOTVS.ch"

User Function ModelTwo()
    Private cCadastro := "Cadastro de Usuarios x Rotinas"
	Private NOPCX := 3
    private cTabela := "ZZB"

    Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
		{"Visualizar","U_CFGVis",0,2} ,;
		{"Incluir","U_CFGInc",0,3} ,;
		{"Alterar","U_CFGlt",0,4} ,;
		{"Copiar","U_CFGCop",0,4} ,;
		{"Excluir","U_CFGExc",0,5},;
		{"Testar","U_CFGTST",0,6}}    

        dbSelectArea(cTabela)
        dbSetOrder(1)
        mBrowse( 6,1,22,75,cTabela)

return


User Function CFGInc(cAlias,nReg,nOpcX)
    Local i := nB := 0
    local nA := 0
	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2
	Private nTotaNota := 0

    nOpcX:=3
    OpenSxs(,,,,,"SX3TRB","SX3",,.F.)
	cTabela := "ZZB"
	nIdc:=1
	aHeader:={}
	aGetSD := {}
	_aCampos := {"ZB_ITEM","ZB_FUNCAO","ZB_ATIVO","ZB_FILUSO"}

    If Select("SX3TRB") > 0
		dbSelectArea('SX3TRB')
		SX3TRB->( dbSetOrder( 1 ) ) //ORDENA POR ALIAS
		SX3TRB->( dbGoTop(  ) )
		If SX3TRB->( msSeek( cTabela ) )
			While SX3TRB->(!Eof()) .AND. SX3TRB->&('X3_ARQUIVO')==cTabela

				//IF X3USO(SX3TRB->&('x3_usado')) .and. cNivel >= SX3TRB->&("X3_NIVEL") .and.( trim(SX3TRB->&("x3_campo")) == "ZB_ITEM";
				IF X3USO(SX3TRB->&('x3_usado')) .and. cNivel >= SX3TRB->&("X3_NIVEL") .and. trim(SX3TRB->&("x3_campo")) == _aCampos[nIdc]

					nIdc++

                    AADD(aHeader,{ TRIM(SX3TRB->&('X3_TITULO')), SX3TRB->&('X3_CAMPO'), SX3TRB->&('X3_PICTURE'),;
						SX3TRB->&('X3_TAMANHO'), SX3TRB->&('X3_DECIMAL'),SX3TRB->&('X3_VALID'),;
						SX3TRB->&('X3_USADO'), SX3TRB->&('X3_TIPO'), SX3TRB->&('X3_ARQUIVO'), SX3TRB->&('X3_CONTEXT') } )
					Aadd( aGetSD, SX3TRB->&('X3_CAMPO'))

                EndIF
				SX3TRB->(dbSkip())

			End
		Endif
		SX3TRB->( DbCloseArea() )
	Endif
    
    aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZB_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.

    cCodigo := Space(06)
	cNomeU	:= Space(30)
	nLinGetD:=0
	aC:={}

    AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,"","US1"	,.T.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.",	  	,.F.})

    aR:={}

    aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{220}} )
	nGetLin := aPosObj[2,1]


	aCordW :={aSize[7],0,aSize[6],aSize[5]}
	aCGD:={75,5,218,310}
	aGetEdit := {}

    cLinhaOk:=".T."
	cTudoOk:=".T."

    lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,"+ZB_ITEM",,aCordW,.T.)

    If lRetMod2
		For nA:=1 To Len(aCols)
			If !( aCols[nA][Len(aHeader)+1] )
				nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZB_ITEM" })
				If  !Empty(aCols[nA,nI])
					RecLock("ZZB",.T.)
					ZB_CODUSU  	:= cCodigo
					ZB_NOMEUSU 	:=  UsrRetName(cCodigo)
					//				ZB_MSBLQL	:= cBloq
					For nB:=1 To Len(aHeader)
						cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
						xConteudo := aCols[ nA, cVar ]
						cCampo := AllTrim(aHeader[nB][2])
						Replace &cCampo With xConteudo
					Next
					ZZB->(MsUnlock())
				EndIf
			EndIf
		Next
    Endif
    
return
