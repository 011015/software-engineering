$(function() {
  $("#logout").on('click', function(e) {
    e.preventDefault();  // 阻止默认的链接跳转行为
    $.ajax({
      url: $(this).attr("href"),
      dataType: "script",
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