class CreatePerformanceIndicators < ActiveRecord::Migration[7.0]
  def change
    create_table :performance_indicators do |t|
      t.string :description

      t.timestamps
    end
  end
end
