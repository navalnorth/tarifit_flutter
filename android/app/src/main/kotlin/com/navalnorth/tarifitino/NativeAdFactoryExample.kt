package com.navalnorth.tarifitino

import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryExample(private val inflater: LayoutInflater) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView = inflater.inflate(R.layout.native_ad_image, null) as NativeAdView

        // Image principale
        val imageView = adView.findViewById<ImageView>(R.id.ad_image)
        val image = nativeAd.images.firstOrNull()?.drawable
        imageView.setImageDrawable(image)
        adView.imageView = imageView
        
        return adView
    }
}