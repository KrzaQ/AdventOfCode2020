DATA = File.read('data.txt').split("\n\n").map{ |line| line.gsub("\n", " ") }

REQUIRED = %w(ecl pid eyr hcl byr iyr hgt)

PART1 = DATA.map do |passport|
    els = passport.scan(/(...):([\w\d#]+)/)
    els.map(&:first)
    REQUIRED - els.map(&:first)
end.select do |missing|
    missing.size == 0
end.count

def valid_height? h
    case h
    when /(\d+)cm/
        $1.to_i.between?(150, 193)
    when /(\d+)in/
        $1.to_i.between?(59, 76)
    else
        false
    end
end

PART2 = DATA.select do |passport|
    vals = passport.scan(/(...):([\w\d#]+)/).to_h
    vals["byr"].to_i.between?(1920, 2002) and
    vals["iyr"].to_i.between?(2010, 2020) and
    vals["eyr"].to_i.between?(2020, 2030) and
    valid_height? vals["hgt"] and
    vals["hcl"] =~ /^#[a-f0-9]{6}$/ and
    vals["ecl"] =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/ and
    vals["pid"] =~ /^\d{9}$/
end.count

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
