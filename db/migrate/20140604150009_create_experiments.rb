class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.integer :blockSize
      t.references :article, index: true

      t.timestamps
    end
  end
end
