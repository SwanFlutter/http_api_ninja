//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <image_picker_master/image_picker_master_plugin_c_api.h>
#include <path_provider_master/path_provider_master_plugin_c_api.h>
#include <platform_version/platform_version_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ImagePickerMasterPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ImagePickerMasterPluginCApi"));
  PathProviderMasterPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PathProviderMasterPluginCApi"));
  PlatformVersionPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PlatformVersionPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
