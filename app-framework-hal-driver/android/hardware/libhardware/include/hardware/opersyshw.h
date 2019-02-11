#ifndef ANDROID_OPERSYSHW_INTERFACE_H
#define ANDROID_OPERSYSHW_INTERFACE_H
 
#include <stdint.h>
#include <sys/cdefs.h>
#include <sys/types.h>
 
#include <hardware/hardware.h>
     
__BEGIN_DECLS
 
#define OPERSYSHW_HARDWARE_MODULE_ID "opersyshw"
 
struct opersyshw_device_t {
     struct hw_device_t common;
 
     int (*read)(char* buffer, int length);
     int (*write)(char* buffer, int length);
     int (*close)(void);
     int (*test)(int value);
 };
 
 __END_DECLS
 
#endif // ANDROID_OPERSYSHW_INTERFACE_H
