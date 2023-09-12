//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_window_close/flutter_window_close_plugin.h>
<<<<<<< Updated upstream
#include <screen_retriever/screen_retriever_plugin.h>
=======
#include <share_plus/share_plus_windows_plugin_c_api.h>
>>>>>>> Stashed changes
#include <url_launcher_windows/url_launcher_windows.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterWindowClosePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWindowClosePlugin"));
<<<<<<< Updated upstream
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
=======
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
>>>>>>> Stashed changes
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
