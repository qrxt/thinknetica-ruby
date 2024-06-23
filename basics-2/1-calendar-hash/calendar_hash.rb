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

module CalendarHash
  def print_months_with_30_days()
    for month, days in DAYS_IN_MONTH do
      puts month if days == 30
    end
  end
end
