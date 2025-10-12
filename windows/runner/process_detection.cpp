#include "process_detection.h"
#include <psapi.h>
#include <tlhelp32.h>
#include <sstream>
#include <iomanip>
#include <string>
#include <vector>
#include <algorithm>
#include <cctype>

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

// NOTE: Window title extraction removed intentionally.
// Window titles vary by platform/language (e.g., "HELLDIVERS 2" vs "HELLDIVERS 2 (ヘルダイバー2)")
// and cannot be reliably used for game detection across different regions.
// We now rely exclusively on actual process names (e.g., "helldivers2.exe") which are consistent.

// Fallback method to get process name using CreateToolhelp32Snapshot
// This is the most reliable method and works even when OpenProcess fails (e.g., elevated/protected processes)
// This should work for ALL running processes, including games with anti-cheat software
std::string GetProcessNameByPID(DWORD pid) {
    // System and Idle processes should not be processed
    if (pid == 0 || pid == 4) {
        return "Unknown";
    }

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
                std::string processName = WideToUtf8(std::wstring(pe32.szExeFile));

                // Filter out system process names
                if (processName == "[System Process]" || processName == "System") {
                    return "Unknown";
                }

                return processName;
            }
        } while (Process32NextW(hSnapshot, &pe32));
    }

    CloseHandle(hSnapshot);
    return "Unknown";
}

// Alternative method using GetProcessImageFileName
// Less reliable than CreateToolhelp32Snapshot, but can work in some edge cases
std::string GetProcessImageFileNameByPID(DWORD pid) {
    // System and Idle processes should not be processed
    if (pid == 0 || pid == 4) {
        return "";
    }

    HANDLE hProcess = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, pid);
    if (hProcess == NULL) {
        return "";
    }

    wchar_t buffer[MAX_PATH];
    DWORD size = MAX_PATH;

    // Try GetProcessImageFileNameW
    if (GetProcessImageFileNameW(hProcess, buffer, size) > 0) {
        CloseHandle(hProcess);
        std::wstring path(buffer);

        // Extract just the filename from the path
        size_t lastSlash = path.find_last_of(L"\\/");
        if (lastSlash != std::wstring::npos) {
            std::string processName = WideToUtf8(path.substr(lastSlash + 1));

            // Filter out system process names
            if (processName == "[System Process]" || processName == "System") {
                return "";
            }

            return processName;
        }
        return WideToUtf8(path);
    }

    CloseHandle(hProcess);
    return "";
}

std::optional<ProcessInfo> GetFocusedProcessInfo() {
    // Get the foreground window
    HWND hwnd = GetForegroundWindow();
    if (hwnd == NULL) {
        return std::nullopt;
    }

    ProcessInfo info;

    // Get process ID from the foreground window
    GetWindowThreadProcessId(hwnd, &info.pid);

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
        // Try multiple fallback methods in order of reliability

        // Method 1: CreateToolhelp32Snapshot (most reliable, works for all processes)
        info.processName = GetProcessNameByPID(info.pid);

        // Method 2: Try GetProcessImageFileName if toolhelp32 failed
        if (info.processName == "Unknown" || info.processName == "[System Process]" || info.processName == "System") {
            std::string imageName = GetProcessImageFileNameByPID(info.pid);
            if (!imageName.empty() && imageName != "[System Process]" && imageName != "System") {
                info.processName = imageName;
            } else {
                // If all methods fail, keep it as "Unknown" - DO NOT extract from window title
                info.processName = "Unknown";
            }
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
            // Use fallback methods in order of reliability
            info.processName = GetProcessNameByPID(info.pid);

            // Try GetProcessImageFileName if toolhelp32 failed
            if (info.processName == "Unknown" || info.processName == "[System Process]" || info.processName == "System") {
                std::string imageName = GetProcessImageFileNameByPID(info.pid);
                if (!imageName.empty() && imageName != "[System Process]" && imageName != "System") {
                    info.processName = imageName;
                } else {
                    // Keep as "Unknown" if all methods fail
                    info.processName = "Unknown";
                }
            }
        }
    }

    CloseHandle(hProcess);

    // Final validation: ensure we have a process name
    if (info.processName.empty() || info.processName == "[System Process]" || info.processName == "System") {
        // Try all fallback methods in order of reliability
        info.processName = GetProcessNameByPID(info.pid);

        if (info.processName == "Unknown" || info.processName == "[System Process]" || info.processName == "System") {
            std::string imageName = GetProcessImageFileNameByPID(info.pid);
            if (!imageName.empty() && imageName != "[System Process]" && imageName != "System") {
                info.processName = imageName;
            } else {
                // Keep as "Unknown" if all reliable methods fail
                info.processName = "Unknown";
            }
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
