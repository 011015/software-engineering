$(function() {
    // 默认form提交的提示信息，点击按钮，出现警告框（提示信息）
    $('.form-upload').on('submit', function(e) {
        e.preventDefault();
        let fileData = new FormData($(this)[0]);
        console.log(fileData);
        $.ajax({
          url: $(this).attr('action'),
          type: $(this).attr('method'),
          processData: false,
          contentType: false,
          data: fileData,
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