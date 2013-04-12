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



function get_main_xml() {
  return "<data><profile_image_src>thb12.jpg</profile_image_src>" +
         "<first_name>Thomas</first_name><last_name>Burnell</last_name>" +
         "<login>thb12</login><category>c1</category>" +
         "<candidate_number>123456</candidate_number><cid>654321</cid>" +
         "<personal_tutor>Ian Hodkinson</personal_tutor></data>";
}

function get_exercises_xml() {
  return "dealt with exercises";
}

function get_grades_xml() {
  return "dealt with grades";
}