class CreateBreaks < ActiveRecord::Migration[5.2]
  def change
    create_table :breaks do |t|
      t.datetime :in_time
      t.datetime :out_time
      t.references :user, index: true, foreign_key: true
      t.references :attendance, index: true, foreign_key: true

      t.timestamps
    end
  end
end
