#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function Cmp_SVds()
    Local oBrowse := FWMBrowse():New()
    Local lValid := oValid:Acess()

    oBrowse:SetAlias("SC5")
    oBrowse:SetDescription("Vendas")
    
    if lValid
        oBrowse:Activate()
    else 
        MsgAlert("Usuario sem acesso a rotina")
    endif 
Return

Static Function MenuDef()
    Local aRotina := {}
      
    //Adicionando opções
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.ZAS' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.ZAS' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.ZAS' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.ZAS' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.ZAS' OPERATION 9 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel:=MPFormModel():New("COMPVENDAS")
    Local oStrucCab:=FWFormStruct(1,"SC5") 
    Local oStrucGrid:=FWFormStruct(1,"SC6")

    oModel:AddFields("SC5_MASTER",,oStrucCab)
    oModel:AddGrid("SC6_GRID","SC5_MASTER",oStrucGrid)
    
    oModel:SetRelation("SC6_GRID",{{"SC6_FILIAL","xFilial('SC6')"},{"SC6_NUM","SC5_NUM"}},SC6->(IndexKey(1)))    

    oModel:SetDescription("Vendas")

    oModel:GetModel("SC6_GRID"):SetMaxLine(10)
    oModel:SetDescription("Vendas X Pedidos")
    oModel:SetPrimaryKey({"C5_FILIAL","C5_NUM"})

Return oModel

Static Function ViewDef()
    Local oModel:=FWLoadModel("ZAS")
    Local oView := FWFormView():New()
    Local oStruCab  := FWFormStruct(2,"SC5")
    Local oStrucGrid := FWFormStruct(2,"SC6")

    oView:SetModel(oModel)

    oView:AddField("VIEW_SC5",oStruCab,"SC5_MASTER")
    oView:AddGrid("VIEW_SC6",oStrucGrid,"SC6_GRID")

    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)

    oView:SetOwnerView("VIEW_SC5","MAIN")
    oView:SetOwnerView("VIEW_SC6","GRID")
    oView:EnableControlBar(.t.)

    oView:AddIncrementField("VIEW_SC6","SC6_ITEM")

Return oView
