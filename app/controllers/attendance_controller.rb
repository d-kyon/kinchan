class AttendanceController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_current_user!
  before_action :set_user, only: [:show, :index,:in_time,:out_time,:remote_in_time,:break_in_time,:break_out_time]
  before_action :set_time, only: [:in_time, :out_time,:remote_in_time,:break_in_time,:break_out_time]
  before_action :set_attendance, only: [:break_in_time,:break_out_time]
  def index
    if @user.attendance.empty? then
      in_time=Time.local(1900,1,1,9,0,0,0)
      out_time=Time.local(1900,1,1,9,0,0,0)
      Attendance.create!(user_id:@user.id,in_time:in_time,out_time:out_time)
    end
  end

  def show
  end

  def in_time
    Attendance.create!(user_id:@user.id,in_time:@time)
    redirect_to attendance_index_path(@user.id)
  end

  def remote_in_time
    Attendance.create!(user_id:@user.id,in_time:@time,is_remote:true)
    redirect_to attendance_index_path(@user.id)
  end

  def out_time
    Attendance.where(user_id:@user.id).last.update!(out_time:@time,content:params[:content])
    redirect_to attendance_index_path(@user.id)
  end

  def break_in_time
    Break.create!(user_id:@user.id,attendance_id:@attendance.id,in_time:@time)
    redirect_to attendance_index_path(@user.id)
  end

  def break_out_time
    Break.where(user_id:@user.id,attendance_id:@attendance.id).last.update!(out_time:@time)
    redirect_to attendance_index_path(@user.id)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
  def set_time
    @time=Time.now+9*60*60
  end
  def authenticate_current_user!
    if current_user.id!=params[:id].to_i then
      redirect_to home_index_path
    end
  end
  def set_attendance
    @attendance=Attendance.where(user_id:@user.id).last
  end

end
