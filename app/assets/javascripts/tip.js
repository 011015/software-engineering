$(function () {
  $('.form-default').on('submit', function (e) {
    // success: 出现警告框（提示信息），点击确认跳转到响应页面
    // error: 验证身份失败，出现确认框，若点击确认跳转到登录页面
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
      success: operate1,
      error: operate2,
    });
  });

  $(".form-delete").on("submit", function (e) {
    e.preventDefault();  // 阻止默认的链接跳转行为
    data = { "url": $(this).attr('action'), "type": $(this).attr('method'), "data": $(this).serialize() };
    mizhu.confirm("提示信息", "确定吗？", "icon9", data, function (flag, data) {
      if (flag) {
        $.ajax({
          url: data["url"],
          type: data["type"],
          data: data["data"],
          success: operate3,
          error: operate2,
        });
      }
    });
  });

  $(".form-update").on("submit", function (e) {
    // 点击提交，出现确认框（是否提交？），
    // 若提交成功，出现警告框（提交成功），点击确认跳转到响应页面
    e.preventDefault();  // 阻止默认的链接跳转行为
    let formData = new FormData();
    formData.append($('input[type=file]')[0].name, $('input[type=file]')[0].files[0]);
    // 将 serialize 数据逐个添加到 FormData 对象
    let serializedData = $(this).serialize();
    serializedData.split('&').forEach(function (item) {
      let keyValue = item.split('=');
      formData.append(decodeURIComponent(keyValue[0]), decodeURIComponent(keyValue[1]));
    });
    console.log(formData);
    data = { "url": $(this).attr('action'), "type": $(this).attr('method'), "data": formData };
    mizhu.confirm("提示信息", "确认修改吗？", "icon9", data, function (flag, data) {
      if (flag) {
        $.ajax({
          url: data["url"],
          type: data["type"],
          data: data["data"],
          processData: false,
          contentType: false,
          success: operate1,
          error: operate1,
        });
      }
    });
  });

  $(".form-submit").on("submit", function (e) {
    e.preventDefault();  // 阻止默认的链接跳转行为
    let formData = new FormData();
    formData.append($('input[type=file]')[0].name, $('input[type=file]')[0].files[0]);
    // 将 serialize 数据逐个添加到 FormData 对象
    let serializedData = $(this).serialize();
    serializedData.split('&').forEach(function (item) {
      let keyValue = item.split('=');
      formData.append(decodeURIComponent(keyValue[0]), decodeURIComponent(keyValue[1]));
    });
    console.log(formData);
    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: formData,
      processData: false,
      contentType: false,
      success: operate1,
      error: operate1,
    });
  });

  $("#logout").on('click', function (e) {
    e.preventDefault();  // 阻止默认的链接跳转行为
    $.ajax({
      url: $(this).attr("href"),
      success: operate1,
      error: operate1,
    });
  });

  $('.form-upload').on('submit', function (e) {
    e.preventDefault();
    let fileData = new FormData($(this)[0]);
    console.log(fileData);
    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      processData: false,
      contentType: false,
      data: fileData,
      success: operate1,
      error: operate2,
    });
  });

  $('.form-change').on('submit', function (e) {
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
      success: operate4,
    });
  })
});

function operate1(data) {
  let msg;
  try {
    msg = JSON.parse(data);
  } catch (error) {
    if (data.responseJSON) {
      msg = data.responseJSON;
    } else {
      msg = data;
    }
  }
  mizhu.alert3("提示信息", msg["信息"], "icon10", msg, function (msg) {
    if (msg["路径"]) {
      window.location.href = msg["路径"];
    }
  });
}

function operate2(data) {
  let msg;
  try {
    msg = JSON.parse(data);
  } catch (error) {
    if (data.responseJSON) {
      msg = data.responseJSON;
    } else {
      msg = data;
    }
  }
  mizhu.confirm("提示信息", msg["信息"], "icon9", msg, function (flag, msg) {
    if (flag && msg["路径"]) {
      window.location.href = msg["路径"];
    }
  });
}

function operate3(data) {
  let msg;
  try {
    msg = JSON.parse(data);
  } catch (error) {
    if (data.responseJSON) {
      msg = data.responseJSON;
    } else {
      msg = data;
    }
  }
  mizhu.alert3("提示信息", msg["信息"], "icon10", msg, function (msg) {
    if (msg["ID"]) {
      $("#" + msg["ID"]).remove();
    } else if (msg["路径"]) {
      window.location.href = msg["路径"];
    }
  });
}

function operate4(data) {
  let msg;
  try {
    msg = JSON.parse(data);
  } catch (error) {
    if (data.responseJSON) {
      msg = data.responseJSON;
    } else {
      msg = data;
    }
  }
  console.log(msg);
  if (msg["ID"]) {
    console.log("true");
    console.log(msg["ID"]);
    $("#" + msg["ID"]).remove();
  } else if (msg["路径"]) {
    window.location.href = msg["路径"];
  }
}