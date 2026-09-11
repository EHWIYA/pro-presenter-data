# Windows 콘솔의 QuickEdit 정지 기능을 비활성화한다.
function Disable-ConsoleQuickEdit {
    if (-not ("ConsoleMode.NativeMethods" -as [type])) {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
namespace ConsoleMode {
    public static class NativeMethods {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr GetStdHandle(int nStdHandle);
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleMode(IntPtr h, out uint mode);
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleMode(IntPtr h, uint mode);
    }
}
"@
    }
    $handle = [ConsoleMode.NativeMethods]::GetStdHandle(-10)
    [uint32]$mode = 0
    if ([ConsoleMode.NativeMethods]::GetConsoleMode($handle, [ref]$mode)) {
        $extended = [uint32]0x0080
        $quickEdit = [uint32]0x0040
        $newMode = ($mode -bor $extended) -band (-bnot $quickEdit)
        [ConsoleMode.NativeMethods]::SetConsoleMode($handle, $newMode) | Out-Null
    }
}
