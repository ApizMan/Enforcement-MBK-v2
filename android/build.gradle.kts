import org.gradle.api.tasks.Delete
import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Custom build directory setup
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Workaround for flutter_bluetooth_serial: force compileSdk 31+ in old plugins
subprojects {
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension is BaseExtension) {
            val currentSdk = androidExtension.compileSdkVersion?.toIntOrNull()
            if (currentSdk != null && currentSdk < 31) {
                logger.error(
                    """
                    Warning: Overriding compileSdk version in Flutter plugin: ${project.name}
                    from $currentSdk to 31 (to fix android:attr/lStar issue).
                    """.trimIndent()
                )
                androidExtension.compileSdkVersion = "31"
            }
        }

        project.layout.buildDirectory.set(
            rootProject.layout.buildDirectory.dir(project.name).get()
        )

        // ❌ Removed: project.evaluationDependsOn(":app") to prevent circular reference
    }
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
