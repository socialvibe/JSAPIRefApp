package com.jsapirefapp.app

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.webkit.*
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import com.google.android.gms.common.GooglePlayServicesNotAvailableException
import java.io.IOException


class WebViewActivity : AppCompatActivity() {

    private val partnerConfigHash: String = "SET_ME"

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web_view)

        val myWebView: WebView = findViewById(R.id.webview)

        myWebView.settings.javaScriptEnabled = true
        myWebView.settings.allowContentAccess = true
        myWebView.addJavascriptInterface(this, "Android")

        myWebView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
                if (url.startsWith("https")) {
                    val intent = Intent(this@WebViewActivity, WebViewPopUpActivity::class.java)
                    intent.putExtra("url", url)
                    view.context.startActivity(intent)
                }
                return true
            }
        }

        myWebView.webChromeClient = object : WebChromeClient() {
            override fun onConsoleMessage(consoleMessage: ConsoleMessage): Boolean {
                Log.d("WebView", "${consoleMessage.message()} -- From line " +
                        "${consoleMessage.lineNumber()} of ${consoleMessage.sourceId()}")
                return true
            }
        }

        myWebView.loadUrl("file:///android_asset/index.html");
    }

    /** Use this functions for JS script  */
    @JavascriptInterface
    fun getClientID(): String {
        var adInfo: AdvertisingIdClient.Info? = null

        try {
            adInfo = AdvertisingIdClient.getAdvertisingIdInfo(this)
        } catch (e: IOException) {
            e.printStackTrace()
        } catch (e: GooglePlayServicesNotAvailableException) {
            e.printStackTrace()
        }

        val adId: String? = adInfo?.id
        return adId ?: "some_default_value_to_be_provided"
    }

    @JavascriptInterface
    fun getClientHash(): String {
        return partnerConfigHash
    }
}