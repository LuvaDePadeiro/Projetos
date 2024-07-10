#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'


/*/{Protheus.doc} nomeFunction
(Rotina de Solicitações de compras)
@type user function
@author Kevin Rodrigues o quase analista
@since 10/07/2024
@version 2.0
/*/
User Function Mod2()
	Local oBrowse
	Local aArea     := GetArea()

	oBrowse         := FWMBrowse():New()

	oBrowse:SetAlias("SZ7")
	oBrowse:SetDescription("Solicitação de compras")
	oBrowse:Activate()

	RestArea(aArea)

Return


Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opções
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.Mod2' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.Mod2' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.Mod2' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.Mod2' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.Mod2' OPERATION 8 ACCESS 0
	ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.Mod2' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()

	Local oModel
	Local oModCab      := fStructCab()
	Local oModGrid     := fStructGrid()
    Local aTrigPrec := {}
    Local aTrigQuant :={}

	//	GetSXENum("SZ7", "Z7_COD")
	oModCab:SetProperty("Z7_COD",     MODEL_FIELD_INIT,  FwBuildFeature(STRUCT_FEATURE_INIPAD,'GetDToVal(GetSXENum("SZ7", "Z7_COD"))'))
	oModCab:SetProperty("Z7_USER",    MODEL_FIELD_INIT,  FwBuildFeature(STRUCT_FEATURE_INIPAD,'__cUserId'))

    aTrigPrec := FwStruTrigger("Z7_QUANT","Z7_VLRTT","M->Z7_QUANT * M->Z7_PREC",.F.)
    aTrigQuant := FwStruTrigger("Z7_PREC","Z7_VLRTT","M->Z7_QUANT * M->Z7_PREC",.F.)

    oModGrid:AddTrigger(aTrigPrec[1],aTrigPrec[2],aTrigPrec[3],aTrigPrec[4])
    oModGrid:AddTrigger(aTrigQuant[1],aTrigQuant[2],aTrigQuant[3],aTrigQuant[4])
    
	oModel  := MPFormModel():New("MOD2m", {|| VldSz7(oModel)} ,{|| lGravSz7(oModel)})
	oModel:AddFields("SZ7_MASTER",,oModCab)
	oModel:AddGrid("SZ7_GRID","SZ7_MASTER",oModGrid)

    oModel:AddCalc("SZ7_TOT","SZ7_MASTER","SZ7_GRID","Z7_PRODUT","QTD_PRD","COUNT",,,"Total de Produtos")
    oModel:AddCalc("SZ7_TOT","SZ7_MASTER","SZ7_GRID","Z7_QUANT","QTD_TOTAL","SUM",,,"Quantidade de Itens")
    oModel:AddCalc("SZ7_TOT","SZ7_MASTER","SZ7_GRID","Z7_PREC","QTD_PED","SUM",,,"Valor total do pedido")

	oModel:SetRelation("SZ7_GRID",;
		{{"Z7_FILIAL",'xFilial("SZ7")'},;
		{"Z7_COD","Z7_COD"}},;
		SZ7->(IndexKey(1)))

	oModel:SetPrimaryKey({"Z7_FILIAL,Z7_COD,Z7_ITEM"})

	oModel:SetDescription("Solicitação de Compras")

	oModel:GetModel("SZ7_MASTER"):SetDescription("Cabeçalho de compras")

	oModel:GetModel("SZ7_GRID"):SetUniqueLine({"Z7_ITEM"})
	oModel:GetModel("SZ7_GRID"):SetDescription("Grid de itens")
	oModel:GetModel("SZ7_GRID"):SetMaxLine(99)
	oModel:GetModel("SZ7_GRID"):SetUseOldGrid(.T.)

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("Mod2")
	Local oModCab := fStructView()
	Local oModGrid := FWFormStruct(2,"SZ7",{|cCamp| Alltrim(cCamp)$"Z7_ITEM/Z7_PRODUT/Z7_QUANT/Z7_PREC/Z7_VLRTT" })
    Local oCalc := FWCalcStruct( oModel:GetModel('SZ7_TOT') )

	Local oView

	//oModCab:SetProperty('Z7_FORNEC', MVC_VIEW_CANCHANGE , IIF(!INCLUI,.F.,.T.))
	//oModCab:SetProperty('Z7_PRODUT', MVC_VIEW_CANCHANGE , IIF(!INCLUI,.F.,.T.))
    oModGrid:SetProperty("Z7_ITEM",    MVC_VIEW_CANCHANGE ,  .F.)
    oModGrid:SetProperty("Z7_VLRTT",    MVC_VIEW_CANCHANGE ,  .F.)   

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField("VIEW_CAB",oModCab,"SZ7_MASTER")
	oView:AddGrid("VIEW_GRID",oModGrid,"SZ7_GRID")
    oView:AddField('VIEW_CALC', oCalc,'SZ7_TOT')

    oView:AddIncrementField("SZ7_GRID","Z7_ITEM")

	oView:CreateHorizontalBox( 'SUPERIOR', 20 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )
    oView:CreateHorizontalBox( 'TOTAIS', 20 )


	oView:SetOwnerView( 'VIEW_CAB', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_GRID', 'INFERIOR' )
    oView:SetOwnerView( 'SZ7_TOT', 'TOTAIS' )

    oView:EnableTitleView("SZ7_TOT","Totais da solicitação de compras")
Return oView



Static Function fStructCab()
	Local oStruc := FWFormStruct(1,"SZ7",{|cCamp| Alltrim(cCamp)$"Z7_COD/Z7_FILIAL/Z7_EMISSAO/Z7_FORNEC/Z7_LOJA/Z7_USER" })
Return oStruc

Static Function fStructView()
	Local oStruc := FWFormStruct(2,"SZ7",{|cCamp| Alltrim(cCamp)$"Z7_COD/Z7_FILIAL/Z7_EMISSAO/Z7_FORNEC/Z7_LOJA/Z7_USER" })
Return oStruc


Static Function fStructGrid()
	Local oStruc := FWFormStruct(1,"SZ7",{|cCamp| Alltrim(cCamp)$"Z7_ITEM/Z7_PRODUT/Z7_QUANT/Z7_PREC/Z7_VLRTT" })
Return oStruc



Static Function lGravSz7(oModel)
	Local lRet      := .t.
	//Local oModCab   := oModel:GetModel("SZ7_MASTER")
	Local oModGrid  := oModel:GetModel("SZ7_GRID")
	Local Linha     := 0

	//Local aCab      := {oModCab:GetValue("Z7_EMISSAO"),oModCab:GetValue("Z7_FORNEC"),oModCab:GetValue("Z7_EMISSAO")}
	Local nDel      := 0
	//Local aHeaderX  := oModGrid:aHeader or oModel:GetModel("SZ7_GRID"):aHeader
	//Local aColsX    := oModGrid:aCols or  oModel:GetModel("SZ7_GRID"):aCols


	For Linha := 1 to oModGrid:Length()
		oModGrid:GoLine(Linha)

		if oModGrid:IsDeleted()
			nDel++
		EndIf
	Next

	if oModGrid:Length() == nDel
		lRet :=.F.
		Help( , , 'Dados Inválidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha válida!"})
	endif


Return lRet

Static Function VldSz7(oModel)
    Local lRet := .t.
    Local aArea := GetArea()

    Local oModCab   := oModel:GetModel("SZ7_MASTER")
    Local cFil      := oModCab:GetValue("Z7_FILIAL")
    Local cCod      := oModCab:GetValue("Z7_COD")
    Local cOp       := oModCab:GetOperation()

    IF cOp := 3
        SZ7->(DBSetOrder(1))
        IF SZ7->(DbSeek((cFil + cValToChar(cCod))))
            lRet    := .f.
            Help(, , "O numero do pedido já esta em uso", , "Atenção, o numero do pedido informado está em uso ", 1, 0, , , , , , {"Atenção"})
        ENDIF
    ENDIF

    RestArea(aArea)
Return lRet
