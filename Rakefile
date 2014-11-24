
def change_folder_and_extention(path, file, current_ext, ext)
  result = File.join(path, File.basename(file, current_ext)) + ext
end


COFFEE_SOURCES = Dir['coffee/*.coffee']
COFFEE_SOURCE_TO_JS_TARGET = ->(t){change_folder_and_extention('javascripts', t, '.coffee', '.js')}
JS_TARGET_TO_COFFEE_SOURCE = ->(t){change_folder_and_extention('coffee', t, '.js', '.coffee')}
JS_TARGETS = COFFEE_SOURCES.map(&COFFEE_SOURCE_TO_JS_TARGET)


task :css_build => [
  'css/character_sheet.css',
  'css/dice_roller.css'
]

task :js_build => [
  'javascripts/character_sheet.js',
  'javascripts/dice_roller_parser.js']

task :test_build => [
  :js_build,
  'tests/spec/spec_helper.js',
  'tests/spec/dice_roller_parser_spec.js',
  'tests/spec/formulas_spec.js',
  'tests/spec/helpers_spec.js' ]

task :build => [:css_build, :js_build, :test_build]

task :clean => [:css_clean, :js_clean, :test_clean]

task :rebuild => [:clean, :build]

task :css_clean do
  sh 'del /Q css\\*'
end

task :js_clean do
  sh 'del /Q javascripts\\*'
end

task :test_clean do
  sh 'del /Q tests\\spec\\*.js tests\\spec\\*.map'
end

task :test => :build do
  sh "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe  file://tests/spec_runner.html"
end

                                  ##### TESTS #####

file 'tests/spec/dice_roller_parser_spec.js' => 'tests/spec/dice_roller_parser_spec.coffee' do |t|
  
  sh "coffee --compile --output tests\\spec\\ #{t.source}"
end

file 'tests/spec/spec_helper.js' => 'tests/spec/spec_helper.coffee' do |t|
  
  sh "coffee --compile --output tests\\spec\\ #{t.source}"
end

file 'tests/spec/formulas_spec.js' => 'tests/spec/formulas_spec.coffee' do |t|
  
  sh "coffee --compile --output tests\\spec\\ #{t.source}"
end

file 'tests/spec/helpers_spec.js' => 'tests/spec/helpers_spec.coffee' do |t|
  
  sh "coffee --compile --output tests\\spec\\ #{t.source}"
end


                                  ##### JAVASCRIPTS #####

file 'javascripts/character_sheet.js' => [
  'coffee/skills_data.coffee',
  'coffee/helpers.coffee',
  'coffee/dices.coffee',
  'coffee/character_sheet_mapping.coffee',
  'coffee/character_sheet.coffee',
  'coffee/formulas.coffee'] do |t|
  sh "coffee --map --compile --output javascripts\\ --join character_sheet.js #{t.sources.join(' ')}"
end

file 'javascripts/dice_roller_parser.js' => 'pegjs/dice_roller_parser.pegjs' do |t|
  
  sh "pegjs -e dice_roller_parser pegjs\\dice_roller_parser.pegjs javascripts/dice_roller_parser.js"
end


                                  ##### CSS #####

file 'css/character_sheet.css' => ['sass/character_sheet.sass', 'sass/dice_roller.sass'] do
  sh "sass sass\\character_sheet.sass css\\character_sheet.css"
end

file 'css/dice_roller.css' => 'sass/dice_roller.sass' do
  sh "sass sass\\dice_roller.sass css\\dice_roller.css"
end