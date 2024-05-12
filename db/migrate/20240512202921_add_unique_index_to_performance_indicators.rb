class AddUniqueIndexToPerformanceIndicators < ActiveRecord::Migration[7.0]
  def change
    add_index :performance_indicators, :description, unique: true
  end
end
