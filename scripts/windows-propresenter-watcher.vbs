' Keep the previous watcher path compatible with existing scheduled tasks.
Dim fso, shell, target
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")
target = fso.BuildPath(fso.GetParentFolderName(WScript.ScriptFullName), "win\watch.vbs")
' Keep this process alive so Task Scheduler can enforce IgnoreNew.
shell.Run "wscript.exe """ & target & """", 0, True
