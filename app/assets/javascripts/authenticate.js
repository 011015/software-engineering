$(document).ready(function() {
    $('.new-button, .change-button, .homepage, .managementpage').click(function(e) {
        e.preventDefault();
        $.ajax({
            // GET /song_types/new
            url: $(this).attr('href'),
            method: 'get',
            dataType: 'json',
            success: function(data) {
                console.log(data);
                window.location.href = data["路径"];
            },
            error: function(data) {
              console.log(data);
              let msg;
              try {
                msg = JSON.parse(data);
                console.log("是");
              } catch (error) {
                if (data.responseJSON) {
                  msg = data.responseJSON;
                } else {
                  msg = data;
                }
                console.log("不是");
              }
              console.log(msg);
              mizhu.confirm("提示信息", msg["信息"], "icon9", msg, function (flag, msg) {
                  if (flag) {
                      window.location.href = msg["路径"];
                  }
              });
            }
        });
    });
});