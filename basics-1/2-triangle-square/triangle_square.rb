module TriangleSquare
  def calc_triangle_square(base, height)
    base * height * 0.5
  end

  def get_triangle_square()
    puts "Введи длину основания треугольника:"
    base = gets.chomp.to_f

    puts "Введи высоту треугольника:"
    height = gets.chomp.to_f

    square = calc_triangle_square(base, height).round(2)

    puts "Площадь треугольника: #{square}"
  end
end
