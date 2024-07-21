class Station
  attr_reader :name
  attr_accessor(:trains)

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def get_train_types()
    @trains.group_by {|train| train.type}
  end

  def send(train_number)
    current_train = @trains.find {|train| train.number == train_number}

    current_train.move_forward
  end
end
