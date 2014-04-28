@echo off
:: Copyright (c) 2013 The Chromium Embedded Framework Authors. All rights
:: reserved. Use of this source code is governed by a BSD-style license
:: that can be found in the LICENSE file.

set RC=
setlocal

if "%1" == "" (
echo ERROR: Please specify a target platform: win32 or win64
set ERRORLEVEL=1
goto end
)

call make_jni_header.bat %1 org.cef.CefApp
call make_jni_header.bat %1 org.cef.browser.CefBrowser_N
call make_jni_header.bat %1 org.cef.callback.CefFileDialogCallback_N
call make_jni_header.bat %1 org.cef.callback.CefQueryCallback_N
call make_jni_header.bat %1 org.cef.handler.CefClientHandler
call make_jni_header.bat %1 org.cef.handler.CefCommandLine_N

:end
endlocal & set RC=%ERRORLEVEL%
goto omega

:returncode
exit /B %RC%

:omega
call :returncode %RC%