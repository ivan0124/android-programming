package android.opersys;
 
import android.content.Context;
import android.os.RemoteException;
import android.opersys.IOpersysService;
import android.util.Slog;
 
public class OpersysManager
{
     private static final String TAG = "OpersysManager";
 
     public String read(int maxLength) {
         try {
             return mService.read(maxLength);
         } catch (RemoteException e) {
             Slog.e(TAG, "read error!");
             return null;
         }
     }
 
     public int write(String mString) {
         try {
             return mService.write(mString);
         } catch (RemoteException e) {
             Slog.e(TAG, "write error!");
             return 0;
         }    
     }
 
     public OpersysManager(Context context, IOpersysService service) {
         mService = service;
     }
 
     IOpersysService mService;
}    
