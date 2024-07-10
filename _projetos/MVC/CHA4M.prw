#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function CHA4M()
    //Local aArea   := GetArea()
    Local oBrowse := FwLoadBrw("CHA4M")
    oBrowse:Activate()
Return

Static Function BrowseDef()
    Local aArea   := GetArea()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("SZ2")
    oBrowse:SetDescription("Cadastro de Chamados")

    oBrowse:AddLegend( "Z2_STATUS=='0'", "RED", "Chamado Aberto"  )
    oBrowse:AddLegend( "Z2_STATUS=='1'", "YELLOW", "Chamado em atendimento"  )
    oBrowse:AddLegend( "Z2_STATUS=='2'", "GREEN"  , "Chamado resolvido"  )


   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("CHA4M")
   RestArea(aArea)

Return (oBrowse)

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opções
    ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'          OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CHA4M' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CHA4M' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CHA4M' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CHA4M' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CHA4M' OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CHA4M' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruCab  := FWFormStruct(1,"SZ2")
    Local oStruGrid := FWFormStruct(1,"SZ3")

    oModel  := MPFormModel():New("CHA4Mm")
    oModel:AddFields("SZ2_MASTER",,oStruCab)
    oModel:AddGrid("SZ3_GRID","SZ2_MASTER",oStruGrid)

    oModel:SetRelation("SZ3_GRID",;
                        {{"Z3_FILIAL","xFilial('SZ2)"},;
                         {"Z3_CODIGO","Z2_COD"}},SZ3->(IndexKey(1)))

    oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})

    oModel:GetModel("SZ3_GRID"):SetUniqueLine({"Z3_CHAMADO","Z3_CODIGO"})

    oModel:GetModel("SZ2_MASTER"):SetDescription("Chamados do Protheus")
    oModel:GetModel("SZ3_GRID"):SetDescription("Comentarios do chamado")

Return oModel


Static Function ViewDef()
    Local oView
    Local oModel := FWLoadModel("CHA4M")
    Local oStruCab := FWFormStruct(2,"SZ2")
    Local oStruGrid := FWFormStruct(2,"SZ3")

    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField("SZ2_VIEW",oStruCab,"SZ2_MASTER")
    oView:AddGrid("SZ3_VIEW",oStruGrid,"SZ3_GRID")

    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)
 
    //Vincula o MAIN com a VIEW_SZB e a GRID com a GRID_SZB
    oView:SetOwnerView('SZ2_VIEW', 'MAIN')
    oView:SetOwnerView('SZ3_VIEW', 'GRID')


Return oView
