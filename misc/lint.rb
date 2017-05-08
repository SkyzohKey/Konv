# encoding: UTF-8
def explore top
  vala_files = []

  Dir.entries(top).each do |file|
    next if file == '.' || file == '..' || file == '.git'

    if file.end_with? '.vala'
      vala_files << file
    else
      if File.directory? "#{top}/#{file}"
        explore("#{top}/#{file}").each {|sub_file| vala_files << "#{file}/#{sub_file}"}
      end
    end
  end

  vala_files
end

def check file
  content = ''
  errors, warnings, lines = 0, 0, 0

  open(file, 'r:UTF-8') do |f|
    line_num = 0
    in_comm = false

    while (line = f.gets)
      unless line.index(/\*\//).nil?
        in_comm = false
        line = line.gsub /.*\*\//, ''
      end

      if in_comm
        line_num += 1
        next
      end

      unless line.index(/\/\*/).nil?
        in_comm = true
        line = line.gsub /.*\/\*/, ''
      end

      # removing comments
      line = line.gsub /\/\/.*/, ''
      content += line
      line_num += 1

      # don't use as
      if line.include? ' as '
        puts "#{file}:#{line_num}: Avoid using the \"as\" keyword, it might create unwanted behaviors."
        errors += 1
      end

      # capitals const
      const_re = /const [[:graph:]]* (?<name>[[:graph:]]*)/
      res = const_re.match line

      unless res.nil?
        name = res[1]
        if name != name.upcase
          puts "#{file}:#{line_num}: Constants must be uppercased. #{name} -> #{name.upcase}"
          errors += 1
        end
      end

      # never forget the space before a ( or a {
      space_re = /(?!\()[[:graph:]]*\(.*\)/
      space_res = space_re.match(line.gsub(/".*?"/, ''))

      unless space_res.nil?
        puts "#{file}:#{line_num}: Space missing before a parenthesis."
        errors += 1
      end

      curly_re = /(?!\{)[[:graph:]]*\{.*\}/
      curly_res = curly_re.match(line.gsub(/".*?"/, ''))

      unless curly_res.nil?
        puts "#{file}:#{line_num}: Space missing before a curly brace."
        errors += 1
      end

      # Put whitespace in math
      math_re = /(.)(=|\+|-|\*|\/|(\d)+)(.)/
      allowed_re = /(\(|\[|\s|=|>|<|!|\+|-|\/|\*)/
      math_res = math_re.match(line.gsub(/".*?"/, ''))

      if !(math_res.nil?) && !(math_res[1].match(allowed_re) || math_res[2].match(allowed_re))
        puts "#{file}:#{line_num}: Math symbols are not well spaced."
        errors += 1
      end

      if line.strip == '{'
        puts "#{file}:#{line_num}: Curly braces shouldn't be on their own line."
        errors += 1
      end

      if line.strip == 'using GLib;' || line.include?('GLib.print')
        puts "#{file}:#{line_num}: Useless reference to GLib."
        warnings += 1
      end

      if line.include? 'stdout.printf'
        puts "#{file}:#{line_num}: Use `print ()` instead of `stdout.printf ()`."
        warnings += 1
      end
    end

    lines = line_num
  end

  content = content.gsub /\/\*.*\*\//su, ''

  # one class, struct or iterface by file
  if content.scan(' class ').length + content.scan(' interface ').length + content.scan(' struct').length > 1
    puts "#{file}: Too many classes, structs or interfaces defined here."
    errors += 1
  end

  if (errors > 0) then return true, errors, warnings, lines else return false, errors, warnings, lines end
end

to_check = explore '.'
bad_files, errors, warnings, lines = 0, 0, 0, 0

to_check.each do |vala|
  file = check vala
  if file[0]
    bad_files += 1
    errors += file[1]
    warnings += file[2]
    lines += file[3]
  end
end

puts "\nBad files: #{bad_files} - Total files: #{to_check.length}"
puts "Bad lines: #{errors + warnings} - Total lines: #{lines}"
puts "Errors: #{errors} - Warnings: #{warnings}"
puts "\nCoverage: #{(100 - (100 * errors.to_f / lines.to_f)).to_s[0..4]}"