module ShoppingList
  def get_price_sums(goods)
    goods.transform_values { |v| v[:price] * v[:quantity] }
  end

  def make_shopping_list()
    is_running = true
    counter = 1
    goods = {}

    while is_running do
      message_postfix = counter > 1 ? "или \"стоп\" чтобы закончить" : ""

      puts "Введи название товара #{counter} #{message_postfix}"
      name = gets.chomp

      if goods.key?(name)
        puts "Такой товар уже был добавлен ранее. Его значения будут перезаписаны"
        counter -= 1
      end

      break if name.downcase == "стоп" && counter > 1

      puts "Введи стоимость товара #{name}"
      price = gets.chomp.to_f

      puts "Введи количество товара #{name}"
      quantity = gets.chomp.to_i

      product = {
        :price => price,
        :quantity => quantity,
      }

      goods[name] = product

      puts "Товар #{name} со стоимостью #{price} в количестве #{quantity} добавлен в список"
      counter += 1
    end

    puts "Список товаров:"
    puts "#{goods}"
    puts "\n"

    sums = get_price_sums(goods)

    puts "Сумма по каждой позиции:"
    sums.each do |name, sum|
      puts "#{name}: #{sum}"
    end
    puts "\n"

    puts "Итоговая сумма покупок: #{sums.values.sum}"
  end
end
