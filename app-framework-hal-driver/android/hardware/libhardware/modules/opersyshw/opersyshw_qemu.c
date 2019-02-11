#define  LOG_TAG  "opersyshw_qemu"                                                                                 
#include <cutils/log.h>
#include <cutils/sockets.h>                                                                                        
#include <sys/types.h>                                                                                             
#include <sys/stat.h>                                                                                              
#include <fcntl.h>
#include <hardware/opersyshw.h>                                                                                    
#include <malloc.h>                                                                                                
 
#define   OPERSYSHW_DEBUG   1                                                                                      
 
#if OPERSYSHW_DEBUG
#  define D(...)   ALOGD(__VA_ARGS__)                                                                              
#else
#  define D(...)   ((void)0)                                                                                       
#endif                                                                                                             
 
static int fd = 0;                                                                                                 
 
 static int opersyshw__read(char* buffer, int length)                                                               
 {   
      int retval;                                                                                                    
      
      D("OPERSYS HW - read()for %d bytes called", length);                                                           
      
      retval = read(fd, buffer, length);    
      D("read data from driver: %s", buffer);
  
      return retval;
 }
     
 static int opersyshw__write(char* buffer, int length)
 {
      int retval;
  
      D("OPERSYS HW - write()for %d bytes called", length);
  
      retval = write(fd, buffer, length);
      D("write data to driver: %s", buffer);
  
      return retval;
  }
  
  static int opersyshw__close(void)
  {
      if (fd != -1) {
          if (!close(fd)) {
              return 0;
         }
      }
  
      return -1;
  }
  
  static int opersyshw__test(int value)
  {
      return value;
  }
  
  static int open_opersyshw(const struct hw_module_t* module, char const* name,
          struct hw_device_t** device)
  {
      struct opersyshw_device_t *dev = malloc(sizeof(struct opersyshw_device_t));
      if (!dev) {
          D("OPERSYS HW failed to malloc memory !!!");
          return -1;
      }
  
      memset(dev, 0, sizeof(*dev));
  
      dev->common.tag = HARDWARE_DEVICE_TAG;
      dev->common.version = 0;
      dev->common.module = (struct hw_module_t*)module;
      dev->read = opersyshw__read;
      dev->write = opersyshw__write;
      dev->close = opersyshw__close;
      dev->test = opersyshw__test;
 
      *device = (struct hw_device_t*) dev;
  
      fd = open("/dev/circchar", O_RDWR);
      if (fd < 0) {
          D("failed to open /dev/circchar!");
          return 0;
      }
  
      D("OPERSYS HW has been initialized");
  
      return 0;
  }
  
  static struct hw_module_methods_t opersyshw_module_methods = {
      .open = open_opersyshw,
  };
  
  struct hw_module_t HAL_MODULE_INFO_SYM = {
      .tag = HARDWARE_MODULE_TAG,
      .version_major = 1,
      .version_minor = 0,
     .id = OPERSYSHW_HARDWARE_MODULE_ID,
     .name = "Opersys HW Module",
     .author = "Opersys inc.",
     .methods = &opersyshw_module_methods,
 };
