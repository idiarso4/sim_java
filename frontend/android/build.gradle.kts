// Top-level build file where you can add configuration options common to all sub-projects/modules.
@Suppress("DSL_SCOPE_VIOLATION") // False positive warning
plugins {
    // Keep these in sync with the versions in settings.gradle.kts
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android) apply false
    alias(libs.plugins.kotlin.serialization) apply false
}

// This block must be placed after the plugins block
buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

// Configure all projects (including the root project)
allprojects {
    // Apply common repository configuration to all projects
    repositories {
        google()
        mavenCentral()
    }
    
    // Configure build directory for all subprojects
    if (project != rootProject) {
        project.layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name).get())
    }
}

// Clean task for the root project
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Make all subprojects depend on the app project for evaluation
subprojects {
    if (path != ":app") {
        evaluationDependsOn(":app")
    }
}
