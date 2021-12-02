function Find_Sets( fn_in )
%   fn_in = for each card -> [card_num, card_color, shape_count, card_shape, card_texture];
    sets_found = {};
    set_count = 1;

    % Iterate on the cell array passed to this function as a parameter and
    % consider 3 cards at a time
    for card1 = 1:length(fn_in)
        for card2 = card1:length(fn_in)
            for card3 = card2:length(fn_in)
                % Continue only if we are looking at 3 different cards, if
                % not go to the next iteration
                if card1 ~= card2 && card2 ~= card3 && card1 ~= card3
                    valid_count = 0;
                    % Check if the color of the cards are all the same or
                    % all unique, if so add 1 to valid count indicating
                    % that one of the feature satisfies the game rule
                    if strcmp(fn_in{card1, 2}, fn_in{card2, 2}) && strcmp(fn_in{card2, 2}, fn_in{card3, 2}) ...
                            && strcmp(fn_in{card1, 2}, fn_in{card3, 2})
                        valid_count = valid_count + 1;
                    elseif ~strcmp(fn_in{card1, 2},fn_in{card2, 2}) && ~strcmp(fn_in{card2, 2}, fn_in{card3, 2}) ...
                            && ~strcmp(fn_in{card1, 2},fn_in{card3, 2})
                        valid_count = valid_count + 1;
                    end

                    % Check of the shape count of all 3 cards are all the
                    % same or are all unique, if so add 1 to valid count
                    % denoting another feature is following the rules to
                    % find the set
                    if fn_in{card1, 3} == fn_in{card2, 3} && fn_in{card2, 3} == fn_in{card3, 3} ...
                            && fn_in{card1, 3} == fn_in{card3, 3}
                        valid_count = valid_count + 1;
                    elseif fn_in{card1, 3} ~= fn_in{card2, 3} && fn_in{card2, 3} ~= fn_in{card3, 3} ...
                            && fn_in{card1, 3} ~= fn_in{card3, 3}
                        valid_count = valid_count + 1;
                    end

                    % Check of the shape of all 3 cards are all the
                    % same or are all unique, if so add 1 to valid count
                    % denoting another feature is following the rules to
                    % find the set
                    if fn_in{card1, 4} == fn_in{card2, 4} && fn_in{card2, 4} == fn_in{card3, 4} ...
                            && fn_in{card1, 4} == fn_in{card3, 4}
                        valid_count = valid_count + 1;
                    elseif fn_in{card1, 4} ~= fn_in{card2, 4} && fn_in{card2, 4} ~= fn_in{card3, 4} ...
                            && fn_in{card1, 4} ~= fn_in{card3, 4}
                        valid_count = valid_count + 1;
                    end

                    % Check of the shape shading of all 3 cards are all the
                    % same or are all unique, if so add 1 to valid count
                    % denoting another feature is following the rules to
                    % find the set
                    if fn_in{card1, 5} == fn_in{card2, 5} && fn_in{card2, 5} == fn_in{card3, 5} ...
                            && fn_in{card1, 5} == fn_in{card3, 5}
                        valid_count = valid_count + 1;
                    elseif fn_in{card1, 5} ~= fn_in{card2, 5} && fn_in{card2, 5} ~= fn_in{card3, 5} ...
                            && fn_in{card1, 5} ~= fn_in{card3, 5}
                        valid_count = valid_count + 1;
                    end

                    % If all 4 features follow the rules to be considered a
                    % set, add them to a cell array
                    if valid_count == 4
                        sets_found{set_count, 1} = fn_in{card1, 1};
                        sets_found{set_count, 2} = fn_in{card2, 1};
                        sets_found{set_count, 3} = fn_in{card3, 1};
                        set_count = set_count + 1;
                    end
                end
            end
        end
    end

    % Once we are done iterating over all the cards, loop over the found
    % sets and print them all out to the console.
    fprintf("\nAll Possible Sets in this Image: \n");
    for set_idx = 1:size(sets_found, 1)
        fprintf("Set #%d: Card %d, Card %d, Card %d\n", set_idx, sets_found{set_idx, 1}, sets_found{set_idx, 2}, sets_found{set_idx, 3})
    end
end