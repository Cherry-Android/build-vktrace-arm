VkTrace Trace and Replay - Android

The trace program is named **vktrace**. It is used to record an application's Vulkan API calls to a trace file. The call information is stored in the trace file in a compact binary format. The trace files normally have a .vktrace suffix. The application can be either a local or remote application.

**Tracing**

After building, please follow the steps below to trace an app. Make sure the device is online in 'adb devices'.

    1)  adb root
    2)  adb shell setenforce 0
    3)  adb shell rm -rf /data/local/debug/vulkan
    4)  adb shell mkdir -p /data/local/debug/vulkan

    # trace 64-bit Vulkan APK
    5)  adb push android/trace_layer/arm64-v8a/libVkLayer_vktrace_layer.so /data/local/debug/vulkan/

    6)  adb shell setprop debug.vulkan.layer.1 VK_LAYER_LUNARG_vktrace
    7)  adb reverse localabstract:vktrace tcp:34201
    8)  dbuild_x64/x64/bin/vktrace -v full -o <filename>.vktrace

    9)  # Optional: Trim/Fast forward
        # Set trim frame range (trim start frame and trim end frame)
        adb shell setprop VKTRACE_TRIM_TRIGGER "frames-<start_frame>-<end_frame>"
    10) # Optional: Force using FIFO present mode in vkCreateInstance.
        adb shell setprop VKTRACE_FORCE_FIFO 1

    11) # Run the app on android to start tracing
    12) # Shutdown the app to stop tracing
        adb shell am force-stop <app's package name>

    # Acceleration Structure Related Environment Variable
    adb shell setprop VKTRACE_ENABLE_REBINDMEMORY_ALIGNEDSIZE 1
    adb shell setprop VKTRACE_AS_BUILD_RESIZE 2

    # optional for acceleration structure
    adb shell setprop VKTRACE_PAGEGUARD_ENABLE_SYNC_GPU_DATA_BACK  1
    adb shell setprop VKTRACE_DELAY_SIGNAL_FENCE_FRAMES  3

**Replay**

After building, please follow the steps below to replay a trace file.

    1) adb uninstall com.example.vkreplay
    2) adb install -g build-android/android/retracer/vkreplay.apk
    3) adb shell setprop debug.vulkan.layer.1 '""'
    4) adb push <filename>.vktrace /sdcard/<filename>.vktrace

    5) adb shell am start -a android.intent.action.MAIN -c android-intent.category.LAUNCH -n com.example.vkreplay/android.app.NativeActivity --es args '"-v full -o /sdcard/<filename>.vktrace"'

    6) # Optional: Take screenshots
       adb shell am start -a android.intent.action.MAIN -c android-intent.category.LAUNCH -n com.example.vkreplay/android.app.NativeActivity --es args '"-v full -o /sdcard/<filename>.vktrace -s <string>"'
       #     The <string> is one of following three options:
       #         1. comma separated list of frames (e.g. 0,1,2)
       #         2. <start_frame_index>-<count>-<interval> (e.g. 0-3-1 to take 3 screenshots for every 1 frame from frame 0)
       #         3. "all" (take screenshot for every frame)
       #     Note: Screenshots can be found in /sdcard/Android/ with name <frame index>.ppm
    7) # Optional: Force stop the replayer during retracing.
       adb shell am force-stop com.example.vkreplay

For more detail, please read at [Link](https://github.com/ARM-software/vktrace-arm/blob/master/USAGE_android.md)
