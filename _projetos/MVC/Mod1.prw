#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function Mod1()
    Local oBrowse := FWMBrowse():New()

    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Usuarios X Acessos")

    oBrowse:AddLegend("A1_MSBLQL='1'","RED","Cliente Bloqueado")
    oBrowse:AddLegend("A1_MSBLQL='2'","GREEN" ,"Cliente Ativo")

    oBrowse:Activate()

Return

Static Function MenuDef()
    Local aRotina := {}
      
    //Adicionando opções
    ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.Mod1' OPERATION 2 ACCESS 0  
    ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.Mod1' OPERATION 3 ACCESS 0  
    ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.Mod1' OPERATION 4 ACCESS 0  
    ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.Mod1' OPERATION 5 ACCESS 0  
    ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.Mod1' OPERATION 8 ACCESS 0  
    ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.Mod1' OPERATION 9 ACCESS 0  

Return aRotina


Static Function ModelDef()
    Local oModel
    Local oStrucCab := FWFormStruct(1,"SA1",/* {|x| Alltrim(x)$cCampos}*/ )

    oModel :=  MPFormModel():New('MODMV_01' )

    oModel:AddFields("SA1_MASTER",,oStrucCab)

    oModel:SetPrimaryKey({"A1_FILIAL","A1_COD","A1_LOJA"})
    oModel:SetDescription("Cadastro de Clientes")


    oModel:GetModel("SA1_MASTER"):SetDescription("Cadastro de Clientes")

Return oModel

Static Function ViewDef()
    Local oView 
    Local oStrucCab := FWFormStruct(2,"SA1")
    Local oModel := FWLoadModel("Mod1")

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("SA1_VIEW",oStrucCab,"SA1_MASTER")

    oView:CreateHorizontalBox("TELA",100)
    oView:SetOwnerView("SA1_VIEW","TELA")

Return oView
