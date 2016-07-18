class MatchesController < ApplicationController
    def new
        @players = Player.all
    end

    def create
        Player.transaction do 
            @winner = Player.find(params[:match][:winner_id])
            @loser = Player.find(params[:match][:loser_id])

            if !@winner || !@loser
                flash[:match_errors] = "Couldn't find one of the players specified"
                redirect_back(fallback_location: "/matches/new")
                raise ActiveRecord::Rollback
            end

            @match = Match.new(
                params.require(:match).permit(:date_year, :date_month, :date_day)
            )
            if !@match.save
                flash[:match_errors] = @match.errors.full_messages.to_sentence
                redirect_back(fallback_location: "/matches/new")
                raise ActiveRecord::Rollback
            end

            @winner = Participant.new()
            @winner.match_id = @match.id;
            @winner.player_id = params[:match][:winner_id];
            @winner.is_winner = true

            @loser = Participant.new()
            @loser.match_id = @match.id;
            @loser.player_id = params[:match][:loser_id];
            @loser.is_winner = false

            if !@winner.save
                flash[:match_errors] = @winner.errors.full_messages.to_sentence
                redirect_back(fallback_location: "/matches/new")
                raise ActiveRecord::Rollback
            end

            if !@loser.save
                flash[:match_errors] = @loser.errors.full_messages.to_sentence
                redirect_back(fallback_location: "/matches/new")
                raise ActiveRecord::Rollback
            end

        end
        redirect_to "/matches/"+@match.id.to_s
    end
end
