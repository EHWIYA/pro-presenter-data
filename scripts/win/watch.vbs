Option Explicit

' 콘솔 창과 수명이 연결되지 않는 wscript 기반 ProPresenter 종료 감시기.
' PowerShell 결과 창이 닫혀도 CTRL_CLOSE_EVENT(0xC000013A)를 받지 않는다.

Dim wmi, shell, wasRunning, isRunning
Set wmi = GetObject("winmgmts:\\.\root\cimv2")
Set shell = CreateObject("WScript.Shell")

Function ProPresenterIsRunning()
    Dim processes
    Set processes = wmi.ExecQuery( _
        "SELECT ProcessId FROM Win32_Process WHERE Name='ProPresenter.exe'")
    ProPresenterIsRunning = (processes.Count > 0)
End Function

wasRunning = ProPresenterIsRunning()

Do
    WScript.Sleep 2000
    isRunning = ProPresenterIsRunning()

    If wasRunning And Not isRunning Then
        WScript.Sleep 5000
        shell.Run "schtasks.exe /Run /TN ""PP-SessionSync""", 0, False
    End If

    wasRunning = isRunning
Loop
