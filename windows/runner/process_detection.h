#ifndef RUNNER_PROCESS_DETECTION_H_
#define RUNNER_PROCESS_DETECTION_H_

#include <windows.h>
#include <string>
#include <optional>

// Structure to hold process information
struct ProcessInfo {
    std::string processName;
    DWORD pid;
    std::string windowTitle;
    std::string executablePath;
};

// Get information about the currently focused window's process
std::optional<ProcessInfo> GetFocusedProcessInfo();

// Convert ProcessInfo to JSON string
std::string ProcessInfoToJson(const ProcessInfo& info);

#endif  // RUNNER_PROCESS_DETECTION_H_
