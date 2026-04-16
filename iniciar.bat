@echo off
title Fechamento ABAP
cd /d "%~dp0"

echo.
echo ============================================
echo   Fechamento ABAP - Consolidacao de Requests
echo ============================================
echo.

where node >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Node.js nao encontrado. Instale em https://nodejs.org
    pause
    exit /b 1
)

echo [1/3] Gerando fechamento.html...
node fechamento.js
if errorlevel 1 (
    echo [ERRO] Falha ao gerar HTML. Verifique o arquivo .env
    pause
    exit /b 1
)

echo [2/3] Iniciando servidor SAP + IA (se nao estiver rodando)...
netstat -ano 2>nul | findstr /R " :3001 " >nul 2>&1
if errorlevel 1 (
    start "" /B node "..\sap-mcp-server\api-server.js"
    timeout /t 2 /nobreak >nul
    netstat -ano 2>nul | findstr /R " :3001 " >nul 2>&1
    if errorlevel 1 (
        echo     [AVISO] Servidor pode nao ter iniciado. Verifique .env em sap-mcp-server.
    ) else (
        echo     Servidor iniciado.
    )
) else (
    echo     Servidor ja esta rodando na porta 3001.
)

echo [3/3] Abrindo no browser...
start "" "http://localhost:3001/fechamento"

echo.
echo Pronto! Acesse: http://localhost:3001/fechamento
pause
