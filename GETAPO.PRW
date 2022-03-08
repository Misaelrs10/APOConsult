#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TCBROWSE.CH"

/*
@author  Misael Ramos  misael.rsilva@totvs.com.br
@since 	 08/03/2022
@version 1.0
@link    https://tdn.totvs.com/plugins/viewsource/viewpagesrc.action?pageId=6063364
*/

User Function GETAPO()

    Local btConsul    
    
    Private oDlg
    Private oLista
    Private cFonte := Space(15)

    //Cria a janela de dialogo para o usuario
    DEFINE DIALOG oDlg TITLE "CONSULTA DE FONTES NO APO" FROM 150,150 TO 810,1220 PIXEL

        //Campo para digitar o fonte
        @ 020,050 SAY "Buscar fonte:" SIZE 055, 008 OF oDlg PIXEL
        @ 018,100 MSGET cFonte PICTURE "@!" SIZE 060, 010 OF oDlg PIXEL HASBUTTON

        //Botao de consulta
        @ 016,200 BUTTON btConsul PROMPT "Consultar"  SIZE 050,015 OF oDlg PIXEL ACTION cFonteLista(cFonte)

        cFonteLista(cFonte)

    ACTIVATE DIALOG oDlg CENTERED

Return

Static Function cFonteLista(cFonte)

    Local aListNul  := {""}
    Local aFontes   := {}
    Local aList     := {}
    Local aListTemp := {}
    Local i

    aFontes := GetSrcArray("*")

    If Empty(cFonte) .AND. Len(aFontes) > 0

        For i := 1 To Len(aFontes)

            aData := GetAPOInfo(aFontes[i])
            Aadd(aList ,{aData[1],aData[2],aData[3],DToc(aData[4]),aData[5]})

        Next
    
        aListTemp := aList

        //Cria o objeto do browse novamente
        oLista   := TWBrowse():New(045,000,538,270,,{PADC("Nome Arquivo",80),PADC("Linguagem",45),PADC("Modo de Compilação",45),PADC("Data da Última Execução",42),PADC("Horário da Última Execução",50)},{080,030,045,045,040}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

        //Seta vetor para a browse
        oLista:SetArray(aListTemp)

        //Insere o resultado da consulta no browse
        oLista:bLine := {||{PADC(AllTrim(aListTemp[oLista:nAt,01]),60),;
                            PADC(aListTemp[oLista:nAt,02],50),;
                            PADC(aListTemp[oLista:nAt,03],50),;
                            PADC(aListTemp[oLista:nAt,04],50),;
                            PADC(aListTemp[oLista:nAt,05],70);
                            };
                        }

    ElseIf !Empty(cFonte) .AND. Len(aFontes) > 0

        For i := 1 To Len(aFontes)

            If AllTrim(cFonte) = aFontes[i]

                aData := GetAPOInfo(aFontes[i])
                Aadd(aList ,{aData[1],aData[2],aData[3],DToc(aData[4]),aData[5]})
            
            EndIf

        Next
        
        aListTemp := aList

        If Len(aList) > 0
            //Cria o objeto do browse novamente
            oLista   := TWBrowse():New(045,000,538,270,,{PADC("Nome Arquivo",80),PADC("Linguagem",45),PADC("Modo de Compilação",45),PADC("Data da Última Execução",42),PADC("Horário da Última Execução",50)},{080,030,045,045,040}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

            //Seta vetor para a browse
            oLista:SetArray(aListTemp)

            //Insere o resultado da consulta no browse
            oLista:bLine := {||{PADC(AllTrim(aListTemp[oLista:nAt,01]),60),;
                                PADC(aListTemp[oLista:nAt,02],50),;
                                PADC(aListTemp[oLista:nAt,03],50),;
                                PADC(aListTemp[oLista:nAt,04],50),;
                                PADC(aListTemp[oLista:nAt,05],70);
                                };
                            }
        Else

            //Seta vetor para a browse
            oLista:SetArray(aListNul)

            //Insere uma lista com valores em branco no browse
            oLista:bLine := {||{ aListNul[01],aListNul[01], aListNul[01], aListNul[01], aListNul[01]}}

        EndIf

    EndIf

Return
