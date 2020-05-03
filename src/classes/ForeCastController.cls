public class ForeCastController {
     public ForeCastController(ApexPages.StandardController controller){
//system.debug('forecastObj '+getforcastString());
         }
public class forcastRow{
        public String Id{get;private set;}
        public String Name{get;private set;}
        public Date EndDate{get;private set;}        
    }

/****** Wrapper class to hold multiple json data strings *****/
    public class JsonforcastWrapper{
        public List<forcastRow> data{get; private set;}
    }
}