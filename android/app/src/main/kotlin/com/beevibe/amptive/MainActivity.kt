package com.beevibe.amptive

import android.content.Context
import android.graphics.Color
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.PopupMenu
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

private class NativeContextMenuButtonFactory(
    private val channel: MethodChannel
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        @Suppress("UNCHECKED_CAST")
        val arguments = args as? Map<String, Any?> ?: emptyMap()
        return NativeContextMenuButtonView(context, arguments, channel)
    }
}

private class NativeContextMenuButtonView(
    context: Context,
    arguments: Map<String, Any?>,
    private val channel: MethodChannel
) : PlatformView {
    private val requestId = arguments["requestId"] as? String ?: ""
    private val action = arguments["action"] as? String ?: "Follow"
    private val container = FrameLayout(context).apply {
        setBackgroundColor(Color.TRANSPARENT)
        isClickable = true
        isFocusable = true
        contentDescription = "Community options"
        setOnClickListener { showMenu() }
    }

    private fun showMenu() {
        val popup = PopupMenu(container.context, container, Gravity.END)
        popup.menu.add(0, 1, 0, action)
        popup.menu.add(0, 2, 1, "View Community")
        popup.setOnMenuItemClickListener { item ->
            channel.invokeMethod(
                "selected",
                mapOf("requestId" to requestId, "action" to item.title.toString())
            )
            true
        }
        popup.show()
    }

    override fun getView(): View = container

    override fun dispose() {
        container.setOnClickListener(null)
    }
}

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "amptive/native_context_menu"
        )
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "amptive/native_context_menu_button",
            NativeContextMenuButtonFactory(channel)
        )
    }
}
