module AttendanceHelper
  def is_working(user)
    if Attendance.find_by(user_id:user.id).present? then
      last_attendance=Attendance.where(user_id:user.id).last
      if last_attendance.out_time.nil? then
        return true
      end
    end
  end

  def is_break(user)
    if Break.find_by(user_id:user.id).present? then
      last_break=Break.where(user_id:user.id).last
      if last_break.in_time.present? && last_break.out_time.nil? then
        return true
      end
    end
  end

  def is_remote(user)
    if Attendance.find_by(user_id:user.id).present? then
      last_attendance=Attendance.where(user_id:user.id).last
        return last_attendance.is_remote
    end
  end
end
