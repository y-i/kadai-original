class RoomsController < ApplicationController
  before_action :require_user_logged_in

  def index
    @rooms = Room.all.order('updated_at DESC')
  end

  def create
    @room = Room.new(room_params)

    if current_user.owner_room_id == nil && @room.save
      current_user.update_columns(owner_room_id: @room.id)
      flash[:success] = 'ルームを作成しました。'
      redirect_to @room
    else
      flash.now[:danger] = 'ルームの作成に失敗しました。'
      render :new
    end
  end

  def new
    @room = Room.new

    if current_user.owner_room_id != nil
      flash[:danger] = 'ルームはひとつしか作成できません'
      redirect_to @room
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def show
    @room = Room.find(params[:id])
    @owner = @room.owner.find_by(owner_room_id: @room.id)
    @guest = @room.guest.find_by(owner_room_id: @room.id)
  end

  def update
    @room = Room.find(params[:id])
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:success] = 'ルームを削除しました'
    redirect_to @room
  end

  def update_room_num
    @room = Room.find_by(id: params[:id])
    params.merge!(JSON.parse(request.body.read, {:symbolize_names => true}))

    if @room == nil
      render :json => {'result': 'no room', "param": params}
    elsif current_user.owner_room_id != @room.id
      render :json => {'result': 'you are not owner', 'cu': current_user.owner_room_id, 'room': @room, "param": params}
    else
      @room.update_columns(number: params[:skyway_id])
      render :json => {'result': 'success', "param": params}
    end
  end

  private

  def room_params
    params.require(:room).permit(:number, :comment)
  end
end
