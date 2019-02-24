module ApplicationHelper
  def working_hour(attendance)
    sec=attendance.out_time-attendance.in_time
    return sec
  end

  def sum_break_hour(attendance)
    sum=0
    attendance.break.each do |rest|
      if rest.out_time.present? then
        break_hour=rest.out_time-rest.in_time
        sum+=break_hour
      end
    end
    return sum
  end

  def sum_working_hour(attendances)
    sum=0
    attendances.each do |attendance|
      if attendance.out_time.present? then
        working_hour=attendance.out_time-attendance.in_time
        sum+=working_hour-sum_break_hour(attendance)
      end
    end
    return sum
  end

  def sec_to_jp(sec)
    (Time.parse("1/1") + (sec)).strftime("%H時間%M分%S秒")
  end

  def sum_salary(attendances,user)
    sum=0
    attendances.each do |attendance|
      if attendance.out_time.present? then
        sum+=(working_hour(attendance)-sum_break_hour(attendance))/3600*user.travel_cost
      end
    end
    return sum
  end

  def sum_earning(earnings)
    sum=0
    earnings.each do |earning|
        sum+=earning.revenue
    end
    return sum
  end
end
