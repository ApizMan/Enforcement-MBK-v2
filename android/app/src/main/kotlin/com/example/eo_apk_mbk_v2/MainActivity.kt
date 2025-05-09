package com.example.eo_apk_mbk_v2

import android.content.ContentResolver
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.eo_apk_mbk_v2/gallery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "deleteFromGallery") {
                val fileName = call.argument<String>("fileName")
                if (fileName != null) {
                    val success = deleteImageFromGallery(fileName)
                    result.success(success)
                } else {
                    result.error("INVALID_ARGUMENT", "fileName is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun deleteImageFromGallery(fileName: String): Boolean {
        val contentResolver: ContentResolver = contentResolver
        val uri: Uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val selection = "${MediaStore.Images.Media.DISPLAY_NAME}=?"
        val selectionArgs = arrayOf(fileName)

        val deletedRows = contentResolver.delete(uri, selection, selectionArgs)
        return deletedRows > 0
    }
}
