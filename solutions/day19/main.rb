DATA = File.read('data.txt')

RULES_RAW = DATA.scan(/(\d+): (.*)/).map do |rule, line|
    [rule.to_i, line]
end.to_h

def make_regex special_rules = {}
    rules = {}

    todo = RULES_RAW.to_a
    loop do
        ids = todo.select do |id, rule|
            rule.scan(/\d+/).map(&:to_i) - rules.keys == []
        end.map(&:first)

        ids.each do |id|
            if special_rules.include? id
                rules[id] = special_rules[id][id, rules]
            else
                r = RULES_RAW[id].gsub(/\d+/){ rules[_1.to_i] }.gsub(/[ "]/, '')
                rules[id] = "(?:#{r})"
            end
        end
        todo = todo.reject{ |k, v| ids.include? k }
        break if todo.size == 0
    end
    rx = Regexp.new "^#{rules[0]}$"
end

RX_PART1 = make_regex

PART1 = DATA.scan(/[ab]+/).count do |l|
    RX_PART1.match l
end

def rule11 id, rules
    (1..10).map do |n|
        "(?:#{rules[42]}{#{n}})(?:#{rules[31]}{#{n}})"
    end.join('|').yield_self do |v|
        "(?:#{v})"
    end
end

SPECIAL = {
    11 => -> id, rules { rule11 id, rules },
    8 => -> id, rules { "(?:#{rules[42]}+)" },
}
RX_PART2 = make_regex SPECIAL

PART2 = DATA.scan(/[ab]+/).count do |l|
    RX_PART2.match l
end

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
