# TextFileDateParser
Apex Action called by flows to allow the parsing of a date value from a .ICS file.
## Input Parameters:   
  - label='Content Version Record' required:true
    - Description: a Content Version record variable. 
  - label='the text leading up to the date portion' required = true  
    - Description: Indicates the text value that will be used to locate the start of the date value to be parsed out.  
  - label='the text immediately after the date portion' required = true 
    - Description: Indicates the text value that will be used to locate the end of the date value to be parsed out.  
## Output Parameters:  
  - label='Date Value'  
    - Description: The DateTime value that gets returned by the parser.
