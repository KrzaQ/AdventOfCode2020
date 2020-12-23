#include <cassert>

#include <algorithm>
#include <array>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <list>
#include <numeric>
#include <unordered_map>
#include <utility>

using cont = std::list<int>;

cont read_data()
{
    std::ifstream f("data.txt");
    cont ret(9);
    std::array<char, 9> tmp;
    std::copy(std::istream_iterator<char>(f), {}, tmp.begin());
    std::transform(tmp.begin(), tmp.end(), ret.begin(),
        [](char v){ return v - '0'; });
    return ret;
}

struct data
{
    cont c;
    std::unordered_map<int, cont::iterator> index_lookup;
    void next_round();
};

void data::next_round()
{
    size_t s = c.size();
    cont tc;
    tc.splice(tc.begin(), c, next(c.begin()), next(c.begin(), 4));
    for (int i = 1; i <= 4; i++) {
        int sought = c.front() - i;
        if (sought < 1)
            sought+= s;
        if(find(tc.begin(), tc.end(), sought) != tc.end())
            continue;
        auto it = index_lookup.find(sought);
        assert(it != index_lookup.end());
        c.splice(next(it->second), tc);
        break;
    }
    tc.splice(tc.begin(), c, c.begin(), next(c.begin()));
    c.splice(c.end(), tc, tc.begin());
}

void part1()
{
    data d;
    d.c = read_data();
    auto& c = d.c;
    for(cont::iterator it = c.begin(); it != c.end(); it++)
        d.index_lookup.emplace(*it, it);

    for(int i = 0; i < 100; i++) {
        d.next_round();
    }
    auto it = find(c.begin(), c.end(), 1);
    c.splice(c.end(), c, c.begin(), it);
    it = next(c.begin());
    std::cout << "Part 1: ";
    std::copy(it, c.end(), std::ostream_iterator<int>(std::cout));
    std::cout << '\n';
}

void part2()
{
    data d;
    d.c = read_data();
    auto& c = d.c;
    c.resize(1'000'000);
    iota(next(c.begin(), 9), c.end(), 10);
    for(cont::iterator it = c.begin(); it != c.end(); it++)
        d.index_lookup.emplace(*it, it);

    for(int i = 0; i < 10'000'000; i++) {
        d.next_round();
    }
    auto it = find(c.begin(), c.end(), 1);
    it = next(it);
    int64_t a, b;
    a = *it;
    it = next(it);
    b = *it;
    std::cout << "Part 2: " << a*b << '\n';
}

auto main() -> int
{
    part1();
    part2();
}
