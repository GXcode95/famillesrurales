class RenameCategoriesIdToCategoryIdInActivities < ActiveRecord::Migration[8.2]
  def up
    # Vérifier si la colonne categories_id existe encore
    if column_exists?(:activities, :categories_id)
      # Supprimer l'ancienne clé étrangère
      remove_foreign_key :activities, :categories, column: :categories_id if foreign_key_exists?(:activities, :categories, column: :categories_id)
      
      # Supprimer l'ancien index s'il existe
      remove_index :activities, name: "index_activities_on_categories_id" if index_exists?(:activities, :categories_id, name: "index_activities_on_categories_id")
      
      # Renommer la colonne
      rename_column :activities, :categories_id, :category_id
      
      # Ajouter le nouvel index
      add_index :activities, :category_id, name: "index_activities_on_category_id" unless index_exists?(:activities, :category_id, name: "index_activities_on_category_id")
      
      # Ajouter la nouvelle clé étrangère
      add_foreign_key :activities, :categories, column: :category_id unless foreign_key_exists?(:activities, :categories, column: :category_id)
    elsif column_exists?(:activities, :category_id)
      # La colonne a déjà été renommée, on s'assure juste que l'index et la clé étrangère sont corrects
      add_index :activities, :category_id, name: "index_activities_on_category_id" unless index_exists?(:activities, :category_id, name: "index_activities_on_category_id")
      add_foreign_key :activities, :categories, column: :category_id unless foreign_key_exists?(:activities, :categories, column: :category_id)
    end
  end

  def down
    # Vérifier si la colonne category_id existe
    if column_exists?(:activities, :category_id)
      # Supprimer la nouvelle clé étrangère
      remove_foreign_key :activities, :categories, column: :category_id if foreign_key_exists?(:activities, :categories, column: :category_id)
      
      # Supprimer le nouvel index
      remove_index :activities, name: "index_activities_on_category_id" if index_exists?(:activities, :category_id, name: "index_activities_on_category_id")
      
      # Renommer la colonne
      rename_column :activities, :category_id, :categories_id
      
      # Ajouter l'ancien index
      add_index :activities, :categories_id, name: "index_activities_on_categories_id" unless index_exists?(:activities, :categories_id, name: "index_activities_on_categories_id")
      
      # Ajouter l'ancienne clé étrangère
      add_foreign_key :activities, :categories, column: :categories_id unless foreign_key_exists?(:activities, :categories, column: :categories_id)
    end
  end
end
