$(function() {
    // 默认form提交的提示信息，点击提交，出现确认框（是否提交？），
    // 若提交成功，出现警告框（提交成功），点击确认跳转到响应页面
    $('form').on('submit', function(e) {
        e.preventDefault();
        $.ajax({
          url: $(this).attr('action'),
          type: $(this).attr('method'),
          data: $(this).serialize(),
          dataType: 'script',
          success: function(data, status) {
            let msg = JSON.parse(data);
            console.log(msg["信息"]);
            mizhu.alert("提示信息", msg["信息"], "icon10", function (flag) {
                if (flag) {
                    window.location.href = msg["路径"];
                }
              });
          },
          error: function(data, xhr, status, error) {
            let msg = JSON.parse(data.responseText);
            console.log(msg["信息"]);
            mizhu.alert("提示信息", msg["信息"], "icon10");
          }
        });
    });
  });