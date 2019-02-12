# App-Framework-HAL-Driver
This is a sample code. (test on Qualcomm MSM8953)

# Driver Source Code Description
Step1: add ~/android/kernel/msm-3.18/drivers/misc/[circular-char.c](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/kernel/msm-3.18/drivers/misc/circular-char.c)

Step2: the following code is added to ~/android/kernel/msm-3.18/drivers/misc/[Makefile](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/kernel/msm-3.18/drivers/misc/Makefile)
<pre>
#opersys1
obj-y += circular-char.o
#opersys1
</pre>

Step3: Using the following instruction to verify that driver work
<pre>
$ echo hello > dev/circchar
$ cat dev/circchar
#will see the hello
</pre>

# HAL Source Code Description
Step1: add ~/android/hardware/libhardware/include/hardware/[opersyshw.h](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/hardware/libhardware/include/hardware/opersyshw.h)

Step2: add ~/android/hardware/libhardware/modules/opersyshw/[opersyshw_qemu.c](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/hardware/libhardware/modules/opersyshw/opersyshw_qemu.c)

Step3: `opersyshw` is added in ~/android/hardware/libhardware/modules/[Android.mk](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/hardware/libhardware/modules/Android.mk)
<pre>
hardware_modules := gralloc hwcomposer audio nfc nfc-nci local_time \
	power usbaudio audio_remote_submix camera usbcamera consumerir sensors vibrator \
	tv_input fingerprint input vehicle thermal vr LcdThermalProtection opersyshw
include $(call all-named-subdir-makefiles,$(hardware_modules))
</pre>

Step4: `PRODUCT_PACKAGES += opersyshw.default` is added in ~/android/device/qcom/msm8953_64/[msm8953_64.mk](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/device/qcom/msm8953_64/msm8953_64.mk)

# Framework Source Code Description
Step1: add the following cdoe in ~/android/frameworks/base/[Android.mk](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/frameworks/base/Android.mk)
<pre>
        #opersys1
        core/java/android/opersys/IOpersysService.aidl \
        #opersys1
</pre>

Step2: add the following code in ~/android/frameworks/base/core/java/android/app/[SystemServiceRegistry.java](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/frameworks/base/core/java/android/app/SystemServiceRegistry.java)
<pre>
//opersys1
import android.opersys.OpersysManager;
 import android.opersys.IOpersysService;
//opersys1
...
//opersys1
        registerService(Context.OPERSYS_SERVICE, OpersysManager.class,
                 new CachedServiceFetcher<OpersysManager>() {
            @Override
            public OpersysManager createService(ContextImpl ctx) {
                 IBinder b = ServiceManager.getService(Context.OPERSYS_SERVICE);
                 IOpersysService service = IOpersysService.Stub.asInterface(b);
                 if (service == null) {
                     return null;
                 }
                 return new OpersysManager(ctx, service);
            }});
//opersys1
</pre>
# How To Test 

