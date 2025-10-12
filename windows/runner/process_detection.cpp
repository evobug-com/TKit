#include "process_detection.h"
#include <psapi.h>
#include <tlhelp32.h>
#include <sstream>
#include <iomanip>

// Helper to convert wide string to UTF-8 string
std::string WideToUtf8(const std::wstring& wstr) {
    if (wstr.empty()) return std::string();
    int size = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), NULL, 0, NULL, NULL);
    std::string result(size, 0);
    WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), &result[0], size, NULL, NULL);
    return result;
}

// Helper to escape JSON strings
std::string EscapeJson(const std::string& str) {
    std::ostringstream oss;
    for (char c : str) {
        switch (c) {
            case '"': oss << "\\\""; break;
            case '\\': oss << "\\\\"; break;
            case '\b': oss << "\\b"; break;
            case '\f': oss << "\\f"; break;
            case '\n': oss << "\\n"; break;
            case '\r': oss << "\\r"; break;
            case '\t': oss << "\\t"; break;
            default:
                if (c < 0x20) {
                    oss << "\\u" << std::hex << std::setw(4) << std::setfill('0') << (int)c;
                } else {
                    oss << c;
                }
        }
    }
    return oss.str();
}

// Fallback method to get process name using CreateToolhelp32Snapshot
// This works even when OpenProcess fails (e.g., elevated processes)
std::string GetProcessNameByPID(DWORD pid) {
    HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnapshot == INVALID_HANDLE_VALUE) {
        return "Unknown";
    }

    PROCESSENTRY32W pe32;
    pe32.dwSize = sizeof(PROCESSENTRY32W);

    if (Process32FirstW(hSnapshot, &pe32)) {
        do {
            if (pe32.th32ProcessID == pid) {
                CloseHandle(hSnapshot);
                return WideToUtf8(std::wstring(pe32.szExeFile));
            }
        } while (Process32NextW(hSnapshot, &pe32));
    }

    CloseHandle(hSnapshot);
    return "Unknown";
}

std::optional<ProcessInfo> GetFocusedProcessInfo() {
    // Get the foreground window
    HWND hwnd = GetForegroundWindow();
    if (hwnd == NULL) {
        return std::nullopt;
    }

    // For some applications (especially games), the foreground window might be a child
    // Get the root owner window to ensure we have the main application window
    HWND rootWindow = GetAncestor(hwnd, GA_ROOTOWNER);
    if (rootWindow != NULL) {
        hwnd = rootWindow;
    }

    ProcessInfo info;

    // Get process ID
    GetWindowThreadProcessId(hwnd, &info.pid);

    // Validate that we got a valid PID (not system process)
    if (info.pid == 0 || info.pid == 4) {
        // PID 0 = Idle, PID 4 = System - these are not real applications
        return std::nullopt;
    }

    // Get window title
    wchar_t windowTitle[256];
    GetWindowTextW(hwnd, windowTitle, sizeof(windowTitle) / sizeof(wchar_t));
    info.windowTitle = WideToUtf8(std::wstring(windowTitle));

    // Try to open process with full permissions first
    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, info.pid);

    // If that fails (elevated/protected process), try with limited permissions
    if (hProcess == NULL) {
        hProcess = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, info.pid);
    }

    if (hProcess == NULL) {
        // Still can't get process info (likely elevated process with anti-cheat)
        // Try fallback method using CreateToolhelp32Snapshot
        info.processName = GetProcessNameByPID(info.pid);

        // Filter out system process names
        if (info.processName == "[System Process]" || info.processName == "System") {
            info.processName = "Unknown";
        }

        info.executablePath = "";
        return info;
    }

    // Get executable path
    wchar_t exePath[MAX_PATH];
    DWORD exePathLen = MAX_PATH;
    if (QueryFullProcessImageNameW(hProcess, 0, exePath, &exePathLen)) {
        info.executablePath = WideToUtf8(std::wstring(exePath));

        // Extract process name from path
        std::wstring exePathWStr(exePath);
        size_t lastSlash = exePathWStr.find_last_of(L"\\/");
        if (lastSlash != std::wstring::npos) {
            info.processName = WideToUtf8(exePathWStr.substr(lastSlash + 1));
        } else {
            info.processName = info.executablePath;
        }
    } else {
        // Fallback: try GetModuleFileNameEx
        HMODULE hMod;
        DWORD cbNeeded;
        if (EnumProcessModules(hProcess, &hMod, sizeof(hMod), &cbNeeded)) {
            GetModuleFileNameExW(hProcess, hMod, exePath, MAX_PATH);
            info.executablePath = WideToUtf8(std::wstring(exePath));

            std::wstring exePathWStr(exePath);
            size_t lastSlash = exePathWStr.find_last_of(L"\\/");
            if (lastSlash != std::wstring::npos) {
                info.processName = WideToUtf8(exePathWStr.substr(lastSlash + 1));
            } else {
                info.processName = info.executablePath;
            }
        } else {
            // Last resort: use CreateToolhelp32Snapshot
            info.processName = GetProcessNameByPID(info.pid);

            // Filter out system process names
            if (info.processName == "[System Process]" || info.processName == "System") {
                info.processName = "Unknown";
            }
        }
    }

    CloseHandle(hProcess);

    // Final validation: ensure we have a process name
    if (info.processName.empty()) {
        info.processName = GetProcessNameByPID(info.pid);

        // Filter out system process names
        if (info.processName == "[System Process]" || info.processName == "System") {
            info.processName = "Unknown";
        }
    }

    return info;
}

std::string ProcessInfoToJson(const ProcessInfo& info) {
    std::ostringstream json;
    json << "{";
    json << "\"processName\":\"" << EscapeJson(info.processName) << "\",";
    json << "\"pid\":" << info.pid << ",";
    json << "\"windowTitle\":\"" << EscapeJson(info.windowTitle) << "\",";
    json << "\"executablePath\":\"" << EscapeJson(info.executablePath) << "\"";
    json << "}";
    return json.str();
}
