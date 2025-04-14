package com.example.empower_her
import android.util.Log
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.Translator
import com.google.mlkit.nl.translate.TranslatorOptions
import com.google.mlkit.common.model.DownloadConditions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
class Translator {
    private var sourceLang = TranslateLanguage.ENGLISH
    private var targetLang = TranslateLanguage.HINDI
    private lateinit var translator: Translator
    private fun createTranslator() {
        val options = TranslatorOptions.Builder()
            .setSourceLanguage(sourceLang)
            .setTargetLanguage(targetLang)
            .build()
        translator = com.google.mlkit.nl.translate.Translation.getClient(options)
    }
    fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "translateText") {
            val text = call.argument<String>("text") ?: ""
            val fromLang = call.argument<String>("fromLang") ?: "en"
            val toLang = call.argument<String>("toLang") ?: "hi"
            // Set dynamic languages
            sourceLang = getLanguageCode(fromLang)
            targetLang = getLanguageCode(toLang)
            createTranslator()
            val conditions = DownloadConditions.Builder().requireWifi().build()
            translator.downloadModelIfNeeded(conditions)
                .addOnSuccessListener {
                    translator.translate(text)
                        .addOnSuccessListener { translatedText ->
                            result.success(translatedText)
                        }
                        .addOnFailureListener { e ->
                            Log.e("Translator", "Translation failed: ${e.message}")
                            result.error("TRANSLATION_ERROR", "Translation failed", e.message)
                        }
                }
                .addOnFailureListener { e ->
                    Log.e("Translator", "Model download failed: ${e.message}")
                    result.error("DOWNLOAD_ERROR", "Model download failed", e.message)
                }
        } else {
            result.notImplemented()
        }
    }
    private fun getLanguageCode(language: String): String {
        return when (language) {
            "en" -> TranslateLanguage.ENGLISH
            "hi" -> TranslateLanguage.HINDI
            "mr" -> TranslateLanguage.MARATHI
            "gu" -> TranslateLanguage.GUJARATI
            "te" -> TranslateLanguage.TELUGU
            "ta" -> TranslateLanguage.TAMIL
            "bn" -> TranslateLanguage.BENGALI
            else -> TranslateLanguage.ENGLISH // Default to English
        }
    }
}