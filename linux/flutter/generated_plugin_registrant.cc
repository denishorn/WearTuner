//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dynamic_color/dynamic_color_plugin.h>
#include <flutter_audio_capture/flutter_audio_capture_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) dynamic_color_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DynamicColorPlugin");
  dynamic_color_plugin_register_with_registrar(dynamic_color_registrar);
  g_autoptr(FlPluginRegistrar) flutter_audio_capture_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterAudioCapturePlugin");
  flutter_audio_capture_plugin_register_with_registrar(flutter_audio_capture_registrar);
}
