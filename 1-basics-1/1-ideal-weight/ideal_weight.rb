module IdealWeight
  def calc_ideal_weight(height)
    weight = (height - 110) * 1.15

    weight.round(2)
  end

  def get_ideal_weight()
    puts "Как тебя зовут?"
    name = gets.chomp

    puts "Введи свой рост:"
    height = gets.chomp.to_i

    ideal_weight = calc_ideal_weight height

    output = if ideal_weight > 0
      "#{name}, твой идеальный вес - #{ideal_weight}кг"
    else
      "#{name}, твой вес уже оптимальный"
    end

    puts output
  end
end
