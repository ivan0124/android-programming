#define LOG_TAG "OpersysServiceJNI"
   
#include "jni.h"
#include "JNIHelp.h"
#include "android_runtime/AndroidRuntime.h"
 
#include <utils/misc.h>
#include <utils/Log.h>
#include <hardware/hardware.h>
#include <hardware/opersyshw.h>
 
#include <stdio.h>
 
namespace android
{
 
  opersyshw_device_t* opersyshw_dev;
  
 static jlong init_native(JNIEnv *env, jobject)
 {

      int err;
      hw_module_t* module;
      opersyshw_device_t* dev = NULL;
  
      ALOGI("init_native()"); 

      err = hw_get_module(OPERSYSHW_HARDWARE_MODULE_ID, (hw_module_t const**)&module);

      if (err == 0) {
          if (module->methods->open(module, "", ((hw_device_t**) &dev)) != 0) {
              ALOGE("Can't open opersys module!!!");
              return 0;
          }
      } else {
          ALOGE("Can't get opersys module!!!");
          return 0;
      }
  
      return (jlong)dev;
  }
  
  static void finalize_native(JNIEnv *env, jobject, jlong ptr)
  {
      opersyshw_device_t* dev = (opersyshw_device_t*)ptr;
  
      //ALOGI("finalize_native()");
  
      if (dev == NULL) {
          return;
      }
  
      dev->close();
  
      free(dev);
  }
 
  static jint read_native(JNIEnv *env, jobject , jlong ptr, jbyteArray buffer)
  {
      opersyshw_device_t* dev = (opersyshw_device_t*)ptr;
      jbyte* real_byte_array;
      int length;
  
      //ALOGI("read_native()");
  
      real_byte_array = env->GetByteArrayElements(buffer, NULL);
  
      if (dev == NULL) {
          return 0;
      }
  
      length = dev->read((char*) real_byte_array, env->GetArrayLength(buffer));
  
      ALOGI("read data from hal: %s", (char *)real_byte_array);
  
      env->ReleaseByteArrayElements(buffer, real_byte_array, 0);
  
      return length;
  }

 
  static jint write_native(JNIEnv *env, jobject , jlong ptr, jbyteArray buffer)
  {
      opersyshw_device_t* dev = (opersyshw_device_t*)ptr;
      jbyte* real_byte_array;
      int length;
  
      //ALOGI("write_native()");
  
      real_byte_array = env->GetByteArrayElements(buffer, NULL);
  
      if (dev == NULL) {
          return 0;
      }
  
      length = dev->write((char*) real_byte_array, env->GetArrayLength(buffer));
  
      ALOGI("write data to hal: %s", (char *)real_byte_array);
  
      env->ReleaseByteArrayElements(buffer, real_byte_array, 0);
  
      return length;
 }
 
 
 static jint test_native(JNIEnv *env, jlong ptr, int value)
 {

     opersyshw_device_t* dev = (opersyshw_device_t*)ptr;
 
     if (dev == NULL) {
         return 0;
     }
 
     ALOGI("test_native()");
 
     return 0;
 }

 static const JNINativeMethod method_table[] = {
     { "init_native", "()J", (void*)init_native },
     { "finalize_native", "(J)V", (void*)finalize_native },
     { "read_native", "(J[B)I", (void*)read_native },
     { "write_native", "(J[B)I", (void*)write_native },
     { "test_native", "(JI)I", (void*)test_native}
 };
 
 int register_android_server_opersys_OpersysService(JNIEnv *env)
 {
     return jniRegisterNativeMethods(env, "com/android/server/opersys/OpersysService",
             method_table, NELEM(method_table));
 
 };

}
