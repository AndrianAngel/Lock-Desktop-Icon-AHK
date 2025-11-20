🖥️ Desktop Icon Lock Toggle (AutoHotkey)

When the lock is active, desktop icons cannot be selected, moved, or deleted. The right‑click context menu remains accessible, and any Display options (such as icon size or auto‑arrange) chosen from that menu will still affect icon behavior. This ensures icons stay fixed in place while allowing normal desktop customization through the context menu.

✨ Features
- Toggle Lock/Unlock: Press Alt+F6 to enable or disable the lock.
- Locking Behavior:
  - Prevents selecting, dragging, or rearranging icons.
  - Blocks the Delete key when pressed on the desktop.
  - Disables interaction with the desktop ListView (WS_DISABLED style).
- Unlocking Behavior:
  - Restores normal desktop interaction.
  - Refreshes the desktop to ensure icons are usable again.
- Hotkey Protection: Blocks Ctrl+Alt++ and Ctrl+Alt+- combinations that normally cycle through icon sizes.
- Tray Notifications: Displays a tray tip when icons are locked or unlocked for quick feedback.
- Safe Cleanup: Automatically removes hooks and restores desktop behavior when the script exits.

🚀 Usage
1. Install AutoHotkey.
2. Run the script (LockDesktopIconsMoveand_Delete.ahk).
3. Use Alt+F6 to toggle between locked and unlocked states.
4. Check the tray notifications to confirm the current status.

🔧 Technical Notes
- Uses SetWindowLong to apply/remove WS_DISABLED style on the desktop ListView (SysListView32).
- Hooks into keyboard events to intercept the Delete key when icons are locked.
- Ensures proper cleanup with UnhookWindowsHookEx on exit.
