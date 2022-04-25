int main() {
  auto plus = [](auto x, auto y) { return x + y; };

  std::cout << plus(123, 345) << "\n"s << plus("123"s, "345"s);
}
