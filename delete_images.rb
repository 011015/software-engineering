require 'fileutils'

# 获取存储图片的文件夹路径
images_folder = Rails.root.join('app', 'assets', 'images', 'uploads', 'account')
# 获取文件夹中的所有文件并逐个删除
Dir.glob(File.join(images_folder, '*')).each do |file|
  FileUtils.rm(file)
end

images_folder = Rails.root.join('app', 'assets', 'images', 'uploads', 'image')
Dir.glob(File.join(images_folder, '*')).each do |file|
  FileUtils.rm(file)
end

images_folder = Rails.root.join('app', 'assets', 'images', 'uploads', 'song')
Dir.glob(File.join(images_folder, '*')).each do |file|
  FileUtils.rm(file)
end

images_folder = Rails.root.join('app', 'assets', 'images', 'uploads', 'audio')
Dir.glob(File.join(images_folder, '*')).each do |file|
  FileUtils.rm(file)
end