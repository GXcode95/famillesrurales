class StaffsController < ApplicationController
  before_action :set_staff, only: %i[show edit update destroy]

  def index
    @staffs = Staff.order(:name)
  end

  def show; end

  def new
    @staff = Staff.new
  end

  def edit; end

  def create
    @staff = Staff.new(staff_params)

    if @staff.save
      redirect_to @staff, notice: "Membre du staff créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @staff.update(staff_params)
      redirect_to @staff, notice: "Membre du staff mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @staff.destroy
    redirect_to staffs_url, notice: "Membre du staff supprimé avec succès."
  end

  private

  def set_staff
    @staff = Staff.find(params[:id])
  end

  def staff_params
    params.require(:staff).permit(:name, :email, :job, :phone)
  end
end

