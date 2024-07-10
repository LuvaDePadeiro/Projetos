#include 'protheus.ch'


//aCols[x][12] é a TES
//aCols[x][6] é a Quantidade de itens


// Ponto de entrada referente a Alterações de Itens da NF de Despesas de Importação
User Function MT100LOK()
    Local lRet := .t.
    Local x := 0
    Local nTES := aScan(aHeader,{|y| Alltrim(y[2]) == "D1_TES"})
    Local nQUANT := aScan(aHeader,{|y| Alltrim(y[2]) == "D1_QUANT"})

    for x:=1 to len(aCols)
        if aCols[x][nQUANT] >= 5 .and. !(aCols[x][nTES]$getmv("MV_YTES"))
            lRet := .f.
            Alert("Para Pedidos de compra com mais de 5 itens, consulte o financeiro para saber qual TES é a correta.")
        endif
        x++
    Next
Return lRet
