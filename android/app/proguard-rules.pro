# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Kotlin coroutines and standard classes required by shared_preferences_android JNI bindings
-keep class kotlin.Unit { *; }
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.coroutines.intrinsics.CoroutineSingletons { *; }
-keep class kotlin.coroutines.intrinsics.IntrinsicsKt { *; }

# Keep JNI plugin and sharedpreferences plugin classes
-keep class com.github.dart_lang.jni.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class androidx.datastore.** { *; }

# General metadata attribute preservation required for Kotlin reflection/JNI
-keepattributes *Annotation*, RuntimeVisible*Annotations, Metadata, InnerClasses, EnclosingMethod
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-dontwarn com.github.dart_lang.jni.**
