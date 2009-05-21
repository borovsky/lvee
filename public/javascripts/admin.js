function mark_all_users() {
  $$("#users input.user_check").each(function(i){ i.checked = true; })
}

function unmark_all_users() {
  $$("#users input.user_check").each(function(i){ i.checked = false; })
}

function send_mail_to_checked_users() {
  var s = ""
  $$("#users input.user_check").each(function(i){ 
      if(i.checked) {
        s = s + i.value + ",";
      }
    });
  s = s.substring(0, s.length - 1);
  var url = window.location + "/" + s + "/mail";
  window.location = url;
}
