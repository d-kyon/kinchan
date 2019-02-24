class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :in_time
      t.datetime :out_time
      t.boolean :is_remote,           null: false, default: false

      t.timestamps
    end
  end
end
