//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <elevenlabs/elevenlabs_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) elevenlabs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ElevenlabsPlugin");
  elevenlabs_plugin_register_with_registrar(elevenlabs_registrar);
}
