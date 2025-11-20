; Desktop Icon Lock Toggle Script
; Press Alt+F6 to toggle lock on/off

#Persistent
#SingleInstance Force

; Global variables
global isLocked := false
global originalHook := 0

; Alt+F6 hotkey to toggle lock
!F6::
{
    isLocked := !isLocked
    
    if (isLocked) {
        LockDesktopIcons()
        TrayTip, Desktop Icons, Icons are now LOCKED, 2, 1
    } else {
        UnlockDesktopIcons()
        TrayTip, Desktop Icons, Icons are now UNLOCKED, 2, 1
    }
    return
}

LockDesktopIcons() {
    ; Get desktop ListView handle
    ControlGet, hwnd, Hwnd,, SysListView321, ahk_class Progman
    if (!hwnd) {
        ControlGet, hwnd, Hwnd,, SysListView321, ahk_class WorkerW
    }
    
    if (hwnd) {
        ; Get current style
        currentStyle := DllCall("GetWindowLong", "ptr", hwnd, "int", -16, "int")
        ; Remove LVS_EX_MULTIWORKAREAS (0x00010000) to disable dragging
        ; Set WS_DISABLED style to prevent interaction
        newStyle := currentStyle | 0x08000000  ; Add WS_DISABLED
        DllCall("SetWindowLong", "ptr", hwnd, "int", -16, "int", newStyle)
    }
    
    ; Set up keyboard hook to block Delete key on desktop
    global originalHook
    originalHook := DllCall("SetWindowsHookEx", "int", 13, "uint", RegisterCallback("KeyboardHook"), "uint", 0, "uint", 0)
}

UnlockDesktopIcons() {
    ; Get desktop ListView handle
    ControlGet, hwnd, Hwnd,, SysListView321, ahk_class Progman
    if (!hwnd) {
        ControlGet, hwnd, Hwnd,, SysListView321, ahk_class WorkerW
    }
    
    if (hwnd) {
        ; Restore original style
        currentStyle := DllCall("GetWindowLong", "ptr", hwnd, "int", -16, "int")
        newStyle := currentStyle & ~0x08000000  ; Remove WS_DISABLED
        DllCall("SetWindowLong", "ptr", hwnd, "int", -16, "int", newStyle)
        ; Force refresh
        DllCall("RedrawWindow", "ptr", hwnd, "ptr", 0, "ptr", 0, "uint", 0x0001 | 0x0004)
    }
    
    ; Remove keyboard hook
    global originalHook
    if (originalHook) {
        DllCall("UnhookWindowsHookEx", "uint", originalHook)
        originalHook := 0
    }
}

KeyboardHook(nCode, wParam, lParam) {
    global isLocked
    
    if (nCode >= 0 && isLocked) {
        vkCode := NumGet(lParam+0, 0, "UInt")
        
        ; Check if Delete key (VK 0x2E) is pressed on desktop
        if (vkCode = 0x2E) {
            WinGetClass, class, A
            if (class = "WorkerW" || class = "Progman") {
                return 1 ; Block the key
            }
        }
    }
    
    return DllCall("CallNextHookEx", "uint", 0, "int", nCode, "uint", wParam, "uint", lParam)
}

; Cleanup on exit
OnExit("Cleanup")

Cleanup() {
    global originalHook
    if (originalHook) {
        DllCall("UnhookWindowsHookEx", "uint", originalHook)
    }
    ExitApp
}

; Show startup message
TrayTip, Desktop Icon Lock, Script loaded! Press Alt+F6 to toggle lock, 3, 1
return