module Fib
  def fib(to)
    numbers = [0, 1, 1]

    while numbers[-1] + numbers[-2] < to do
      numbers << numbers[-1] + numbers[-2]
    end

    numbers
  end
end
