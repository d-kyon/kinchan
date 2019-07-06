class WebhookController < ApplicationController
  include AttendanceHelper
  include ApplicationHelper
require 'net/http'
require 'uri'
protect_from_forgery :except => [:callback,:link,:redirect_lineaccount]
before_action :validate_signature,except: [:link,:redirect_lineaccount]

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "8a07c9e011896c323c85e04419f2d1bd"
      config.channel_token = "KfUDjPjJN5MsmM2n47jGENR/jas871Octfewdt6FllYcJ1Z7vfDSe8mJ5g6+tCGaHI4SbgAO3I6SzvvKPCid+bAM2sh6vMu5D2mTBtT3poDE5EzfTo9YuLiXHE5sW1R9Zf9sNUnZ7o9OLDhS8dOxgAdB04t89/1O/w1cDnyilFU="
    }
  end
  
  def link
    redirect_to new_user_session_path("linkToken"=>params[:linkToken])
  end
  
  def redirect_lineaccount
    nonce=rand(10 ** 50).to_s.rjust(30,'0')
    current_user.update(nonce:nonce)
    redirect_to "https://access.line.me/dialog/bot/accountLink?linkToken=#{params[:linkToken]}&nonce=#{nonce}"
  end

 def callback
 body = request.body.read
 events = client.parse_events_from(body)

 events.each { |event|
 case event
 when Line::Bot::Event::Message
  if User.exists?(line_user_id:event['source']['userId']) then
      quickReply = {
        "type": "text",
        "text": "下記から選択してください",
        "quickReply": {
            "items": [
              {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "勤務詳細",
                        "text": "勤務詳細"
                    }
                },
              {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "現在",
                        "text": "現在"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "出勤",
                        "text": "出勤"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "リモート出勤",
                        "text": "リモート出勤"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "退勤",
                        "text": "退勤"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "休憩開始",
                        "text": "休憩開始"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "休憩終了",
                        "text": "休憩終了"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "連携解除",
                        "text": "連携解除"
                    }
                }
            ]
        }
    }
      user=User.find_by(line_user_id:event['source']['userId'])
      time=Time.now+9*60*60
    if is_working(user)!=true and is_break(user) != true and Attendance.where(user_id:user.id).last.content.nil? then
        Attendance.where(user_id:user.id).last.update!(content:event.message["text"])
        messages = [{
                type: 'text',
                text: "お疲れ様でした！"
              }]
        attendance=Attendance.where(user_id:user.id).last
        summary = {
                type: 'text',
                text: "
出勤時刻：#{attendance.in_time.try(:strftime, "%H時%M分%S秒")}
退勤時刻：#{attendance.out_time.try(:strftime, "%H時%M分%S秒")}
勤務時間：#{sec_to_jp(working_hour(attendance))}
休憩時間：#{sec_to_jp(sum_break_hour(attendance))}
仕事時間：#{sec_to_jp(working_hour(attendance)-sum_break_hour(attendance))}
勤務内容：#{event.message["text"]}
"
              }
              messages.push(summary)
              messages.push(quickReply)
    else
      case event.message['text']
      when "ささ"
        
      when "勤務詳細"
        messages = [{
                  type: 'text',
                  text: "以下のURLより勤務詳細をご確認ください"
                },
                {
                  type: 'text',
                  text: "https://kinchan.work"
                }]
        messages.push(quickReply)
      when "連携解除"
        user.update(nonce:"",line_user_id:"")
        messages = [{
                  type: 'text',
                  text: "アカウント連携解除しました"
                }]
        quickReply = {
      "type": "text",
      "text": "下記の「アカウント連携する」をクリックしてください",
      "quickReply": {
          "items": [
                      {
                            "type": "action",
                            "action": {
                                "type": "message",
                                "label": "アカウント連携する",
                                "text": "連携"
                            }
                        }
                    ]
                }
            }
            messages.push(quickReply)
      when "出勤"
        if is_working(user)!=true then
          Attendance.create!(user_id:user.id,in_time:time)
          messages = [{
                  type: 'text',
                  text: "出勤登録しました"
                }]
          messages.push(quickReply)
        else
          messages = [{
                type: 'text',
                text: "すでに出勤しています"
              }]
              messages.push(quickReply)
        end
      when "リモート出勤"
        if is_working(user)!=true then
          Attendance.create!(user_id:user.id,in_time:time,is_remote:true)
          messages = [{
                  type: 'text',
                  text: "リモート出勤登録しました"
                }]
                messages.push(quickReply)
        else
          messages = [{
                type: 'text',
                text: "すでに出勤しています"
              }]
              messages.push(quickReply)
        end
      when "退勤"
        if is_working(user) and is_break(user) != true then
          Attendance.where(user_id:user.id).last.update!(out_time:time)
          messages = [{
                  type: 'text',
                  text: "退勤しました。勤務内容を入力してください"
                }]
        else
            messages = [{
                    type: 'text',
                    text: "出勤していないか休憩中です"
                  }]
                  messages.push(quickReply)
        end
      when "休憩開始"
        if is_working(user) and is_break(user) != true then
          attendance=Attendance.where(user_id:user.id).last
          Break.create!(user_id:user.id,attendance_id:attendance.id,in_time:time)
          messages = [{
                type: 'text',
                text: "休憩開始しました！"
              }]
              messages.push(quickReply)
        else
          messages = [{
                type: 'text',
                text: "出勤していないか、すでに休憩をしています"
              }]
              messages.push(quickReply)
        end
      when "休憩終了"
        if is_working(user) and is_break(user) then
          attendance=Attendance.where(user_id:user.id).last
          Break.where(user_id:user.id,attendance_id:attendance.id).last.update!(out_time:time)
          messages = [{
                type: 'text',
                text: "休憩終了しました！"
              }]
              messages.push(quickReply)
        else
          messages = [{
                type: 'text',
                text: "休憩中ではありません"
              }]
              messages.push(quickReply)
        end
      when "現在"
        if is_working(user) then
          if is_remote(user) then
            if is_break(user) then
              messages = [{
                type: 'text',
                text: "#{user.username}さんはリモート出勤で休憩中です"
              }]
              messages.push(quickReply)
            else
              messages = [{
                type: 'text',
                text: "#{user.username}はリモート出勤中です"
              }]
              messages.push(quickReply)
            end
          else
            if is_break(user) then
              messages = [{
                type: 'text',
                text: "#{user.username}はオフィス出勤で休憩中です"
              }]
              messages.push(quickReply)
            else
              messages = [{
                type: 'text',
                text: "#{user.username}はオフィス出勤中です"
              }]
              messages.push(quickReply)
            end
          end
        else 
          if Attendance.where(user_id:user.id).last.nil? then
            messages = [{
                  type: 'text',
                  text: "#{user.username}さんは勤務内容がまだ入力しておりません。勤務内容を入力してください"
                }]
          else
            messages = [{
                  type: 'text',
                  text: "#{user.username}さんは出勤していません"
                }]
            messages.push(quickReply)
          end
        end
      else #case event.message["text"]
            messages = [{
                  type: 'text',
                  text: "以下のメニューから選択してください"
                }]
                messages.push(quickReply)
      end #case event.message["text"]
    end
  else # if User.exists?
    if event.message["text"]=="連携" then
      uri = URI.parse("https://api.line.me/v2/bot/user/#{event['source']['userId']}/linkToken")
      https = Net::HTTP.new(uri.host,uri.port)
      #httpsだとこれ必要
      https.use_ssl = true
      #use_ssl value changed, but session already started (IOError)
      #にならないように、sslをONにしてから、request生成
      request = Net::HTTP::Post.new(uri.path)
      #ヘッダーにトークンを追記
      request["Authorization"]= "Bearer #{client.channel_token}"
      res = https.request(request)
      #stringをhashに変換
      linkToken=eval("#{res.body}")[:linkToken]
      messages = [{
              type: 'text',
              text: "https://kinchan.work/link?linkToken=#{linkToken}"
            }]
          quickReply = {
    "type": "text",
    "text": "上記のURLを押してKinchanにログインしてください！",
    "quickReply": {
        "items": [
          {
                "type": "action",
                "action": {
                    "type": "message",
                    "label": "アカウント連携する",
                    "text": "連携"
                }
            }
        ]
    }
}
    else
    messages = [{
              type: 'text',
              text: "まずはアカウント連携をしてください"
            }]
          quickReply = {
    "type": "text",
    "text": "下記の「アカウント連携する」をクリックしてください",
    "quickReply": {
        "items": [
          {
                "type": "action",
                "action": {
                    "type": "message",
                    "label": "アカウント連携する",
                    "text": "連携"
                }
            }
        ]
    }
}
    end

    messages.push(quickReply)
  end # if User.exists?
  
 when Line::Bot::Event::AccountLink
   if event["link"]["result"]=="ok" then
     User.find_by(nonce: event["link"]["nonce"]).update(line_user_id: event['source']['userId'])
   end
    messages = [{
            type: 'text',
            text: "#{User.find_by(nonce: event["link"]["nonce"]).username}さん、連携完了しました！"
          }]
    quickReply = {
        "type": "text",
        "text": "下記から選択してください",
        "quickReply": {
            "items": [
              {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "現在",
                        "text": "現在"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "出勤",
                        "text": "出勤"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "リモート出勤",
                        "text": "リモート出勤"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "退勤",
                        "text": "退勤"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "休憩開始",
                        "text": "休憩開始"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "休憩終了",
                        "text": "休憩終了"
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "message",
                        "label": "連携解除",
                        "text": "連携解除"
                    }
                }
            ]
        }
    }
    messages.push(quickReply)
 end #case event
 
    client.reply_message(event['replyToken'], messages)
    }
 end
end
