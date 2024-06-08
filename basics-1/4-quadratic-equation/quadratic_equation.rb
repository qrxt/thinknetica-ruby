module QuadraticEquation
  def get_square_roots(a, b, c)
    discriminant = b**2 - 4 * a * c

    if discriminant == 0
      {
        "discriminant" => discriminant,
        "roots" => [-b / 2 * a],
      }
    elsif discriminant > 0
      x1 = (-b + Math.sqrt(discriminant)) / 2 * a
      x2 = (-b - Math.sqrt(discriminant)) / 2 * a

      {
        "discriminant" => discriminant,
        "roots" => [x1, x2],
      }
    else
      {
        "discriminant" => discriminant,
        "roots" => [],
      }
    end
  end

  def solve_quadratic_equation()
    puts "Введи значение коэффициента A:"
    a = gets.chomp.to_f

    puts "Введи значение коэффициента B:"
    b = gets.chomp.to_f

    puts "Введи значение коэффициента C:"
    c = gets.chomp.to_f

    solution = get_square_roots(a, b, c)

    roots_part = if solution["roots"].size == 0
      "корней нет"
    elsif solution["roots"].size == 1
      "корень уравнения: #{solution["roots"].first}"
    else
      "корни уравнения: #{solution["roots"].join(", ")}"
    end

    puts "Дискриминант равен #{solution["discriminant"]}, #{roots_part}"
  end
end
