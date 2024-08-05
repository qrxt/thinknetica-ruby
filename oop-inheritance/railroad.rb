require_relative "carriage/carriage"
require_relative "train/passenger_train"
require_relative "train/cargo_train"
require_relative "station/station"
require_relative "route/route"

class Railroad
  attr_reader :trains, :stations, :routes

  def initialize()
    @is_running = true
    @page = "main"

    @trains = []
    @stations = []
    @routes = []
  end

  def menu()
    while @is_running do
      break if @page == "stop"

      case @page
        when "main" then main
        when "stop" then stop

        when "seed" then seed

        when "display" then display
        when "display_trains" then display_trains
        when "display_stations" then display_stations
        when "display_routes" then display_routes

        when "create" then create
        when "create_train" then create_train
        when "create_station" then create_station
        when "create_route" then create_route

        when "manage" then manage
        when "manage_add_carriage" then manage_add_carriage
        when "manage_remove_carriage" then manage_remove_carriage
        when "manage_add_intermidiate_station" then manage_add_intermidiate_station
        when "manage_assign_route" then manage_assign_route
        when "manage_move_train" then manage_move_train

        else
          puts "Страница \e[33m#{@page}\e[0m не найдена. Убедитесь в корректности написания."
          @page = gets.chomp
      end
    end
  end

  private

  # методы ниже не предназначены для вызова снаружи, подразумевается,
  # что все нужные действия можно выполнить через rr.menu

  attr_writer :trains, :stations, :routes

  def seed()
    station_a = Station.new("A")
    station_b = Station.new("B")
    station_c = Station.new("C")

    passenger_carriage = PassengerCarriage.new("1")
    cargo_carriage = CargoCarriage.new("1")

    passenger_train = PassengerTrain.new("1")
    cargo_train = CargoTrain.new("2")

    passenger_train.add_carriage(passenger_carriage)
    cargo_train.add_carriage(cargo_carriage)

    route = Route.new("A-C", station_a, station_c)
    route.add_intermidiate_station(station_b)

    passenger_train.assign_route(route)
    cargo_train.assign_route(route)

    @stations = [station_a, station_b, station_c]
    @trains = [passenger_train, cargo_train]
    @routes = [route]

    puts "\nОбъекты созданы. Подробнее в \e[33mdisplay\e[0m.\n\n"
    @page = "main"
  end

  def stop()
    @is_running = false
  end

  def main()
    puts "Введите \e[33mcreate\e[0m, если нужно создать объект"
    puts "Введите \e[33mmanage\e[0m, если нужно произвести операции с объектами"
    puts "Введите \e[33mdisplay\e[0m, если нужно вывести данные об объектах"
    puts "Введите \e[33mseed\e[0m, если нужно сгенерировать объекты"
    puts "Введите \e[33mstop\e[0m, если нужно завершить выполнение программы"

    @page = gets.chomp
  end

  def create_subpages()
    return ["train", "station", "route"]
  end

  def create()
    puts "Введите \e[33mtrain\e[0m, если нужно создать поезд"
    puts "Введите \e[33mstation\e[0m, если нужно создать станцию"
    puts "Введите \e[33mroute\e[0m, если нужно создать маршрут"
    puts "Введите \e[33mmain\e[0m, если нужно вернуться на главную"

    input = gets.chomp
    @page = create_subpages.include?(input) ? "create_#{input}" : "main"
  end

  def create_train()
    puts "Создание поезда"

    puts "Введите тип поезда (\e[33mpassenger\e[0m / \e[33mcargo\e[0m)"

    type = gets.chomp

    return if !["passenger", "cargo"].include?(type)

    puts "Введите номер поезда (строка):"

    number = gets.chomp

    train = type === "passenger" ? PassengerTrain.new(number) : CargoTrain.new(number)

    @trains << train

    puts "\nСоздан поезд: #{train.info}\n\n"

    @page = "create"
  end

  def create_station()
    puts "Создание станции"

    puts "Введите название станции:"

    name = gets.chomp

    station = Station.new(name)

    @stations << station

    puts "\nСоздана станция: #{station.name}\n\n"

    @page = "create"
  end

  def create_route()
    puts "Создание маршрута"

    puts "Сейчас доступны следующие станции: #{ @stations.map {|station| station.name}.join(", ") }"

    puts "Введите название начальной станции:"

    departure_station_name = gets.chomp

    puts "Введите название конечной станции:"

    arrival_station_name = gets.chomp

    departure_station = @stations.find {|station| station.name == departure_station_name}
    arrival_station = @stations.find {|station| station.name == arrival_station_name}

    if !departure_station || !arrival_station
      puts "Начальная или конечная станция не найдена"

      @page = "create"

      return
    end

    route = Route.new("#{departure_station_name}-#{arrival_station_name}", departure_station, arrival_station)

    @routes << route

    puts "\nСоздан маршрут: #{route.name}\n"
    puts "Промежуточные станции можно добавить через \e[33mmanage\e[0m\n\n"

    @page = "create"
  end

  def display_subpages()
    return ["trains", "stations", "routes"]
  end

  def display()
    puts "Введите \e[33mtrains\e[0m, если нужно вывести список поездов"
    puts "Введите \e[33mstations\e[0m, если нужно вывести список станция"
    puts "Введите \e[33mroutes\e[0m, если нужно вывести список маршрутов"
    puts "Введите \e[33mmain\e[0m, если нужно вернуться на главную"

    input = gets.chomp
    @page = display_subpages.include?(input) ? "display_#{input}" : "main"
  end

  def display_trains()
    puts "Список поездов:\n"

    @trains.each do |train|
      train_carriages = train.carriages.map {|carriage| carriage.number}.join(", ")
      train_carriages_string = train.carriages.any? ? "(Вагоны: #{train_carriages})" : ""

      train_route_string = train.current_route ? "(Маршрут: #{train.current_route.info}, текущая станция: #{train.current_station.name})" : ""

      puts "\nПоезд #{train.info} #{train_carriages_string} #{train_route_string}"
    end

    @page = "display"
  end

  def display_stations
    puts "Список станций:\n"

    @stations.each do |station|
      trains_on_station = station.trains.map {|train| train.number}.join(", ")
      trains_on_station_string = station.trains.any? ? "(Поезда на станции: #{trains_on_station})" : ""

      puts "\nСтанция #{station.name} #{trains_on_station_string}\n"
    end

    @page = "display"
  end

  def display_routes
    puts "Список маршрутов:\n"

    @routes.each do |route|
      puts "Маршрут #{route.name} (#{route.info})"
    end

    @page = "display"
  end

  def manage_subpages()
    return [
      "add_carriage",
      "remove_carriage",
      "add_intermidiate_station",
      "assign_route",
      "move_train",
    ]
  end

  def manage()
    puts "Введите \e[33madd_carriage\e[0m, если нужно прицепить вагон к поезду"
    puts "Введите \e[33mremove_carriage\e[0m, если нужно отцепить вагон от поезда"
    puts "Введите \e[33madd_intermidiate_station\e[0m, если нужно добавить маршруту дополнительную станцию"
    puts "Введите \e[33massign_route\e[0m, если нужно назначить поезду маршрут"
    puts "Введите \e[33mmove_train\e[0m, если нужно отправить поезд на следующую или предыдущую станцию"
    puts "Введите \e[33mmain\e[0m, если нужно вернуться на главную"

    input = gets.chomp
    @page = manage_subpages.include?(input) ? "manage_#{input}" : "main"
  end

  def manage_add_carriage()
    puts "Прицепка вагона"

    puts "Сейчас доступны следующие поезда: #{ @trains.map {|train| train.number}.join(", ") }"

    puts "Введите номер поезда для прицепки вагона:"

    train = prompt_for_train()

    return if !train

    puts "Введите номер вагона:"

    carriage_number = gets.chomp

    carriage = train.is_a?(PassengerTrain) ? PassengerCarriage.new(carriage_number) : CargoCarriage.new(carriage_number)

    train.add_carriage(carriage)

    puts "\nВагон #{carriage.number} прицеплен к поезду #{train.number}\n\n"

    @page = "manage"
  end

  def manage_remove_carriage()
    puts "Отцепка вагона"

    puts "Сейчас доступны следующие поезда: #{ @trains.map {|train| train.number}.join(", ") }"

    puts "Введите номер поезда для отцепки вагона:"

    train = prompt_for_train()

    return if !train

    carriages_string = train.carriages.map { |carriage| carriage.number }.join(", ")

    puts "Для поезда #{train.number} доступны вагоны: #{carriages_string}"

    puts "Введите номер вагона"

    carriage_number = gets.chomp

    train.remove_carriage(carriage_number)

    puts "Вагон отцеплен"

    @page = "manage"
  end

  def manage_add_intermidiate_station()
    puts "Добавление промежуточной станции"

    puts "Сейчас доступны следующие маршруты: #{ @routes.map {|route| route.name}.join(", ") }"

    puts "Введите название маршрута для добавление промежуточной станции:"

    route = prompt_for_route()

    return if !route

    fitting_stations = @stations.select {|station| !route.has_station?(station.name)}

    puts "Сейчас доступны следующие станции: #{fitting_stations.map {|station| station.name }.join(", ")}"

    station = prompt_for_station()

    return if !station

    route.add_intermidiate_station(station)

    @page = "manage"
  end

  def manage_assign_route()
    puts "Назначение маршрута"

    fitting_trains = @trains.select {|train| !train.current_route}

    puts "Сейчас доступны следующие поезда: #{fitting_trains.map {|train| train.number}.join(", ")}"

    train = prompt_for_train

    return if !train

    puts "Сейчас доступны следующие маршруты: #{ @routes.map {|route| route.name}.join(", ") }"

    puts "Введите название маршрута:"

    route = prompt_for_route()

    return if !route

    train.assign_route(route)

    puts "Маршрут #{route.name} назначен для поезда #{train.number}"

    @page = "manage"
  end

  def manage_move_train()
    puts "Передвижение поезда"

    puts "Сейчас доступны следующие поезда: #{ @trains.map {|train| train.number}.join(", ") }"

    puts "Введите номер поезда для прицепки вагона:"

    train = prompt_for_train

    return if !train

    puts "Введите \e[33mforward\e[0m или \e[33mbackward\e[0m, чтобы отправить поезд в нужном направлении"

    direction = gets.chomp

    previous_station = train.previous_station

    direction == "backward" ? train.go_previous_station : train.go_next_station

    puts "Поезд передвинулся со станции #{previous_station.name} на станцию #{train.current_station.name}"

    @page = "manage"
  end

  def prompt_for_train()
    train_number = gets.chomp

    train = @trains.find {|train| train.number == train_number}

    if !train
      puts "Поезд с таким номером не найден"

      @page = "manage"

      return nil
    end

    return train
  end

  def prompt_for_route()
    route_name = gets.chomp

    route = @routes.find {|route| route.name == route_name}

    if !route
      puts "Маршрут с таким названием не найден"

      @page = "manage"

      return nil
    end

    return route
  end

  def prompt_for_station()
    station_name = gets.chomp

    station = @stations.find {|station| station.name == station_name}

    if !station
      puts "Станция с таким названием не найдена"

      @page = "manage"

      return nil
    end

    return station
  end

  attr_accessor :page, :is_running
end
