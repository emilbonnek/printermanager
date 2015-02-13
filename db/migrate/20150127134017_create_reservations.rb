class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps null: false
      t.references :printer
    end
  end
end
