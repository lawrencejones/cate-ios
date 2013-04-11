function tryDelay() {
  tryDelayHelp();
  
  /*
  if (error occurs) {
    return "error";
  }
  */
  
  return "done";
}

function tryDelayHelp() {
  var k = 0;
  
  for (i = 0; i < 100000; i++) {
    for (j = 0; j < 10000; j++) {
      k++;
    }
  }
  
  return k;
}



/*
 This is an example of what this script will look like:
 
 function dealWithDashboard() {
   # scrapes the dashboard page
   # formats data as xml

   return xml
 }
 
 function dealWithExercises() {
   # scrapes the exercises page
   # formats data as xml
 
   return xml
 }
 
 function dealWithGrades() {
   # scrapes the grades page
   # formats data as xml
 
   return xml
 }
 
*/

function dealWithDashboard() {
  return "dealt with dashboard";
}

function dealWithExercises() {
  return "dealt with exercises";
}

function dealWithGrades() {
  return "dealt with grades";
}