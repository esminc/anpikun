class HanedaController < ApplicationController
  def show
    @body = CalendarClient.get_body(params[:email])
  end
end
