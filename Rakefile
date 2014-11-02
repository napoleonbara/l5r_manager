
def change_folder_and_extention(path, file, current_ext, ext)
  result = File.join(path, File.basename(file, current_ext)) + ext
end

SASS_SOURCES = Dir['sass/*.sass']
SASS_SOURCE_TO_CSS_TARGET = ->(t){change_folder_and_extention('css', t, '.sass', '.css')}
CSS_TARGET_TO_SASS_SOURCE = ->(t){change_folder_and_extention('sass', t, '.css', '.sass')}
CSS_TARGETS = SASS_SOURCES.map(&SASS_SOURCE_TO_CSS_TARGET)

COFFEE_SOURCES = Dir['coffee/*.coffee']
COFFEE_SOURCE_TO_JS_TARGET = ->(t){change_folder_and_extention('javascripts', t, '.coffee', '.js')}
JS_TARGET_TO_COFFEE_SOURCE = ->(t){change_folder_and_extention('coffee', t, '.js', '.coffee')}
JS_TARGETS = COFFEE_SOURCES.map(&COFFEE_SOURCE_TO_JS_TARGET)

rule '.css' => CSS_TARGET_TO_SASS_SOURCE do |t|
  sh "sass #{t.source} #{t.name}"
end

rule '.js' => JS_TARGET_TO_COFFEE_SOURCE do |t|
  sh "coffee --map --compile --output javascripts\\ #{t.source}"
end

task :css_build => CSS_TARGETS

task :js_build => JS_TARGETS

task :build => [:css_build, :js_build]

task :clean => [:css_clean, :js_clean]

task :css_clean do
  sh 'del /Q css\*'
end

task :js_clean do
  sh 'del /Q javascripts\*'
end