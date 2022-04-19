global class ucl_serviceSchedule implements Schedulable {
    global void execute(SchedulableContext SC) {
       ucl_service service = new ucl_service(); 
    }
     
    public static String CRON = '0 0 21 * * ? *';
     
    public static String doSchedule(){
        ucl_serviceSchedule sc = new ucl_serviceSchedule();
        String jobId = System.schedule('Scheduler', CRON, sc);
        return jobId;
    }
 }