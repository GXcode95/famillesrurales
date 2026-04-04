# frozen_string_literal: true

class EventsController < ApplicationController
  include ManageGalleryPhotos

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.includes(gallery_photos: { image_attachment: :blob }).order(date: :asc)
  end

  def show; end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    if @event.save
      failed = process_new_gallery_photos_for(
        @event,
        files: event_gallery_params[:gallery_images],
        tag_list: event_gallery_params[:gallery_tag_list]
      )
      if failed
        redirect_to edit_event_path(@event),
                    alert: "Événement créé, mais l'ajout de photos a échoué : #{failed.errors.full_messages.to_sentence}"
      else
        redirect_to @event, notice: "Événement créé avec succès."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      process_gallery_photos_updates(@event, "event")
      failed = process_new_gallery_photos_for(
        @event,
        files: event_gallery_params[:gallery_images],
        tag_list: event_gallery_params[:gallery_tag_list]
      )
      notice = "Événement mis à jour avec succès."
      if failed
        flash[:alert] = "Certaines photos n'ont pas été ajoutées : #{failed.errors.full_messages.to_sentence}"
      end
      redirect_to @event, notice: notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: "Événement supprimé avec succès."
  end

  private

  def set_event
    @event = Event.includes(gallery_photos: [:tags, { image_attachment: :blob }]).find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :body)
  end

  def event_gallery_params
    return {} unless params[:event]

    params.require(:event).permit(:gallery_tag_list, gallery_images: [])
  end
end
