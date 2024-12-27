// const socket = new WebSocket('ws://localhost:4000/cable');
// socket.onopen = function(event) {
//   console.log('WebSocket连接已打开');
// };
// socket.onclose = function(event) {
//   console.log('WebSocket连接已关闭');
// };
//= require actioncable
//= require_self
//= require_tree ../../channels
// (function() {
//     this.App || (this.App = {});
  
//     App.cable = ActionCable.createConsumer();
  
//   }).call(this);
$(function() {
    // 页面加载完成后自动连接 WebSocket
    $.ajax({
        url: '/get_session_id', // 服务器端处理获取 session ID 的路由
        method: 'GET',
        success: function(data) {
            let sessionId = data.session_id; // 从响应中获取 session ID
            console.log(sessionId);

            // 创建 WebSocket 连接
            const cable = ActionCable.createConsumer();
            // 订阅频道
            const channel = cable.subscriptions.create({ channel: 'NoticeChannel', receiver_id: sessionId }, {
            connected() {
                console.log("test connected");
            },
            disconnected() {
                console.log("test disconnected");
            },
            send(msg) {
                console.log("test send");
                this.perform('send_message', { msg: msg });
            },
            received(data) {
                // 处理接收到的消息
                console.log("test received");
                console.log(data);
                mizhu.alert1("提示信息", data.msg, "icon10");
            },
            initialized() {
                console.log("test initialized");
            },
            rejected() {
                console.log("test rejected");
            },
            subscribed() {
                console.log("test subscribed");
            },
            unsubscribed() {
                console.log("test unsubscribed");
            }
            });
            // document.addEventListener('DOMContentLoaded', connectWebSocket(sessionId));
          },
          error: function(data) {
            console.log(data);
          }
        });
});