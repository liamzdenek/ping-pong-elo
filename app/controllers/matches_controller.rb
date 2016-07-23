class MatchesController < ApplicationController
    def new
        @players = Player.all
    end

    def index
	    @matches = Match.last(20).reverse()
        @participants = Participant.where(match_id: @matches)
        @players = Player.find(@participants.pluck(:player_id))        
    end

    def show
	    @match = Match.find(params[:id])
        participants = Participant.where(match_id: @match)
        print participants
        winner_id = participants.select { |p| p.is_winner }.pluck(:player_id)
        loser_id = participants.select { |p| !p.is_winner }.pluck(:player_id)
        if winner_id && winner_id[0]
            @winner = Player.find(winner_id)[0]
        end
        if loser_id && winner_id[0]
            @loser = Player.find(loser_id)[0]
        end
        #@players = Player.all
    end

    def edit
	    @match = Match.find(params[:id])
        participants = Participant.where(match_id: @match)
        @winner = Player.find(participants.select { |p| p.is_winner }.pluck(:player_id))[0]
        @loser = Player.find(participants.select { |p| !p.is_winner }.pluck(:player_id))[0]
        @players = Player.all
    end

    def update
        Match.transaction do
            @match = Match.find(params[:id]);
            @match.day = params[:match][:day];
            @match.save!

            @winner_player = Player.find(params[:match][:winner_id])
            @loser_player = Player.find(params[:match][:loser_id])

            puts "winner"
            puts @winner_player
            puts "loser"
            puts @loser_player

            if !@winner_player || !@loser_player
                flash[:update_errors] = "Couldn't find one or both of the players specified"
                redirect_back(fallback_location: "/matches/"+@match.id.to_s+"/edit")
                raise ActiveRecord::Rollback
            end

            @winner = Participant.where(match_id: @match, is_winner: true)[0]
            if !@winner
                flash[:update_errors] = "Couldn't find the winner record"
                redirect_back(fallback_location: "/matches/"+@match.id.to_s+"/edit")
                raise ActiveRecord::Rollback
            end
            
            @loser = Participant.where(match_id: @match, is_winner: true)[0]
            if !@loser
                flash[:update_errors] = "Couldn't find the loser record"
                redirect_back(fallback_location: "/matches/"+@match.id.to_s+"/edit")
                raise ActiveRecord::Rollback
            end
            
            @loser.player_id = @loser_player.id;
            @winner.player_id = @winner_player.id;

            @loser.save!
            @winner.save!
        end
        redirect_to  "/matches/"+@match.id.to_s
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
