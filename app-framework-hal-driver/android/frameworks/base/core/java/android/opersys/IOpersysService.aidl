package android.opersys;

/** @hide */

interface IOpersysService 
{

 String read(int maxLength);
 int write(String mString);
}
