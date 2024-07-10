#include 'totvs.ch'

// ponto de entrada M030INC - Inclusão de dados do faturamento
User Function M030INC()
    Local aArea := SA1->(GetArea()) 

    dbSelectArea("SA1")

    if PARAMIXB = 3
        Return
    endif

    If SA1->(dbSeek((M->A1_FILIAL+M->A1_COD+M->A1_LOJA)))
        RecLock('SA1',.f.)
            SA1->(A1_USRICL:=Alltrim(UsrRetName(RetCodUsr())))
        SA1->(MsUnlock())
    Else
        msgInfo("Usuario não encontrado")
    EndIf
    dbCloseArea()
    RestArea(aArea)

Return
