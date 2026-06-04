Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' CORREÇÃO DA LINHA 6: Força o script a rodar de forma estável no prompt do CMD (CScript)
If Not LCase(Right(WScript.FullName, 11)) = "cscript.exe" Then
    objShell.Run "cmd.exe /k cscript.exe //nologo """ & WScript.ScriptFullName & """", 1, True
    WScript.Quit
End If

Do
    ' Limpa a tela do terminal e monta o painel principal
    objShell.Run "cmd.exe /c cls", 0, True
    WScript.Echo "===================================================================="
    WScript.Echo "             CONSOLE DE GERENCIAMENTO V3.11 - EXTREME PRO           "
    WScript.Echo "===================================================================="
    WScript.Echo " [1] Configurações de Rede (IPConfig /all)"
    WScript.Echo " [2] Interfaces de Rede Físicas (NCPA.CPL)"
    WScript.Echo " [3] Otimizar Rede (Flush DNS & Reset Winsock)"
    WScript.Echo " [4] Eliminar Gargalos e Throttling de Rede (Turbo Packet)"
    WScript.Echo " [5] Disparar Teste de Ping Continuo"
    WScript.Echo " [6] Rastrear Rota de Conexão (Tracert)"
    WScript.Echo "--------------------------------------------------------------------"
    WScript.Echo " [7] Conexão de Área de Trabalho Remota (RDP)"
    WScript.Echo " [8] Iniciar Terminal de Texto Telnet"
    WScript.Echo " [9] Console PowerShell Avançado (ISE)"
    WScript.Echo " [10] Monitor de Recursos do Windows (Resmon)"
    WScript.Echo "--------------------------------------------------------------------"
    WScript.Echo " [11] Editor de Texto (Notepad)"
    WScript.Echo " [12] Calculadora do Sistema"
    WScript.Echo " [13] Gerenciador de Arquivos (Explorer)"
    WScript.Echo " [14] Editor de Imagem (Paint)"
    WScript.Echo "--------------------------------------------------------------------"
    WScript.Echo " [15] Forçar Atualização de Diretivas (GPUpdate)"
    WScript.Echo " [16] Gerar Relatório de GPO na Área de Trabalho (GPResult)"
    WScript.Echo " [17] Active Directory Users & Computers (DSA.MSC)"
    WScript.Echo " [18] Forçar Desempenho Máximo de Energia (PowerCFG)"
    WScript.Echo "--------------------------------------------------------------------"
    WScript.Echo " [19] Configuração do Sistema (MSConfig)"
    WScript.Echo " [20] Editor do Registro do Windows (Regedit)"
    WScript.Echo " [21] Diretivas de Grupo Local (GPEdit.msc)"
    WScript.Echo " [22] Executar Verificador de Arquivos (SFC /Scannow)"
    WScript.Echo " [23] Executar Reparo de Imagem do Sistema (DISM)"
    WScript.Echo "--------------------------------------------------------------------"
    WScript.Echo " [0] Sair do Console Administrativo"
    WScript.Echo "===================================================================="
    WScript.StdOut.Write "Selecione uma opção e pressione ENTER: "
    
    opcao = WScript.StdIn.ReadLine

    Select Case opcao
        ' --- CATEGORIA REDE ---
        Case "1"
            objShell.Run "cmd.exe /k ipconfig /all", 1, True
        Case "2"
            objShell.Run "control ncpa.cpl", 1, False
        Case "3"
            WScript.Echo "Limpando caches de rede..."
            objShell.Run "cmd.exe /c ipconfig /flushdns & ipconfig /registerdns & netsh winsock reset", 0, True
            MsgBox "Rede Otimizada: Cache DNS Limpo e Winsock redefinido.", 64, "Sucesso"
        Case "4"
            WScript.Echo "Aplicando ajustes lógicos anti-gargalo..."
            netCmds = "powershell.exe -Command ""Start-Process cmd -ArgumentList '/c netsh int tcp set global autotuninglevel=normal & netsh int tcp set global rss=enabled & netsh int tcp set global ecncapability=enabled & reg add HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f' -Verb RunAs"""
            objShell.Run netCmds, 0, True
            MsgBox "Gargalos e Throttling de rede eliminados!", 64, "Sucesso"
        Case "5"
            WScript.StdOut.Write "Digite o IP ou Host para o PING: "
            alvo = WScript.StdIn.ReadLine
            If alvo <> "" Then objShell.Run "cmd.exe /k ping " & alvo & " -t", 1, False
        Case "6"
            WScript.StdOut.Write "Digite o IP ou Host para o TRACERT: "
            alvo = WScript.StdIn.ReadLine
            If alvo <> "" Then objShell.Run "cmd.exe /k tracert " & alvo & " -t", 1, False

        ' --- CATEGORIA CONECTIVIDADE & TI ---
        Case "7"
            objShell.Run "mstsc.exe", 1, False
        Case "8"
            WScript.StdOut.Write "Digite o IP ou Host para o TELNET: "
            alvo = WScript.StdIn.ReadLine
            If alvo <> "" Then objShell.Run "cmd.exe /k telnet " & alvo, 1, False
        Case "9"
            objShell.Run "powershell_ise.exe", 1, False
        Case "10"
            objShell.Run "resmon.exe", 1, False

        ' --- CATEGORIA PRODUTIVIDADE ---
        Case "11"
            objShell.Run "notepad.exe", 1, False
        Case "12"
            objShell.Run "calc.exe", 1, False
        Case "13"
            objShell.Run "explorer.exe", 1, False
        Case "14"
            objShell.Run "mspaint.exe", 1, False

        ' --- GPO / AD / ENERGIA ---
        Case "15"
            objShell.Run "cmd.exe /k gpupdate /force", 1, False
        Case "16"
            WScript.Echo "Gerando relatório GPO no Desktop..."
            objShell.Run "cmd.exe /k gpresult /h %USERPROFILE%\Desktop\GPO_Report.html /f && start %USERPROFILE%\Desktop\GPO_Report.html", 1, False
        Case "17"
            objShell.Run "dsa.msc", 1, False
        Case "18"
            objShell.Run "powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61", 0, True
            objShell.Run "powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61", 0, True
            MsgBox "Plano de Desempenho Máximo aplicado ao Hardware!", 64, "Sucesso"

        ' --- DIAGNÓSTICOS ---
        Case "19"
            objShell.Run "msconfig.exe", 1, False
        Case "20"
            objShell.Run "regedit.exe", 1, False
        Case "21"
            objShell.Run "gpedit.msc", 1, False
        Case "22"
            objShell.Run "cmd.exe /k sfc /scannow", 1, False
        Case "23"
            objShell.Run "cmd.exe /k dism.exe /online /cleanup-image /restorehealth", 1, False

        ' --- SAÍDA ---
        Case "0"
            WScript.Echo "Finalizando console..."
            WScript.Sleep 1000
            Exit Do
        Case Else
            MsgBox "Opção inválida! Digite um número de 0 a 23.", 48, "Erro"
    End Select
Loop
