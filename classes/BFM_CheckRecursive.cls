public class BFM_CheckRecursive {
    public static boolean firstRun = true;
    public static boolean firstRun1 = true;
    public static boolean firstRun2 = true;
    public static boolean firstRun3= true;
    //public static boolean nfsRun= true;
     
    public static boolean nfsRun = true;
    public static boolean runOnce(){
        if(nfsRun){
         nfsRun=false;
         return true;
        }else{
            return nfsRun;
        }
    }
 }