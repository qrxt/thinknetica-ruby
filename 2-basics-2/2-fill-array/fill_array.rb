module FillArray
  def fill_array(from, to, step)
    return [] if step == 0

    result = []
    counter = from

    while counter <= to do
      result << counter
      counter += step
    end

    result
  end
end
