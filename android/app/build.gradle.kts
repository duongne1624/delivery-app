import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load local.properties
val localProperties = Properties().apply {
    rootProject.file("local.properties").takeIf { it.exists() }?.let { file ->
        FileInputStream(file).use { load(it) }
    }
}
val googleMapsApiKey: String = localProperties.getProperty("GOOGLE_MAPS_API_KEY")
    ?.takeIf { it.isNotBlank() }
    ?: throw GradleException("GOOGLE_MAPS_API_KEY is not defined or empty in local.properties")

android {
    namespace = "com.example.delivery_online_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.delivery_online_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Pass key to strings.xml
        resValue("string", "google_maps_key", googleMapsApiKey)
        // Pass key to AndroidManifest.xml
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // Use debug signing config temporarily; replace with release config for production
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true // Enable code shrinking
            isShrinkResources = true // Enable resource shrinking (requires isMinifyEnabled = true)
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        debug {
            isMinifyEnabled = false // Disable shrinking for debug builds
            isShrinkResources = false // Explicitly disable resource shrinking for debug
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    // Add other dependencies if needed
}

flutter {
    source = "../.."
}
