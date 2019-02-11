package com.android.server.opersys;
 
import android.content.Context;
import android.os.Handler;
import android.opersys.IOpersysService;
import android.os.Looper;
import android.os.Message;
import android.os.Process;
import android.util.Slog;
import android.os.RemoteException;
 
public class OpersysService extends IOpersysService.Stub {

     private static final String TAG = "OpersysService";
     private Context mContext;
     private long mNativePointer;
 
     public OpersysService(Context context) {
         super();
         mContext = context;
         Slog.i(TAG, "Opersys Service started");
 
         mNativePointer = init_native();
 
         Slog.i(TAG, "test() returns " + test_native(mNativePointer, 20));
     }
 
     protected void finalize() throws Throwable {
         finalize_native(mNativePointer);
         super.finalize();
     }    
     
     public String read(int maxLength) throws RemoteException
     {
         int length;
         byte[] buffer = new byte[maxLength];
 
         length = read_native(mNativePointer, buffer);
 
         try {
             return new String(buffer, 0, length, "UTF-8");
         } catch (Exception e) {
             Slog.e(TAG, "read buffer error!");
             return null;
         }
     }
 
     public int write(String mString) throws RemoteException
     {
         byte[] buffer = mString.getBytes();
 
         return write_native(mNativePointer, buffer);
     }
 
     private static native long init_native();
     private static native void finalize_native(long ptr);
     private static native int read_native(long ptr, byte[] buffer);
     private static native int write_native(long ptr, byte[] buffer);
     private static native int test_native(long ptr, int value);

}

