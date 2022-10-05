package com.jsapirefapp.app

import android.annotation.SuppressLint
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.webkit.WebView
import android.widget.Button

class WebViewPopUpActivity : AppCompatActivity() {
    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web_view_pop_up)


        val popupWebView: WebView = findViewById(R.id.popupWebView)

        val closeButton: Button = findViewById(R.id.popupCloseButton)

        closeButton.setOnClickListener {
            finish()
        }

        val urlStr:String = intent.getStringExtra("url").toString()
        print(urlStr)
        popupWebView.settings.javaScriptEnabled = true
        popupWebView.settings.allowContentAccess = true
        popupWebView.loadUrl(urlStr)
    }
}