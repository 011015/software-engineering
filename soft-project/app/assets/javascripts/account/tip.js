$(function() {

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