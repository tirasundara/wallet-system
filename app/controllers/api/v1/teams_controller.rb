module Api
  module V1
    class TeamsController < ApplicationController
      def index
        teams = Team.all
        render json: teams
      end

      def show
        team = Team.find(params[:id])
        render json: team.as_json(include: { wallet: { only: [ :id, :balance ] } })
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Team not found" }, status: :not_found
      end
    end
  end
end
