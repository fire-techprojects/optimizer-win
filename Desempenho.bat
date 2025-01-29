@echo off
:: Configuração inicial
title Otimizador de Desempenho
color 0A
echo ========================================================
echo             SISTEMA DE DESEMPENHO FIRE SOLUCOES           
echo ========================================================
echo.

:: Verificar privilégios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Este script precisa ser executado como administrador.
    pause
    exit /b
)

:: Ativar plano de energia de alto desempenho
echo [1/6] Ativando o plano de energia de alto desempenho...
powercfg /setactive SCHEME_MIN
if %errorlevel% equ 0 (
    echo    -> Plano de energia ativado com sucesso.
) else (
    echo    -> Falha ao ativar o plano de energia.
)

:: Fechar processos desnecessários
echo [2/6] Fechando processos desnecessários...
set "processes=OneDrive.exe Skype.exe Teams.exe Cortana.exe Widgets.exe"
for %%p in (%processes%) do (
    taskkill /IM %%p /F >nul 2>&1
    if %errorlevel% equ 0 (
        echo    -> Processo %%p encerrado.
    ) else (
        echo    -> Processo %%p não encontrado ou já encerrado.
    )
)

:: Limpar arquivos temporários
echo [3/6] Limpando arquivos temporários...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "%SystemRoot%\Temp\*" >nul 2>&1
echo    -> Arquivos temporários limpos.

:: Otimizar cache e liberar memória
echo [4/6] Liberando memória e otimizando cache...
%SystemRoot%\system32\Rundll32.exe advapi32.dll,ProcessIdleTasks
echo    -> Memória e cache otimizados.

:: Ajustar prioridades de processos importantes
echo [5/6] Ajustando prioridades de processos importantes...
wmic process where name="chrome.exe" CALL setpriority "128" >nul 2>&1
wmic process where name="firefox.exe" CALL setpriority "128" >nul 2>&1
wmic process where name="game_name.exe" CALL setpriority "128" >nul 2>&1
echo    -> Prioridades ajustadas.

:: Desabilitar serviços que consomem muitos recursos (pode ser reativado manualmente)
echo [6/6] Desabilitando serviços desnecessários...
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start=disabled >nul 2>&1
sc stop "WSearch" >nul 2>&1
sc config "WSearch" start=disabled >nul 2>&1
echo    -> Serviços desnecessários desativados.

:: Finalização
echo.
echo ========================================================
echo           OTIMIZAÇÃO CONCLUÍDA COM SUCESSO!            
echo ========================================================
echo DIREITOS RESERVADOS FIRE SOLUCOES TECNOLOGICAS
pause
exit
