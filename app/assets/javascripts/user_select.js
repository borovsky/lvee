(function($) {
  var user_select;
  $.user_select = user_select = {
    default_options: {
      add_editors_label: "Add Editors",
      close_dialog_label: "Cancel",
      add_editors: function(sek){},
      user_selection_path: ""
    },
    options: {},
    init: function(new_options) {
      user_select.options = $.extend({}, this.default_options, new_options);
    },

    _submit_selected_users: function() {
      var selected = [];
      $('#user_list .ui-selected').each(function() {
        selected.push($(this).attr("id").split("_")[1]);
      });
      user_select.options.add_editors(selected);
    },
 
    _add_dialog_listeners: function(data) {
      $('#editors').after(data);
      $("#user_dialog").dialog({
        modal: true,
        minWidth: 610,
        buttons: [
          {
            text: user_select.options.close_dialog_label,
            click: function(){$('#user_dialog').dialog("close");}
          },
          {
            text: user_select.options.add_editors_label,
            click: user_select._submit_selected_users
          }
        ]
      });
      $("#find_user").keyup(function(){
        user_select._limit_shown_users($("#find_user").val());
      });
      $("#user_list").selectable({
        filter: "li:visible",
        autoRefresh: false,
        stop: function() {
          var selected = [];
          $('#user_list .ui-selected').each(function() {
            selected.push($(this).children('.user-name').text());
          });
          $('#selected_users').html(selected.join(', '));
        }
      });
    },
    
    _load_dialog: function() {
      $.get(user_select.options.user_selection_path).success(this._add_dialog_listeners);
    },

    show: function() {
      if($("#user_dialog").length == 0) {
        user_select._load_dialog();
      } else {
        $("#user_dialog").dialog("open");
        $("#find_user").val("");
        user_select._limit_shown_users("");
        $("#user_list li.ui-selected").removeClass('ui-selected');
        $("#user_list").selectable("refresh");
      }
    },

   _limit_shown_users: function(queue) {
      var st = queue.toLowerCase().split(" ");
      $("#user_list li").each(function(){
        var o = $(this);
        var name = o.children(".user-name").text().toLowerCase();
        var shown = true;
        for(reg in st) {
          shown = shown && name.indexOf(st[reg]) >= 0
        }
        if(shown) {
          o.show();
        } else {
          o.hide();
        }
      });
      $("#user_list").selectable("refresh");
    }
  }
})( jQuery );
