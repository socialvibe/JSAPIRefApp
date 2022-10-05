package com.jsapirefapp.app

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity


class WebViewActivity : AppCompatActivity() {
    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web_view)

        val myWebView: WebView = findViewById(R.id.webview)

        myWebView.settings.javaScriptEnabled = true
        myWebView.settings.allowContentAccess = true

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

        myWebView.loadUrl("file:///android_asset/index.html");
    }
}