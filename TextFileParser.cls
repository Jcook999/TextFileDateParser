public class TextFileParser {
    
    @InvocableMethod(label='Get Date from Invite' description='Returns a start date value from an invite attachment on a case email')
    public static list<DateResult> parseDateValue(list<InputParameters> params){
        
		//convert the text attachment into a string variable
        string versionDataString = params[0].contentVersionRecord.versionData.toString();
        
        //calculate the start and end index based on the input strings
        integer subStart = versionDataString.indexOf(params[0].startString);
        integer subEnd = versionDataString.indexOf(params[0].endString);
            
        //create the dateString variable and remove the start index text from the string
        string dateString = versionDataString.mid(subStart, subEnd - subStart);
        dateString = dateString.replace(params[0].startString,'');
        
        //calculate the year, month, day, hour, minute, and second by pulling midStrings from the main string
        integer dateYear = integer.valueOf(dateString.left(4));
        integer dateMonth = integer.valueOf(dateString.mid(4,2));
        integer dateDay = integer.valueOf(dateString.mid(6,2));
        integer timeHour = integer.valueOf(dateString.mid(9,2));
        integer timeMinute = integer.valueOf(dateString.mid(11,2));
        integer timeSecond = integer.valueOf(dateString.mid(13,2));
        
        //build a new date using the year, month, and date integers
        date newDate = date.newInstance(dateYear,dateMonth,dateDay);
        
        //build a new time using the hour, minute, and second integers
        time newTime = time.newInstance(timeHour,timeMinute,timeSecond,0);
        
        //combine date and time into a dateTime variable
        dateTime newDateTime = dateTime.newInstance(newDate, newTime);
        
        //create the list variable to hold the results
        list<DateResult> result = new list<DateResult>();
        
        //create a new DateResult, give it a dateValue and add it to the list of DateResults
        DateResult dr = new DateResult();
        dr.dateValue = newDateTime;
        result.add(dr);
        
        //return the DateTime Results
        return result;
    }
    
    //input parameters for the Apex action
    public class InputParameters{
        @InvocableVariable(label='Content Version Record' required = true )
        public contentVersion contentVersionRecord;
        
        @InvocableVariable(label='the text leading up to the date portion' required = true )
        public string startString;
        
        @InvocableVariable(label='the text immediately after the date portion' required = true )
        public string endString;
    }
    
    //output parameters of the Apex action
    public class DateResult{
        @InvocableVariable(label='Date Value')
	public dateTime dateValue;        
    }

}
