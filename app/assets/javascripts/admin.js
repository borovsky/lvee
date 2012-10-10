//= require application
//= require active_scaffold
//= require_self

$(function() {
  "use strict"

  function send_mail_to_checked_users(e) {
    var url =  '/:lang/admin/users/mail',
    href = url.replace(':lang', window.location.pathname.substr(1, 2)),
    csrf_token = $('meta[name=csrf-token]').attr('content'),
    csrf_param = $('meta[name=csrf-param]').attr('content'),
    form = $('<form method="post" action="' + href + '"></form>'),
    metadata_input = '<input name="_method" value="PUT" type="hidden" />';

    e.preventDefault();

    var ids = $("#users .user_check:checked").map(function() {
      var id = this.id;
      return id.replace("to_", "");
    }).get().join(",");

    var to_list = '<input name="to_list" value="'+ids+'" type="hidden" />';

    if (csrf_param !== undefined && csrf_token !== undefined) {
      metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
    }
    form.hide().append(metadata_input).append(to_list).appendTo('body');
    form.submit();
  }

  $('select.change_role_select').change(function(){
    var path = $(this).attr('id');
    var id = path.substr("role_".length);
    var url = "/en/admin/users/UserID/set_role".replace("UserID", id);
    var data = "role=" + $(this).val();
    $.ajax(url, {data: data, type: "POST"});
  });

  $('#check_all').click(function(){
    $(".user_check").attr("checked", $('#check_all').is(':checked'));
  });

  $("#send_mail_to_checked").click(send_mail_to_checked_users);
});
