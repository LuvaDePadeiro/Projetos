#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MVC2_INIC()
    Local oBrowse := FWMBrowse():New()
    Local oValid := ValidACS():New()
    Local lValid := oValid:Acess()

    oBrowse:SetAlias("ZZB")
    oBrowse:SetDescription("Usuarios X Acessos")

    if lValid
        oBrowse:Activate()
    else 
        MsgAlert("Usuario sem acesso a rotina")
    endif  

Return

Static Function MenuDef()
    Local aRotina := {}
      
    //Adicionando opções
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC2_INIC' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC2_INIC' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC2_INIC' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC2_INIC' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC2_INIC' OPERATION 9 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel := MPFormModel():New("COMPZZB")
    Local oStruct := FWFormStruct(1, 'ZZB', {|cCampo| AllTRim(cCampo) $ "ZB_CODUSU;ZB_NOMEUSU;"})
    Local oStrucGrid := fModStruct()

    oModel:AddFields("ZZB_MASTER",,oStruct)
    oModel:AddGrid("ZZB_GRID","ZZB_MASTER",oStrucGrid)

    oModel:SetRelation('ZZB_GRID', {;
            {'ZB_FILIAL', 'xFilial("ZZB")'},;
            {"ZB_CODUSU",  "ZB_CODUSU"};
            }, ZZB->(IndexKey(1)))
    
    oModel:GetModel("ZZB_GRID"):SetMaxLine(10)
    oModel:SetDescription("USer x ACess")
    oModel:SetPrimaryKey({"ZB_FILIAL", "ZB_CODUSU", "ZB_FUNCAO"})

Return oModel

Static Function ViewDef()
    Local oModel:=FWLoadModel("MVC2_INIC")
    Local oStruc:=FWFormStruct(2, "ZZB", {|cCampo| (AllTRim(cCampo) $ "ZB_CODUSU;ZB_NOMEUSU;")})
    Local oStrucGrid:=fModView()
    Local oView:=FWFormView():New()

    //oStruc:SetNotFolder()
    oView:SetModel(oModel)

    oView:AddField("VIEW_ZZB",oStruc,"ZZB_MASTER")
    oView:AddGrid("VIEW_GRID",oStrucGrid,"ZZB_GRID")
    
    oView:CreateHorizontalBox("MAIN", 40)
    oView:CreateHorizontalBox("GRID", 60)

    oView:SetOwnerView("VIEW_ZZB","MAIN")
    oView:SetOwnerView("VIEW_GRID","GRID")
    oView:EnableControlBar(.t.)

    oView:AddIncrementField('VIEW_GRID',"ZB_ITEM")
    
Return oView


Static Function fModStruct()
    Local cCamps:="ZB_ITEM;ZB_FUNCAO;ZB_ATIVO;ZB_FILUSO;ZB_MSBLQL"
    Local oStruct := FWFormStruct(1, 'ZZB', {|cCampo| AllTRim(cCampo) $ cCamps})
Return oStruct

Static Function fModView()
    Local cCamps:="ZB_ITEM;ZB_FUNCAO;ZB_ATIVO;ZB_FILUSO;ZB_MSBLQL"
    Local oStrucGrid := FWFormStruct(2, "ZZB", {|cCampo| (AllTRim(cCampo) $ cCamps)})
Return oStrucGrid
