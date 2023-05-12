$(function() {
    // 默认form提交的提示信息，点击按钮，出现警告框（提示信息）
    $('#file-upload').on('submit', function(e) {
        e.preventDefault();
        let fileData = new FormData($(this)[0]);
        console.log(fileData);
        $.ajax({
          url: $(this).attr('action'),
          type: $(this).attr('method'),
          processData: false,
          contentType: false,
          data: fileData,
          success: function(msg, status) {
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
            mizhu.alert("提示信息", msg["信息"], "icon10", function (flag) {
              if (flag) {
                  window.location.href = msg["路径"];
              }
            });
          }
        });
    });
  });