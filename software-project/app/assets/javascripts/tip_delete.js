$(function() {  
    // RoR封装的destroy button需要依赖下面结构，以实现更好的扩展
    $(".delete>form").on("submit", function(e) {
      e.preventDefault();  // 阻止默认的链接跳转行为
      $.ajax({
        url: $(this).attr('action'),
        type: $(this).attr('method'),
        data: $(this).serialize(),
        dataType: 'script',
        success: function(data, status) {
          let msg = JSON.parse(data);
          mizhu.alert("提示信息", msg["信息"], "icon10", function (flag) {
              if (flag) {
                  $("#"+msg["id"]).remove();
              }
            });
        }
      });
    });
  });