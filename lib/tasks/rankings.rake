require 'whole_history_rating'

namespace :rankings do
    desc "generates the elo rankings, should be called via cron job daily"
    task regenerate_elo: :environment do 
        ofs = -1;
        per_page = 2;
        running = true;
        
        @whr = WholeHistoryRating::Base.new
        
        while running
            ofs+=1
            @matches = Match.offset(ofs*per_page).limit(per_page)
            if @matches.empty?
                running = false;
                break;
            end
            @participants = Participant.where(match_id: @matches)

            @matches.each { |match|
                winner = @participants.select { |p| p.is_winner && p.match_id == match.id }[0]
                loser = @participants.select { |p| !p.is_winner && p.match_id == match.id }[0]
                if !winner || !loser
                    fail "couldnt find player for match: "+match.id
                end
                if winner.player_id == loser.player_id
                    puts "Skipping self played game, match id: "+match.id.to_s
                    next
                end
                puts "Adding match with winner: "+winner.player_id.to_s+" loser: "+loser.player_id.to_s
                @whr.create_game(
                    winner.player_id.to_s,
                    loser.player_id.to_s,
                    "B", # indicate first id provided won
                    match.day,
                    0 # handicap
                )
            }
        end

        @whr.iterate(50)

        

        ApplicationRecord.transaction do
            batch = Batch.new()
            batch.save()
            
            players = @whr.players
            players.each { |doublet|
                player_id = doublet[0]
                player = doublet[1]
                
                ratings = @whr.ratings_for_player(player_id)
                ratings.each{ |rating|
                    Elo.new(
                        batch_id: batch.id,
                        player_id: player_id,
                        day: rating[0],
                        elo: rating[1],
                        uncertainty: rating[2],
                    ).save()
                }
            }
            #raise ActiveRecord::Rollback
        end
    end

end
