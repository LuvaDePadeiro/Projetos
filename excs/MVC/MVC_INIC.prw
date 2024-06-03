#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MVC_INIC()
    Local oBrowse:= FWMBrowse():New()
    Local oValid := Check():New()
    Local lValid := oValid:Acess()
    
    oBrowse:SetAlias("SA1")
    //oBrowse:AddLegend("ZB_ATIVO=='S'","WHITE","USER ATIVO")
    //oBrowse:AddLegend("ZB_ATIVO=='N'","BLUE","USER DESATIVADO")

    oBrowse:SetDescription("Clientes")

    if lValid
        oBrowse:Activate()
    else 
        MsgAlert("Usuario sem acesso a rotina")
    endif      

return 

Static Function MenuDef()  
    Local aRotina := {}  
    ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.MVC_INIC' OPERATION 2 ACCESS 0  
    ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.MVC_INIC' OPERATION 3 ACCESS 0  
    ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.MVC_INIC' OPERATION 4 ACCESS 0  
    ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.MVC_INIC' OPERATION 5 ACCESS 0  
    ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.MVC_INIC' OPERATION 8 ACCESS 0  
    ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.MVC_INIC' OPERATION 9 ACCESS 0  
Return aRotina

Static Function ModelDef()
    Local oModel:=MPFormModel():New("COMPMODEL") 
    Local oModStruc := FWFormStruct(1,"SA1")

    oModel:AddFields("SA1_MASTER",/*cOwner*/,oModStruc)
    oModel:SetPrimaryKey({"A1_FILIAL","A1_COD","A1_LOJA"})
    oModel:SetDescription("Clientes")
    oModel:GetModel("SA1_MASTER"):SetDescription("Clientes")

Return oModel

Static Function ViewDef()
    Local oModel := FWLoadModel("MVC_INIC")
    Local oView := FWFormView():New()
    Local oStruct := FWFormStruct(2,"SA1")

    oView:SetModel(oModel)
    oView:AddField("VIEW_SA1",oStruct,"SA1_MASTER")
    oView:CreateHorizontalBox("TELA",100)
    oView:SetOwnerView("VIEW_SA1","TELA")
    oView:SetCloseOnOk({||.T.})
    
return oView
