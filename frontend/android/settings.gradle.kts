pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "android"
include(":app")

// Handle Flutter SDK configuration
val flutterSdkPath = providers.gradleProperty("flutter.sdk").orNull
    ?: System.getenv("FLUTTER_ROOT")
    ?: findFlutterSdkFromLocalProperties()

if (flutterSdkPath != null) {
    apply {
        from("${flutterSdkPath}/packages/flutter_tools/gradle/app_plugin_loader.gradle")
    }
    
    // Include Flutter plugins
    val flutterProjectRoot = rootProject.projectDir.parentFile.toPath()
    val plugins = File(
        "${flutterProjectRoot}/.flutter-plugins-dependencies"
    )
    if (plugins.exists()) {
        println("Flutter plugins found, applying plugin loader")
        try {
            includeBuild("${flutterSdkPath}/packages/flutter_tools/gradle") {
                name = "flutter-plugin-loader"
                dependencySubstitution {
                    substitute(module("dev.flutter:flutter-plugin-loader"))
                        .using(project(":"))
                }
            }
        } catch (e: Exception) {
            println("Warning: Failed to include flutter plugin loader: ${e.message}")
        }
    }
} else {
    println("Flutter SDK not found. Please set flutter.sdk in local.properties or FLUTTER_ROOT in environment variables.")
    println("Building without Flutter integration.")
}

// Function to find Flutter SDK from local.properties
fun findFlutterSdkFromLocalProperties(): String? {
    val properties = java.util.Properties()
    val localPropertiesFile = File(rootProject.projectDir, "local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { properties.load(it) }
        return properties.getProperty("flutter.sdk")
    }
    return null
}
