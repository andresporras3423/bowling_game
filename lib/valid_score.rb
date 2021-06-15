module ValidScore
    @@valid_score = (0..10).map { |i| [i.to_s, i] }.to_h
    @@valid_score['F'] = 0
end