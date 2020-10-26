package com.example.awesome_notification_example_fcm

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback

class Application : FlutterApplication(), PluginRegistrantCallback {

  override fun onCreate() {
    super.onCreate()
  }

  override fun registerWith(registry: PluginRegistry?) {
  }
}