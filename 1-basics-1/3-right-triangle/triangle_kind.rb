TRIANGLE_KIND = {
  :equilateral => "равносторонний",
  :right => "прямоугольный",
  :isosceles => "равнобедренный",
  :scalene => "разносторонний",
}

module TriangleKind
  def right_triangle?(sides)
    cathetus_list = sides.min(2)
    hypotenuse = sides.max

    cathetus_list_square = cathetus_list.map { |n| n ** 2 }

    cathetus_list_square.sum == hypotenuse ** 2
  end

  def equilateral_triangle?(sides)
    sides.uniq.size == 1
  end

  def isosceles_triangle?(sides)
    sides.uniq.size == sides.size - 1
  end

  def determine_triangle_kind(sides)
    if equilateral_triangle?(sides)
      :equilateral
    elsif right_triangle?(sides)
      :right
    elsif isosceles_triangle?(sides)
      :isosceles
    else
      :scalene
    end
  end

  def triangle?(sides)
    side_a, side_b, side_c = sides

    [
      side_a > 0,
      side_b > 0,
      side_c > 0,
      side_a + side_b > side_c,
      side_b + side_c > side_a,
      side_a + side_c > side_b
    ].all? { |v| v }
  end

  def get_triangle_kind()
    puts "Введи сторону A треугольника:"
    side_a = gets.chomp.to_f

    puts "Введи сторону B треугольника:"
    side_b = gets.chomp.to_f

    puts "Введи сторону C треугольника:"
    side_c = gets.chomp.to_f

    triangle = [side_a, side_b, side_c]

    if !triangle?(triangle)
      puts "Треугольник не существует"
      return
    end

    puts "Треугольник существует, треугольник #{TRIANGLE_KIND[determine_triangle_kind(triangle)]}"
  end
end
