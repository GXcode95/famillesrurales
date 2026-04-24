class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.includes(:activities).order(:name)
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: "Catégorie créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Catégorie mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_url, notice: "Catégorie supprimée avec succès."
    else
      redirect_to categories_url, alert: "Impossible de supprimer cette catégorie car elle est utilisée par des activités."
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
