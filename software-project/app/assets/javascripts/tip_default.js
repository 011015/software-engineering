$(function() {
  $('.form-default').on('submit', function(e) {
    // success: 出现警告框（提示信息），点击确认跳转到响应页面
    // error: 验证身份失败，出现确认框，若点击确认跳转到登录页面
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
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
        mizhu.confirm("提示信息", msg["信息"], "icon9", msg, function (flag, msg) {
            if (flag && msg["路径"]) {
                window.location.href = msg["路径"];
            }
        });
    }
    });
  });
});