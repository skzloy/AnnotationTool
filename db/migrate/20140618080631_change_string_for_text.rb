class ChangeStringForText < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.change :text, :text
    end
  end
end
