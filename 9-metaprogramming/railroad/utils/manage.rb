# frozen_string_literal: true

module ManageUtils
  def check_no_trains(trains = @trains)
    return unless trains.empty?

    puts NO_TRAINS_AVAILABLE_ERROR

    @page = 'manage'
  end

  def create_carriage(train)
    carriage_number = prompt_for_carriage_number(train.carriages)

    carriage = if train.is_a?(PassengerTrain)
                 PassengerCarriage.new(carriage_number, prompt_for_seats)
               else
                 CargoCarriage.new(carriage_number, prompt_for_volume)
               end

    carriage.manufacturer = prompt_for_manufacturer

    carriage
  end

  def remove_carriage(train, carriage_number)
    train.remove_carriage(carriage_number)

    puts 'Вагон отцеплен'
  end

  def assign_route(train, route)
    train.assign_route(route)

    puts "Маршрут #{route.name} назначен для поезда #{train.number}"
  end

  def occupy_carriage_volume(carriage, volume)
    carriage.fill(volume)

    puts "Текущий объем: #{carriage.occupied_volume} / #{carriage.volume}"
  end

  def occupy_carriage_seat(carriage)
    carriage.occupy_seat

    puts "Теперь в вагоне занято #{carriage.occupied_seats} из #{carriage.seats_number} мест"
  end
end
