# Forçar execução como Administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

function Mostrar-Menu {
    Clear-Host
    $Host.UI.RawUI.WindowTitle = 'TERRA SEM LEI - CORE NETWORK INJECTOR v5.0'
    $Host.UI.RawUI.BackgroundColor = 'Black'
    $Host.UI.RawUI.ForegroundColor = 'Green'
    Clear-Host
    
    Write-Host "=====================================================================" -ForegroundColor Cyan
    Write-Host "                PAINEL TOTAL DE DESTRAVAMENTO DE REDE v5.0" -ForegroundColor Cyan
    Write-Host "=====================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [ COMBO AUTOMATICO ]"
    Write-Host "    AA. DESTRAVA TOTAL (Executa todas as correcoes em sequencia extrema)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [ COMANDOS INDIVIDUAIS ]"
    Write-Host "    01. Limpar Cache de DNS (ipconfig /flushdns)"
    Write-Host "    02. Limpar Tabela ARP local (arp -d *)"
    Write-Host "    03. Limpar Tabela de Roteamento IP (route /f)"
    Write-Host "    04. Liberar Concessao de IP DHCP (ipconfig /release)"
    Write-Host "    05. Renovar Concessao de IP DHCP (ipconfig /renew)"
    Write-Host "    06. Redefinir Protocolo de Internet TCP/IP (netsh int ip reset)"
    Write-Host "    07. Restaurar Catalogo Winsock Sockets (netsh winsock reset)"
    Write-Host "    08. Ativar Otimizacao TCP Window Tuning (autotuninglevel=normal)"
    Write-Host "    09. Ativar Receive Side Scaling (rss=enabled)"
    Write-Host "    10. Desativar ECN Capability (ecncapability=disabled)"
    Write-Host ""
    Write-Host "  [ SISTEMA ]"
    Write-Host "    99. Sair do Painel" -ForegroundColor Red
    Write-Host "=====================================================================" -ForegroundColor Cyan
}

do {
    Mostrar-Menu
    $op = Read-Host "Selecione o comando desejado e aperte ENTER"
    
    switch ($op.ToUpper()) {
        "AA" {
            Clear-Host
            Write-Host "=========================================================================" -ForegroundColor Cyan
            Write-Host "          [!] ADVERTENCIA: INICIANDO EXPURGO EXTREMO NA PILHA DE REDE [!]" -ForegroundColor Red
            Write-Host "=========================================================================" -ForegroundColor Cyan
            Start-Sleep -Milliseconds 500
            
            Write-Host "[*] [STAGE 01] Expurgando lixo de tabelas locais..." -ForegroundColor Yellow
            ipconfig /flushdns | Out-Null; Write-Host " -> DNS Cache Flushed [OK]" -ForegroundColor Green
            arp -d * 2>$null | Out-Null; Write-Host " -> ARP Table Purged [OK]" -ForegroundColor Green
            route /f | Out-Null; Write-Host " -> Routing Table Reset [OK]" -ForegroundColor Green
            Start-Sleep -Milliseconds 500
            
            Write-Host "[*] [STAGE 02] Rompendo amarras de IP e DHCP..." -ForegroundColor Yellow
            ipconfig /release | Out-Null; Write-Host " -> IP Released [OK]" -ForegroundColor Green
            ipconfig /renew | Out-Null; Write-Host " -> IP Renewed [OK]" -ForegroundColor Green
            Start-Sleep -Milliseconds 500
            
            Write-Host "[*] [STAGE 03] Reinstalando sockets corrompidos..." -ForegroundColor Yellow
            netsh int ip reset | Out-Null; Write-Host " -> TCP/IP Stack Rebuilt [OK]" -ForegroundColor Green
            netsh winsock reset | Out-Null; Write-Host " -> Winsock Catalog Restored [OK]" -ForegroundColor Green
            Start-Sleep -Milliseconds 500
            
            Write-Host "[*] [STAGE 04] Injetando parametros de latência e performance..." -ForegroundColor Yellow
            netsh int tcp set global autotuninglevel=normal | Out-Null
            netsh int tcp set global rss=enabled | Out-Null
            netsh int tcp set global ecncapability=disabled | Out-Null
            netsh int tcp set global dca=enabled | Out-Null
            netsh int tcp set global timestamps=disabled | Out-Null
            netsh int tcp set global lso=enabled | Out-Null
            Write-Host " -> NetSH Turbo Parameters Injected [OK]" -ForegroundColor Green
            
            New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters' -Name 'TCPNoDelay' -PropertyType DWORD -Value 1 -Force | Out-Null
            New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -PropertyType DWORD -Value 0xffffffff -Force | Out-Null
            New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -PropertyType DWORD -Value 0 -Force | Out-Null
            Write-Host " -> Registry Low-Latency Patches Injected [OK]" -ForegroundColor Green
            Start-Sleep -Milliseconds 800
            
            Write-Host "`n=========================================================================" -ForegroundColor Green
            Write-Host "       [+] OPERACAO CONCLUIDA COM SUCESSO NESTA TERRA SEM LEI! [+]" -ForegroundColor Green
            Write-Host "=========================================================================" -ForegroundColor Green
            Write-Host " Todas as camadas de rede foram limpas, resetadas e calibradas para performance."
            Write-Host " [AVISO] Reinicie a maquina para validar os novos registros do Kernel." -ForegroundColor Magenta
            Read-Host "Pressione ENTER para voltar ao menu"
        }
        "01" { ipconfig /flushdns; Read-Host "Concluido. Pressione ENTER" }
        "02" { arp -d *; Read-Host "Concluido. Pressione ENTER" }
        "03" { route /f; Read-Host "Concluido. Pressione ENTER" }
        "04" { ipconfig /release; Read-Host "Concluido. Pressione ENTER" }
        "05" { ipconfig /renew; Read-Host "Concluido. Pressione ENTER" }
        "06" { netsh int ip reset; Read-Host "Concluido. Pressione ENTER" }
        "07" { netsh winsock reset; Read-Host "Concluido. Pressione ENTER" }
        "08" { netsh int tcp set global autotuninglevel=normal; Read-Host "Concluido. Pressione ENTER" }
        "09" { netsh int tcp set global rss=enabled; Read-Host "Concluido. Pressione ENTER" }
        "10" { netsh int tcp set global ecncapability=disabled; Read-Host "Concluido. Pressione ENTER" }
        "99" { Exit }
    }
} while ($op -ne "99")
