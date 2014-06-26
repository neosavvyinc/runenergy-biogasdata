class AddCommentLineToColumnConversionMapping < ActiveRecord::Migration
  def change
    add_column :column_conversion_mappings, :comment_entry, :string
  end
end
