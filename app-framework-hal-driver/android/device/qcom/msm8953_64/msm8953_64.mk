DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8953_64/overlay

TARGET_USES_QCOM_BSP := true
#BOARD_HAVE_QCOM_FM := true
# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
TARGET_USES_NQ_NFC := false
TARGET_KERNEL_VERSION := 3.18
#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# media_profiles and media_codecs xmls for msm8953
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/msm8953_32/media/media_profiles_8953.xml:system/etc/media_profiles.xml \
                      device/qcom/msm8953_32/media/media_codecs_8953.xml:system/etc/media_codecs.xml \
                      device/qcom/msm8953_32/media/media_codecs_performance_8953.xml:system/etc/media_codecs_performance.xml
endif

PRODUCT_COPY_FILES += device/qcom/msm8953_64/whitelistedapps.xml:system/etc/whitelistedapps.xml \
                      device/qcom/msm8953_64/gamedwhitelist.xml:system/etc/gamedwhitelist.xml

PRODUCT_PROPERTY_OVERRIDES += \
           dalvik.vm.heapminfree=4m \
           dalvik.vm.heapstartsize=16m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := msm8953_64
PRODUCT_DEVICE := msm8953_64
#PRODUCT_BRAND := Android
#PRODUCT_MODEL := msm8953 for arm64
PRODUCT_BRAND := Askey
PRODUCT_MODEL := CDR7010
PRODUCT_DEFAULT_DEV_CERTIFICATE := device/askey/sign_keys/testkey

PRODUCT_BOOT_JARS += tcmiface

ifneq ($(strip $(QCPATH)),)
PRODUCT_BOOT_JARS += WfdCommon
#PRODUCT_BOOT_JARS += com.qti.dpmframework
#PRODUCT_BOOT_JARS += dpmapi
#PRODUCT_BOOT_JARS += com.qti.location.sdk
#Android oem shutdown hook
PRODUCT_BOOT_JARS += oem-services
endif

#ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
PRODUCT_BOOT_JARS += qcom.fmradio
#endif #BOARD_HAVE_QCOM_FM

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

# When can normal compile this module,  need module owner enable below commands 
# font rendering engine feature switch
-include $(QCPATH)/common/config/rendering-engine.mk
ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
    MULTI_LANG_ENGINE := REVERIE
#    MULTI_LANG_ZAWGYI := REVERIE
endif



#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES += opersyshw.default

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8953/msm8953.mk

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app

PRODUCT_PACKAGES += wcnss_service

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8953_64/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf

#wlan driver
PRODUCT_COPY_FILES += \
    device/qcom/msm8953_64/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8953_32/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat \
    device/qcom/msm8953_64/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

# Feature definition files for msm8953
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml

PRODUCT_PACKAGES += telephony-ext
PRODUCT_BOOT_JARS += telephony-ext

# Defined the locales
PRODUCT_LOCALES += th_TH vi_VN tl_PH hi_IN ar_EG ru_RU tr_TR pt_BR bn_IN mr_IN ta_IN te_IN zh_HK \
        in_ID my_MM km_KH sw_KE uk_UA pl_PL sr_RS sl_SI fa_IR kn_IN ml_IN ur_IN gu_IN or_IN zh_CN

# When can normal compile this module, need module owner enable below commands
# Add the overlay path
PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
        $(QCPATH)/qrdplus/globalization/multi-language/res-overlay \
        $(PRODUCT_PACKAGE_OVERLAYS)

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Sensor HAL conf file
 PRODUCT_COPY_FILES += \
     device/qcom/msm8953_64/sensors/hals.conf:system/etc/sensors/hals.conf

# Disable Verity boot feature
PRODUCT_SUPPORTS_VERITY := true

# Include thermal HAL shared library
PRODUCT_PACKAGES += \
      thermal.default        

# Enable logdumpd service only for non-perf bootimage
ifeq ($(findstring perf,$(KERNEL_DEFCONFIG)),)
    ifeq ($(TARGET_BUILD_VARIANT),user)
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=0
    else
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=1
    endif
else
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
        ro.logdumpd.enabled=0
endif

#FEATURE_OPENGLES_EXTENSION_PACK support string config file


# leo exfat
PRODUCT_PACKAGES += \
       libexfat \
       dumpexfat \
       fsck.exfat \
       exfat.label \
       mkfs.exfat \
       mount.exfat \
       libfuse

PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml

CAMERA_BOOT_OPTS := true

# Copy file into askey_ota_sh
PRODUCT_COPY_FILES += \
        $(call find-copy-subdir-files,*,$(LOCAL_PATH)/../../../vendor/askey/askey_ota_shell/bin,askey_ota_sh/bin) \
        $(call find-copy-subdir-files,*,$(LOCAL_PATH)/../../../vendor/askey/askey_ota_shell/lib64,askey_ota_sh/lib64)


# Copy voice file into jkc
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*.wav,$(LOCAL_PATH)/../../../vendor/JKC/JKCVoice,jkc/VoiceGuidanceFile/ja) \
	$(call find-copy-subdir-files,*.ogg,$(LOCAL_PATH)/../../../vendor/JKC/JKCVoice,jkc/VoiceGuidanceFile/ja) \
	$(call find-copy-subdir-files,*.txt,$(LOCAL_PATH)/../../../vendor/JKC/JKCVoice,jkc/VoiceGuidanceFile/)

# Copy open source file page background
PRODUCT_COPY_FILES += \
    vendor/askey/Resource/bg_menu_main_small.png:system/etc/bg_menu_main_small.png

# Harvey
ifeq ($(BUILD_PRODUCT_PACKAGES), JKC)
    PRODUCT_PACKAGES += askeylog
    PRODUCT_PACKAGES += DashCam
    PRODUCT_PACKAGES += FileManagement
    PRODUCT_PACKAGES += AMediaplayer
    PRODUCT_PACKAGES += ASettings
    PRODUCT_PACKAGES += AVoIP
    PRODUCT_PACKAGES += FactoryAPP
    PRODUCT_PACKAGES += GpsTest
    PRODUCT_PACKAGES += gps.default
    PRODUCT_PACKAGES += SensorCalibration
    PRODUCT_PACKAGES += JKCComm
    PRODUCT_PACKAGES += JKCEventDetect
    PRODUCT_PACKAGES += JKCEventSending
    PRODUCT_PACKAGES += JKCTTS
    PRODUCT_PACKAGES += JKCVersionUp
    PRODUCT_PACKAGES += Fake_JKCVoip
else
    PRODUCT_PACKAGES += askeylog
    PRODUCT_PACKAGES += DashCam
    PRODUCT_PACKAGES += FileManagement
    PRODUCT_PACKAGES += AMediaplayer
    PRODUCT_PACKAGES += ASettings
    PRODUCT_PACKAGES += AVoIP
    PRODUCT_PACKAGES += FactoryAPP
    PRODUCT_PACKAGES += GpsTest
    PRODUCT_PACKAGES += gps.default
    PRODUCT_PACKAGES += SensorCalibration
    PRODUCT_PACKAGES += Fake_JKCComm
    PRODUCT_PACKAGES += Fake_JKCEventDetect
    PRODUCT_PACKAGES += Fake_JKCEventSending
    PRODUCT_PACKAGES += Fake_JKCTTS
    PRODUCT_PACKAGES += Fake_JKCVersionUp
    PRODUCT_PACKAGES += Fake_JKCVoip

endif

# PUCDR-1981 don't filter system logs so that chatty won't prune
#      dashcam/filemanagement logs
PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
    ro.logd.filter="1000"
# PUCDR-1981 END

