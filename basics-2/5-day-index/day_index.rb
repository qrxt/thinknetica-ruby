MONTHS = [:january, :february, :march, :april, :may, :june, :july, :august, :september, :october, :november, :december]
DAYS_IN_MONTH = {
  :january => 31,
  :february => 28,
  :march => 31,
  :april => 30,
  :may => 31,
  :june => 30,
  :july => 31,
  :august => 31,
  :september => 30,
  :october => 31,
  :november => 30,
  :december => 31,
}

module DayIndex
  def leap_year?(year)
    return false if year % 4 != 0

    year % 100 == 0 ? year % 400 == 0 : true
  end

  def days_in_month(month, year = nil)
    return DAYS_IN_MONTH[month] if !year || month != :february

    leap_year?(year) ? DAYS_IN_MONTH[month] + 1 : DAYS_IN_MONTH[month]
  end

  def day_index(day, month, year)
    months = month <= 1 ? [] : MONTHS[0..month - 2]
    days_from_months = months.map { |month| days_in_month(month, year) }.sum

    days_from_months + day
  end

  def get_day_index()
    puts "Введи число"
    day = gets.chomp.to_i

    puts "Введи месяц (номер)"
    month = gets.chomp.to_i

    puts "Введи год"
    year = gets.chomp.to_i

    puts "Это #{day_index(day, month, year)}-й день в году"
  end
end
