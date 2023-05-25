$(function() {  
    // RoR封装的destroy button需要依赖下面结构，以实现更好的扩展
    $(".form-update").on("submit", function(e) {
      // 点击提交，出现确认框（是否提交？），
      // 若提交成功，出现警告框（提交成功），点击确认跳转到响应页面
      e.preventDefault();  // 阻止默认的链接跳转行为
      let formData = new FormData();
      formData.append("头像", $('input[type=file]')[0].files[0]);
      // 将 serialize 数据逐个添加到 FormData 对象
      let serializedData = $(this).serialize();
      serializedData.split('&').forEach(function(item) {
        let keyValue = item.split('=');
        formData.append(decodeURIComponent(keyValue[0]), decodeURIComponent(keyValue[1]));
      });
      console.log(formData);
      data = {"url": $(this).attr('action'), "type": $(this).attr('method'), "data": formData};
      mizhu.confirm("提示信息", "确认修改吗？", "icon9", data, function(flag, data) {
        if (flag) {
          $.ajax({
            url: data["url"],
            type: data["type"],
            data: data["data"],
            processData: false,
            contentType: false,
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
              mizhu.alert3("提示信息", msg["信息"], "icon10", msg, function(msg) {
                if (msg["路径"]) {
                  window.location.href = msg["路径"];
                }
              });
            }
          });
        }
      });
    });
  });