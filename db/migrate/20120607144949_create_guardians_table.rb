class CreateGuardiansTable < ActiveRecord::Migration
  def change
    create_table :guardians do |t|
    	t.string   :name
      t.string   :surname
      t.string   :name_reading
      t.string   :surname_reading
      t.string   :relationship
    end 
  end
end