# 曲谱交流平台

想要了解本平台，可以阅读`docs`文件夹中的概要设计报告、需求规格书及用户使用手册。

# 运行

1. `rake db:create`创建数据库。
2. `rake db:migrate`执行所有未执行的迁移，更新数据库结构。
3. 本平台使用了`Action Cable`方法实现双方实时通信。如果想要复现双方实时通信功能，需要在不同浏览器运行服务器实例如`rails s`，同时还需要启动`redis`服务器。