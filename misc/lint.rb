# encoding: UTF-8
def explore (top)
    files = Dir.entries(top)
    vala_files = []
    files.each do |file|
        if file == '.' or file == '..' or file == '.git'
            next
        end
        if file.end_with?('.vala')
            vala_files << file
        elsif File.directory?(top + '/' + file)
            in_subdir = explore(top + '/' + file)
            in_subdir.each do |sub_file|
                vala_files << file + '/' + sub_file
            end
        end
    end
    return vala_files
end
def check (file)
    content = ''
    errors = 0
    warnings = 0
    lines = 0
    open(file,'r:UTF-8') do |f|
        line_num = 0
        in_comm = false
        while line = f.gets
            if line.index(/\*\//) != nil
                in_comm = false
                line = line.gsub(/.*\*\//, '')
            end
            if in_comm
                line_num += 1
                next
            end
            if line.index(/\/\*/) != nil
                in_comm = true
                line = line.gsub(/.*\/\*/, '')
            end
            # removing comments
            line = line.gsub(/\/\/.*/, '')
            content += line
            line_num += 1
            # don't use as
            if line.include?(' as ')
                puts file + ':' + line_num.to_s + ': Avoid using the "as" keyword, it might create unwanted behaviors.'
                errors += 1
            end
            # capitals const
            const_re = /const [[:graph:]]* (?<name>[[:graph:]]*)/
            res = const_re.match(line)
            if not res == nil
                name = res[1]
                maj_name = name.upcase
                if name != maj_name
                    puts file + ':' + line_num.to_s + ': Constants must be uppercased. ' + name + ' -> ' + maj_name
                    errors += 1
                end
            end
            # never forget the space before a ( or a {
            space_re = /(?!\()[[:graph:]]*\(.*\)/
            space_res = space_re.match(line.gsub(/".*?"/, ''))
            if not space_res == nil
                puts file + ':' + line_num.to_s + ': Space missing before a parenthesis.'
                errors += 1
            end
            curly_re = /(?!\{)[[:graph:]]*\{.*\}/
            curly_res = curly_re.match(line.gsub(/".*?"/, ''))
            if not curly_res == nil
                puts file + ':' + line_num.to_s + ': Space missing before a curly brace.'
                errors += 1
            end
            # Put whitespace in math
            math_re = /(.)(=|\+|-|\*|\/|(\d)+)(.)/
            allowed_re = /(\(|\[|\s|=|>|<|!|\+|-|\/|\*)/
            math_res = math_re.match(line.gsub(/".*?"/, ''))
            if (not math_res == nil) and not (math_res[1].match(allowed_re) or math_res[2].match(allowed_re))
                puts file + ':' + line_num.to_s + ': Math symbols are not well spaced.'
                errors += 1
            end
            if line.strip == '{'
                puts file + ':' + line_num.to_s + ': Curly braces shouldn\'t be on their own line.'
                errors += 1
            end
            if line.strip == 'using GLib;' or line.include? 'GLib.print'
                puts file + ':' + line_num.to_s + ': Useless reference to GLib.'
                warnings += 1
            end
            if line.include? 'stdout.printf'
                puts file + ':' + line_num.to_s + ': Use `print ()` instead of `stdout.printf ()`.'
                warnings += 1
            end
        end

        lines = line_num
    end
    content = content.gsub(/\/\*.*\*\//su, '')
    # one class, struct or iterface by file
    if content.scan(' class ').length + content.scan(' interface ').length + content.scan(' struct').length > 1
        puts file + ': Too many classes, structs or interfaces defined here.'
        errors += 1
    end
    if errors > 0
        return true, errors, warnings, lines
    else
        return false, errors, warnings, lines
    end
end
def main
    to_check = explore ('.')
    bad_files = 0
    errors = 0
    warnings = 0
    lines = 0
    to_check.each do |vala|
        file = check(vala)
        if file[0]
            bad_files += 1
            errors += file[1]
            warnings += file[2]
            lines += file[3]
        end
    end
    puts ''
    puts 'Bad files: ' + bad_files.to_s + ' - Total files: ' + to_check.length.to_s
    puts 'Bad lines: ' + (errors + warnings).to_s + ' - Total lines: ' + lines.to_s
    puts 'Errors: ' + errors.to_s + ' - Warnings: ' + warnings.to_s
    coverage = 100 - (100 * errors.to_f / lines.to_f)
    puts ''
    puts 'Coverage : ' + coverage.to_s[0..4]
end
main
