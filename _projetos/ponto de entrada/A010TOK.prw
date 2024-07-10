#include 'protheus.ch'

// Ponto de entrada  A010TOK: Validação para inclusão ou alteração do Produto no estoque e custos.
User Function A010TOK()
    Local lRet := .t.
    Local cVal := "0010/0011/0012"

    if INCLUI
        if M->B1_GRUPO $ cVal
            lRet := .f.
            msgInfo("Valor não permitido no sistema!")
        endif
    elseif ALTERA
        msgInfo("Produto alterado")
    elseif lCopia
        msgInfo("Produto copiado")
    endif

Return lRet
