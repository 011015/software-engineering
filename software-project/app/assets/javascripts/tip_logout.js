$(function() {
  $("#logout").on('click', function(e) {
    e.preventDefault();  // 阻止默认的链接跳转行为
    $.ajax({
      url: $(this).attr("href"),
      success: function(data) {
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
        console.log(msg["信息"]);
        console.log(msg["路径"]);
        mizhu.alert3("提示信息", msg["信息"], "icon10", msg, function(msg) {
          if (msg["路径"]) {
            window.location.href = msg["路径"];
          }
        });
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
        mizhu.alert3("提示信息", msg["信息"], "icon10", msg, function(msg) {
          if (msg["路径"]) {
            window.location.href = msg["路径"];
          }
        });
      }
    });
  });
});