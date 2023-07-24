$(function() {  
    // RoR封装的destroy button需要依赖下面结构，以实现更好的扩展
    $(".form-delete").on("submit", function(e) {
      e.preventDefault();  // 阻止默认的链接跳转行为
      data = {"url": $(this).attr('action'), "type": $(this).attr('method'), "data": $(this).serialize()};
      console.log(data);
      mizhu.confirm("提示信息", "确认删除吗？", "icon9", data, function(flag, data) {
        if (flag) {
          $.ajax({
            url: data["url"],
            type: data["type"],
            data: data["data"],
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
                if (msg["ID"]) {
                  console.log("id");
                  $("#"+msg["ID"]).remove();
                } else if (msg["路径"]) {
                  console.log("noid");
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
        }
      });
    });
  });