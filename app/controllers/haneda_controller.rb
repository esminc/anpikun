class HanedaController < ApplicationController
  def show
    @body = CalendarClient.get_body(@client, params[:email]) if params[:email]
  end
end
