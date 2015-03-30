class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:create]
  # GET /printers/1/reservations
  # GET /printers/1/reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /printers/1/reservations/1
  # GET /printers/1/reservations/1.json
  def show
    render :layout => false
  end

  # GET /printers/1/reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /printers/1/reservations/1/edit
  def edit
  end

  # POST /printers/1/reservations
  # POST /printers/1/reservations.json
  def create
    @reservation = current_user.reservations.build(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to controller: 'printers', action: 'index', date: @reservation.starts_at_date }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /PUT /printers/1/reservations/1
  # PATCH /PUT /printers/1/reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /printers/1/reservations/1
  # DELETE /printers/1/reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to printers_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_printer
      @printer = Printer.find(params[:printer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      p = params.require(:reservation).permit(:printer_id, :starts_at_date, :starts_at_time, :duration)
    end
end
