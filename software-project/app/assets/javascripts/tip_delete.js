$(function() {  
    // RoR封装的destroy button需要依赖下面结构，以实现更好的扩展
    $(".delete>form").on("submit", function(e) {
      e.preventDefault();  // 阻止默认的链接跳转行为
      data = {"url": $(this).attr('action'), "type": $(this).attr('method'), "data": $(this).serialize()};
      console.log(data);
      mizhu.confirm("提示信息", "确认删除吗？", data, function(flag, data) {
        if (flag) {
          $.ajax({
            url: data["url"],
            type: data["type"],
            data: data["data"],
            success: function(msg, status) {
              // console.log(data);
              // let msg = JSON.parse(data);
              console.log(msg);
              mizhu.alert("提示信息", msg["信息"], "icon10", function (flag) {
                  if (flag) {
                      $("#"+msg["id"]).remove();
                      window.location.href = msg["路径"];
                  }
              });
            },
            error: function(data) {
              console.log(data);
              mizhu.alert("提示信息", msg["信息"], "icon10");
            }
          });
        }
      });
    });
  });